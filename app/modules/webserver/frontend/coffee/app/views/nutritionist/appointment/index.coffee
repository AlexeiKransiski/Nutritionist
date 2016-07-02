class App.Views.Nutritionist.Appointment.Index extends Null.Views.Base
  template: JST['app/nutritionist/appointment/index.html']

  initialize: (options) =>
    super

    @model = new App.Models.Appointment(_id: @options.modelID)

    @patientPreferences = new App.Models.PatientPreferences()
    @foodList = new App.Collections.FoodLog()
    @mood = new App.Collections.Status()
    @exerciseList = new App.Collections.ExerciseLog()

    @header = new App.Views.Nutritionist.Appointment.Header
      model: @model

    @my_profile = new App.Views.Nutritionist.Appointment.MyProfile.Index
      model: @model
      mood:@mood
      foodList:@foodList
      exerciseList:@exerciseList
      patientPreferences:@patientPreferences

    @status = new App.Views.Nutritionist.Appointment.Status.Index
      model: @model

    @preferences = new App.Views.Nutritionist.Appointment.Preferences.Index
      model: @model
      foodList:@foodList
      exerciseList:@exerciseList
      patientPreferences:@patientPreferences

    @timeline = new App.Views.Nutritionist.Appointment.Timeline.Index
      model: @model

    @listenTo @model, 'sync', @fetchData
    @model.fetch()
    return this

  events:
    'shown.bs.tab [data-toggle="tab"]': 'onTabShown'

  render: () =>
    super
    return this

  getContext: () =>
    return {model: @model}

  setupViews: () =>
    @addView @header.render(), '[data-role="header"]'
    @addView @my_profile.render(), '[data-role="my-profile"]'
    @addView @status.render(), '[data-role="status"]'
    @addView @preferences.render(), '[data-role="preferences"]'
    @addView @timeline.render(), '[data-role=timeline]'
    return

  fetchData: () =>
    async.parallel([
      # get patient preferences
      (cb) =>
        @patientPreferences.set({_id: @model.get('patient').patientPreferences})
        @patientPreferences.fetch({
          success: (model, res) =>
            cb(null, true)
          error: (model, res) =>
            cb(res.responseJSON, null)
        })
      ,
      # get food list
      (cb) =>
        @foodList.fetch({
          data:
            user: @model.get('patient')._id
          success: (model, res) =>
            cb(null, true)
          error: (model, res) =>
            cb(res.responseJSON, null)
        })
      ,
      # get mood list
      (cb) =>
        @mood.fetch({
          data:
            user: @model.get('patient')._id
          success: (model, res) =>
            cb(null, true)
          error: (model, res) =>
            cb(res.responseJSON, null)
        })
      ,
      # get exercise list
      (cb) =>
        @exerciseList.fetch({
          data:
            user: @model.get('patient')._id
          success: (model, res) =>
            cb(null, true)
          error: (model, res) =>
            cb(res.responseJSON, null)
        })
      ,

    ], (err, res) =>
      if err?
        return @error('Error getting info')
      @setupViews()
    )

  onTabShown: (event) =>
    console.log "TAB", event.target
    $tab = $(event.target)

    if $tab.attr('href') == '#status'
      @status.showCharts()

class App.Views.Nutritionist.ClinicHistory.Index extends Null.Views.Base
  template: JST['app/nutritionist/clinic_history/index.html']

  initialize: (options) =>
    super

    @model = new App.Models.User({_id: options.modelID})
    @patientPreferences = new App.Models.PatientPreferences()
    @foodList = new App.Collections.FoodLog()
    @mood = new App.Collections.Status()
    @exerciseList = new App.Collections.ExerciseLog()

    @collection = new App.Collections.Appointments()

    @profile = new App.Views.Nutritionist.ClinicHistory.Profile
      model: @model
      mood:@mood
      foodList:@foodList
      exerciseList:@exerciseList
      patientPreferences:@patientPreferences

    @appointments = new App.Views.Nutritionist.ClinicHistory.List
      model: @model
      collection: @collection

    @listenTo @model, 'sync', @fetchData
    @model.fetch()
    return this

  render: () =>
    super
    @$('.progress-bar', @el).progressbar()
    return this


  setupViews: () =>
    @addView @profile.render(), '[data-role="profile-view"]'
    @addView @appointments.render(), '[data-role="list"]'
    return

  fetchData: () =>
    async.parallel([
      # get patient appointments
      (cb) =>
        @collection.fetch
          data:
            patient: @model.id
          success: (model, res) =>
            cb(null, true)
          error: (model, res) =>
            cb(res.responseJSON, null)


      ,
      # get patient preferences
      (cb) =>
        @patientPreferences.set({_id: @model.get('patientPreferences')._id})
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
            user: @model.id
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
            user: @model.id
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
            user: @model.id
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

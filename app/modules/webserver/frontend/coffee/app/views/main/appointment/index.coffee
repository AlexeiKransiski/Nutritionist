class App.Views.Main.Appointment.Index extends Null.Views.Base
  template: JST['app/main/appointment/index.html']

  that = null

  initialize: (options) =>
    super

    @fetched = false
    @model = new App.Models.Appointment(_id: @options.modelID)

    @patientPreferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))
    @foodList = new App.Collections.FoodLog()
    @mood = new App.Collections.Status()
    @exerciseList = new App.Collections.ExerciseLog()


    # my profile tab
    @my_profile = new App.Views.Main.Appointment.MyProfile.Index
      active: true
      model: @model
      mood:@mood
      foodList:@foodList
      exerciseList:@exerciseList
      patientPreferences:@patientPreferences

    # status chart tab
    @status_chart = new App.Views.Main.Appointment.StatusChart.Index
     active: false
     model: @model

    # preferecens tab
    @preferences = new App.Views.Main.Appointment.Preferences.Index
      active: false
      model: @model
      foodList:@foodList
      exerciseList:@exerciseList

    @timeline = new App.Views.Main.Appointment.Timeline.Index
      model: @model

    @listenTo @model, 'change', @render
    return this

  events:
    'click [data-toggle="tab"]': 'onTabClicked'
    'click .completed': 'onCloseAppointment'
    'click #sendCommentAppointment': 'onSendComment'
    'shown.bs.tab [data-toggle="tab"]': 'onTabShown'

  render: =>
    super

    if @fetched
      @setupViews()
      return
    @fetchData()
    return this

  # getContext: =>
  #   return {model: @model}

  fetchData: () =>
    async.parallel([
      # get appointment
      (cb) =>
        @model.fetch({
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
            user:app.me.id
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
            user:app.me.id
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
            user:app.me.id
          success: (model, res) =>
            cb(null, true)
          error: (model, res) =>
            cb(res.responseJSON, null)
        })
      ,

    ], (err, res) =>
      if err?
        return @error('Error getting info')
      @fetched = true
      @setupViews()
    )


  setupViews: () =>
    @appendView @my_profile.render(), '[data-role=tabs]'
    @appendView @status_chart.render(), '[data-role=tabs]'
    @appendView @preferences.render(), '[data-role=tabs]'
    @appendView @timeline.render(), '[data-role="timeline"]'

  onTabShown: (event) =>
    console.log "TAB", event.target
    $tab = $(event.target)

    if $tab.attr('href') == '#statu'
      @status_chart.showCharts()


  onTabClicked: (event) =>
    $tab = $(event.target)
    unless $tab.prop("tagName") == 'A'
      return

  onCloseAppointment: (event) =>
    event.preventDefault()
    @$el.block()
    @model.save({status: 'completed'}, {
      patch: true
      success: =>
        @$el.unblock()
        @render()
    })


  onSendComment: (event) =>
    reply=
      message: $("#commentMessage").val()
      status: $('input[name=options]:checked').val()
      sender: app.me.id

    @model.get("replies").push reply

    that = @
    @model.save({
      success: =>
        @render
    })

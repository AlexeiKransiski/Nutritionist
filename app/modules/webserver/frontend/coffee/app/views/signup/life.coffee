class App.Views.Signup.Life extends Null.Views.Base
  template: JST['app/signup/life.html']

  events:
    'click #next-step': 'onNextStep'

  @maintain=null

  initialize: ->
    @maintain=""
    @patient_preferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))

    # Setting initial values
    @patient_preferences.set('weather', 'cold')
    @patient_preferences.set('activity', 'sedentary')
    @patient_preferences.set('workout', 15)
    @patient_preferences.set('maintain', 'lose')

  render: ->
    super

    that = this

    @$('#personalinfo').show();
    @$('#personalinfo .flexslider').flexslider
      animation: 'fade'
      animationLoop: false
      slideshow: false
      after: (slider) ->
        $ele = slider.slides.eq(slider.currentSlide)
        console.log "Select next"
        if $ele.closest('.flexslider').prop('id') == "maintain"
          that.maintain=$ele.data('value')

        that.patient_preferences.set($ele.closest('.flexslider').prop('id'), $ele.data('value'))
        return

    @

  onNextStep: ->

    text = ""
    if @maintain == "lose"
      text = "I WANT TO LOSE WEIGHT"
    else if @maintain == "maintain"
      text = "I WANT TO MAINTAIN WEIGHT"
    else if @maintain == "gain"
      text = "I WANT GAIN WEIGHT"

    goals=
      text:text
      motivation:"..."

    app.me.set "goals", goals

    @patient_preferences.save {}, {
      wait: true
      success: (model, response) =>
        app.me.setValue {patientPreferences: model.toJSON()}
        app.routers[1].navigate("preferences", {trigger: true})
      error: (model, response) =>
        console.log "ERROR patient prefernces: ", model, response
    }

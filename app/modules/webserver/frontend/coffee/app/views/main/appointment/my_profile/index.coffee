class App.Views.Main.Appointment.MyProfile.Index extends App.Views.Base
  template: JST['app/main/appointment/my_profile/index.html']
  className: 'tab-pane fade in'
  id: 'profile'

  options:
    active: false
    model: null
    mood:null
    foodList:null
    exerciseList:null
    patientPreferences:null

  initialize: (options) =>
    super

    _.extend @options, options

    return this

  render: () =>
    super

    @$el.addClass('active') if @options.active

    @$('.progress-bar', @el).progressbar()

    return this

  getContext: ->
    result = super
    result['model'] = @options.model
    result['statusOveral'] = @options.mood
    result['foodList'] = @options.foodList
    result['exerciseList'] = @options.exerciseList
    result['patientPreferences'] = @options.patientPreferences
    return result

class App.Views.Nutritionist.Appointment.MyProfile.Index extends Null.Views.Base
  template: JST['app/nutritionist/appointment/my_profile/index.html']

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
    @$('.progress-bar', @el).progressbar()
    return this

  getContext: =>
    result = super
    result['model'] = @options.model
    result['statusOveral'] = @options.mood
    result['foodList'] = @options.foodList
    result['exerciseList'] = @options.exerciseList
    result['patientPreferences'] = @options.patientPreferences
    return result

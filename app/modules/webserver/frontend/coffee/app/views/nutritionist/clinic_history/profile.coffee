class App.Views.Nutritionist.ClinicHistory.Profile extends Null.Views.Base
  template: JST['app/nutritionist/clinic_history/profile.html']
  tagName: 'div'
  className: 'col-md-12 historial'

  options: {}
  initialize: (options) =>
    super
    _.extend @options , options
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

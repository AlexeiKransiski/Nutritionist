class App.Views.Nutritionist.ClinicHistory.Row extends Null.Views.Base
  template: JST['app/nutritionist/clinic_history/row.html']
  tagName: 'tr'

  options: {}
  initialize: (options) =>
    super
    _.extend @options , options
    return this

  render: () =>
    super
    @$('.progress-bar', @el).progressbar()
    return this

  getContext: () =>
    return {model: @model}

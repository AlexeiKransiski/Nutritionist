class App.Views.Nutritionist.Appointment.Header extends Null.Views.Base
  template: JST['app/nutritionist/appointment/header.html']

  initialize: (options) =>
    super

    return this

  events:
    'click .back': 'onBackClick'


  render: () =>
    super
    return this

  getContext: () =>
    return {model: @model}

  onBackClick: (event) =>
    event.preventDefault()
    window.history.back()

class App.Models.Appointment extends Null.Models.Base
  urlRoot: '/api/v1/appointments'
  router: 'appointment/'

  parse: (response, options) ->
    response.date = new Date(response.date)
    return response

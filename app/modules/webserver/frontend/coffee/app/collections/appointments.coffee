class App.Collections.Appointments extends Null.Collections.Base
  url: '/api/v1/appointments'
  model: App.Models.Appointment
  router: 'appointment/'

  parse: (response, options) ->
    if response.data
      for progress in response.data
        progress.date = moment(progress.date)
    return response.data

  findAppointmentForDate: (date) =>
    date = moment(date)
    return @filter (item) =>
      item_date = moment(item.get('createdAt'))
      return date.format('YYYY/MM/DD') == item_date.format('YYYY/MM/DD')

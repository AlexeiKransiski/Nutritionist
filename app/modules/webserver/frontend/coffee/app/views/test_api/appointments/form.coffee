class App.Views.TestApi.Appointments.Form extends Null.Views.Base
  template: JST['app/test_api/appointments/form.html']

  form: '.appointment-form'

  permission: 'Appointment:create'
  initialize: (options) =>
    super

  events:
    'submit .appointment-form': 'saveModel'

  render: () =>
    super
    @users = new App.Views.Common.Helpers.Users.Select({el: $('select#patient', @$el), filter: {is_nutricionist: 0}})
    @nutricionist = new App.Views.Common.Helpers.Users.Select({el: $('select#nutricionist', @$el), filter: {is_nutricionist: 1}})

    @

  saveModel: (e) ->
    e.preventDefault()

    data = @getFormInputs $(@form)

    item =
      "patient": data.patient,
      "nutritionist": data.nutritionist,
      "date": moment("#{data.date} #{data.time}").toISOString(),

    console.log "Item data: ", item
    @collection.create item, {
      success: (model, response) =>
        console.log "Created", model, response
      error: (model, response) =>
        console.log "ERror", model, response
      wait: true

    }

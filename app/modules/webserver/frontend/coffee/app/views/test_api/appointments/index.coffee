class App.Views.TestApi.Appointments.Index extends Null.Views.Base
  template: JST['app/test_api/appointments/index.html']

  initialize: (options) =>
    super

    @collection = new App.Collections.Appointments()

    @form = new App.Views.TestApi.Appointments.Form
      collection: @collection
      authorizator: app.authorization
      subject: app.me.toJSON()

    @table = new App.Views.TestApi.Appointments.Table
      collection: @collection

  render: () =>
    super

    @appendView @form.render(), '.create-form'
    @appendView @table.render(), '.list'

    @collection.fetch()

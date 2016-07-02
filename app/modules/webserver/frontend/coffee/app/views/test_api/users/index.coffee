class App.Views.TestApi.Users.Index extends Null.Views.Base
  template: JST['app/test_api/users/index.html']

  initialize: (options) =>
    super

    @collection = new App.Collections.Users()

    @form = new App.Views.TestApi.Users.Form
      collection: @collection
      authorizator: app.authorization
      subject: app.me.toJSON()

    @table = new App.Views.TestApi.Users.Table
      collection: @collection

  render: () =>
    super

    @appendView @form.render(), '.create-form'
    @appendView @table.render(), '.list'

    @collection.fetch()

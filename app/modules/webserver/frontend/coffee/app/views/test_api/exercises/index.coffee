class App.Views.TestApi.Exercises.Index extends Null.Views.Base
  template: JST['app/test_api/exercises/index.html']

  initialize: (options) =>
    super

    @collection = new App.Collections.Exercises()

    @form = new App.Views.TestApi.Exercises.Form
      collection: @collection
      authorizator: app.authorization
      subject: app.me.toJSON()

    @table = new App.Views.TestApi.Exercises.Table
      collection: @collection

  render: () =>
    super

    @appendView @form.render(), '.create-form'
    @appendView @table.render(), '.list'

    @collection.fetch()

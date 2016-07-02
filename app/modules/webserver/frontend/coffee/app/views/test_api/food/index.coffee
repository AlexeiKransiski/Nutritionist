class App.Views.TestApi.Food.Index extends Null.Views.Base
  template: JST['app/test_api/food/index.html']

  initialize: (options) =>
    super

    @collection = new App.Collections.Food()

    @form = new App.Views.TestApi.Food.Form
      collection: @collection
      authorizator: app.authorization
      subject: app.me.toJSON()

    @table = new App.Views.TestApi.Food.Table
      collection: @collection

  render: () =>
    super

    @appendView @form.render(), '.create-form'
    @appendView @table.render(), '.list'

    @collection.fetch()

class App.Views.Admin.Users.Index extends Null.Views.Base
  template: JST['app/admin/users/index.html']

  initialize: (options) =>
    super

    @collection = new App.Collections.Users()

    @form = new App.Views.Admin.Users.Form
      collection: @collection
      authorizator: app.authorization
      subject: app.me.toJSON()

    @table = new App.Views.Admin.Users.Table
      collection: @collection
      subject: app.me.toJSON()

  render: () =>
    super

    @appendView @form.render(), '.create-form'
    @appendView @table.render(), '.list'

    app.authorization.isAuthorized("User:read", app.me.toJSON(), {}, (result) =>
      filter = {}
      @collection.fetch({
        data: filter
      })
    )

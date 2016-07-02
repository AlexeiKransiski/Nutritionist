class App.Views.Admin.Users.Table extends Null.Views.Base
  template: JST['app/admin/users/table.html']

  initialize: (options) =>
    super

    @collection.on "add", @addOne, @

  render: () =>
    super

  addAll: () =>
    @collection.each @addOne

  addOne: (item) =>
    item_view = new App.Views.Admin.Users.Row
      model: item
      subject: app.me.toJSON()
      
    @appendView item_view.render(), 'tbody'

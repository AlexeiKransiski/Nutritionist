class App.Views.Main.Users.Table extends Null.Views.Base
  template: JST['app/main/users/table.html']

  initialize: (options) =>
    super

    @collection.on "add", @addOne, @

  render: () =>
    super

  addAll: () =>
    @collection.each @addOne

  addOne: (item) =>
    item_view = new App.Views.Main.Users.Row
      model: item
      subject: app.me.toJSON()

    @appendView item_view.render(), 'tbody'

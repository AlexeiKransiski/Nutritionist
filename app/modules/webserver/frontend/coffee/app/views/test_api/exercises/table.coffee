class App.Views.TestApi.Exercises.Table extends Null.Views.Base
  template: JST['app/test_api/exercises/table.html']

  initialize: (options) =>
    super

    @collection.on "add", @addOne, @

  render: () =>
    super

  addAll: () =>
    @collection.each @addOne

  addOne: (item) =>
    item_view = new App.Views.TestApi.Exercises.Row({model: item})
    @appendView item_view.render(), 'tbody'

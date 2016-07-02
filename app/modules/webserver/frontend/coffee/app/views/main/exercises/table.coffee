class App.Views.Main.Exercises.Table extends Null.Views.Base 
  template: JST['app/main/exercises/table.html']
  tagName: 'table'
  className: 'table table-hover'
  options:
    footer: false
    filter: {}

  initialize: (options) =>
    super
    @listenTo @collection, 'add', @addOne

    @collection.parse = (data) ->
      return data.data

    @

  render: () =>
    super

    @

  # addAll: =>
  #   @collection.each @addOne
  refresh: (callback) =>
    @collection.fetch
      data: @options.filter
      success: (collection, response) =>
        callback(null, collection)
      error: (collection, error) =>
        callback(error, null)

  addOne: (item) =>
    item_view = new App.Views.Main.Exercises.Row
      model: item

    @appendView item_view.render(), 'tbody'

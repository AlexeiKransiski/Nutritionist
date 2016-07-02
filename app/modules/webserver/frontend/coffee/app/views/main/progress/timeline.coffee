class App.Views.Main.Progress.Timeline extends Null.Views.Base
  template: JST['app/main/progress/timeline.html']

  initialize: (options) =>
    super
    @rendered = false

    @listenToOnce @collection, 'reset', @render
    @listenTo @collection, 'sort', @refresh

    return this

  render: () =>
    return unless @collection.length > 1
    super
    @rendered = true
    @addAll()

    return this

  refresh: () =>
    @removeSubviews()
    @render()

  addOne: (item, index) =>
    return if index == 0
    @render() unless @rendered
    item_view = new App.Views.Main.Progress.Item.Detail
      model: item

    @appendView item_view.render(), '[data-role=progres-items]'

  addAll: () =>
    @collection.each @addOne

class App.Views.Main.Progress.Item.Last extends Null.Views.Base
  template: JST['app/main/progress/item/last.html']
  # className: 'box_progess'

  initialize: (options) =>
    super

    @listenToOnce @collection, 'reset', @refresh
    @listenTo @collection, 'sort', @refresh

    @on 'edit:canceled', @showDetail
    @on 'edit:success', @onEditSuccess
    return this

  events:
    'click [data-role=edit]': 'onEditClick'

  render: () =>
    return this unless @collection.length > 0
    super
    return this

  getContext: () =>
    return {model: @model}

  refresh: () =>
    @model = @collection.first()
    @edit_view = null
    @render()

  onEditSuccess: () =>
    @render()
    @showDetail()

  onEditClick: (event) =>
    event.preventDefault()
    @edit_view = new App.Views.Main.Progress.Item.Edit
      model: @model

    @addView @edit_view.render(), '[data-role=edit-view]'

    @showEdit()

  showEdit: () =>
    @fire 'last:edit'
    $('[data-role=detail-view]', @$el).fadeOut 'slow', ->
      $('[data-role=edit-view]', @$el).fadeIn 'slow'
      return

  showDetail: () =>
    @fire 'last:detail'
    $('[data-role=edit-view]', @$el).fadeOut 'slow', ->
      $('[data-role=detail-view]', @$el).fadeIn 'slow'
      return

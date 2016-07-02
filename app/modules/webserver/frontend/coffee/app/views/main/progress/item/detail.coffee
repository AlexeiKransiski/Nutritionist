class App.Views.Main.Progress.Item.Detail extends Null.Views.Base
  template: JST['app/main/progress/item/detail.html']
  className: 'box_progess'

  initialize: (options) =>
    super
    @on 'edit:success', @refresh
    @on 'edit:canceled', @showDetail
    return this

  events:
    'click [data-role=edit]': 'onEditClick'

  getContext: () =>
    return {model: @model}

  onEditClick: (event) =>
    event.preventDefault()
    @edit_view = new App.Views.Main.Progress.Item.Edit
      model: @model

    @addView @edit_view.render(), '[data-role=edit-content]'

    @showEdit()

  refresh: () =>
    @showDetail @render
    
  showEdit: () =>
    # @fire 'last:edit'
    $('[data-role=item-detail-view]', @$el).fadeOut 'slow', =>
      $('[data-role=item-edit-view]', @$el).fadeIn 'slow'
      return

  showDetail: (cb) =>
    # @fire 'last:detail'
    $('[data-role=item-edit-view]', @$el).fadeOut 'slow', =>
      $('[data-role=item-detail-view]', @$el).fadeIn 'slow', =>
        cb() if cb? and typeof cb == 'function'
      return

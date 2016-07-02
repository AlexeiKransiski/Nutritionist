class App.Views.Common.DeleteConfirmation extends Null.Views.Base
  template: JST['app/common/delete_confirmation.html']

  initialize: (options) =>
    super
    @options =
      wait: false
      success: null
      error: null
    _.extend @options, options
    @

  events:
    'click [data-role=delete]': 'deleteItem'
    'click [data-role=close]': 'hide'

  render: () =>
    super
    $('.modal', @$el).on 'hidden.bs.modal', @remove
    @show()
    @

  getContext: () =>
    return {model: @model}

  show: () ->
    console.log "SHOW"
    $('.modal', @$el).modal('show')

  hide: () ->
    console.log "HIDE"
    $('.modal', @$el).modal('hide')

  deleteItem: (e) ->
    e.preventDefault()
    @fire 'list:delete_current_list', @model
    console.log "DELETEING!!"
    @model.destroy(@options)
    @hide()

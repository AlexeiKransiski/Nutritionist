class App.Views.Common.DeleteAccountConfirmation extends Null.Views.Base
  template: JST['app/common/delete_confirmation.html']

  that = null

  initialize: (options) =>
    super
    that = @
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
    $('.modal', @$el).modal('show')

  hide: () ->
    $('.modal', @$el).modal('hide')

  deleteItem: (e) ->
    e.preventDefault()
    @$el.block()
    @model.destroy(
      wait: true,
      success: (model, response) =>
        @$el.unblock()
        @hide()
        @fire 'account:delete'
        window.location = "/logout"
      error: (model, response) =>
        @$el.unblock()
        @error(response.reponseJSON) if response?.reponseJSON?
    )

class App.Views.Common.Cvv2 extends Null.Views.Base 
  template: JST['app/common/cvv2.html']

  that = null

  initialize: (options) =>
    super
    that = @
    @

  events:
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
    

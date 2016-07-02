class App.Views.Main.Settings.Subscriptions.CreditCard.Item extends App.Views.Base
  template: JST['app/main/settings/subscription/credit_card_item.html']
  tagName: 'tr'

  initialize: (options) =>
    super

  events:
    'click .icon-edit':'onEdit'
    'click .icon-delete':'onRemove'
    'click input': 'onMakeDefault'

  getContext: ->
    result = super
    result['model'] = @model
    return result

  render: () =>
    super
    $('.custom_radio input').iCheck({
      radioClass: 'iradio_polaris'
    });
    @

  onEdit:(event)=>
    event.preventDefault()
    @fire 'card:edit', @model

  onRemove:(event)=>
    event.preventDefault()

    deletel_confirmation = new App.Views.Common.DeleteConfirmation
      model: @model
      wait: true
      success: (model, resp) =>
        @removeAll()
      error: (model, resp) =>
        alert resp.responseText
        console.log 'ERROR', resp

    @appendView deletel_confirmation.render(), $("[data-role=modal-container]")
    # @appendView deletel_confirmation.render(), '[data-role=modal-container]'
    # @model.destroy({
    #   wait: true
    #   success: (model, resp) =>
    #     @removeAll()
    #   error: (model, resp) =>
    #     alert resp.responseText
    #     console.log 'ERROR', resp
    # })

  onMakeDefault: (event) =>
    if $(event.target).is(':checked')
      @$el.block()
      @model.save({ 'default': true},{
        success: (model, response) =>
          app.me.set model.toJSON()
          console.log "DEFAULT CARD CHANGED"
          @$el.unblock()
          @success('Default card changed')
        error: (model, response) =>
          console.log "ERROR MAKING DEFAULT"
          @$el.unblock()
          @error(response.responseJSON) if response.responseJSON?
      })

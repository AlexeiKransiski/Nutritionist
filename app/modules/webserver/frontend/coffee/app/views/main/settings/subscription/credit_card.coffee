class App.Views.Main.Settings.Subscriptions.CreditCard extends App.Views.Base
  template: JST['app/main/settings/subscription/credit_card.html']
  className: 'rest_boxes creditcard'

  options:
    active: false

  that = null
  @editModel=null
  initialize: (options) =>
    super
    @editModel=null
    that = @

    if app.me.get('credit_cards')
      @cards = new App.Collections.Cards(app.me.get('credit_cards').data)

    @on 'card:edit', @onEditCard

  events:

    'click #save_card': 'onSaveCard'
    'click #add_new_creditcard': 'onAddNewCreditCardClick'
    'click .buttons_newcard .btn-default': 'onCancelNewCreditCardClick'
    'click [data-role="cvv2"]': 'onCvv2'


  render: () =>
    super

    $('#test', @$el).bfhselectbox()
    $('#year', @$el).bfhselectbox()
    @addAllCards()
    @

  addAllCards: () =>
    $('#tableCards').empty()
    if app.me.get('credit_cards')
      @cards.each @addOneCard

  addOneCard: (card) =>
    card = new App.Views.Main.Settings.Subscriptions.CreditCard.Item({model:card})
    @appendView card.render(), '#tableCards'

  #Events
  onCvv2: (event)=>
    event.preventDefault()
    modal = new App.Views.Common.Cvv2()
    @appendView modal.render(), $("[data-role=modal-container]")

  onAddNewCreditCardClick: ->
      stripe_data = {callback: @onSaveCard, client: app.me.toJSON()}
      stripe_card_view = new App.Views.Common.Main.AddCard(stripe_data)


  onCancelNewCreditCardClick: ->
    event.preventDefault()
    $('.buttons_newcard' , @$el).fadeOut 'slow', ->
      $('.new_creditcard' , @$el).fadeOut 'slow'
      $('#add_new_creditcard' , @$el).fadeIn 'slow'

    $("#creditcard").val("")
    $("#cvv2").val("")
    $("#name").val("")
    $("#lastnames").val("")
    $("#test").val("")
    $("#year").val("")

  onEditCard:(event)->
    @editModel = event.view.model
    $("#creditcard").val(@editModel.get("creditcard"))
    $("#cvv2").val(@editModel.get("cvv2"))
    $("#name").val(@editModel.get("firstname"))
    $("#lastnames").val(@editModel.get("lastname"))
    $("#test").val(@editModel.get("month"))
    $("#year").val(@editModel.get("year"))
    $('#add_new_creditcard' , @$el).fadeOut 'slow', ->
          $('.new_creditcard' , @$el).fadeIn 'slow'
          $('.buttons_newcard' , @$el).fadeIn 'slow'


  onSaveCard: (token) =>
    console.log "STRIPE CARD TOKEN:", token
    new_card = new App.Models.Card()
    @$el.block()
    new_card.save({source: token.id}, {
      success: (model, response) =>
        console.log "SUCCESS"
        @cards.add model
        app.me.fetch({
          success: (model, response) =>
            @$el.unblock()
            @success('Card added')
            @render()
        })
      error: (model, response) =>
        console.log "ERROR"
        @$el.unblock()
        @error(response.responseJSON) if response.responseJSON?

    })

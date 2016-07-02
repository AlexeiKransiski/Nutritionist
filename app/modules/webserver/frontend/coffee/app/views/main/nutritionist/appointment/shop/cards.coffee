class App.Views.Main.Appointment.Shop.Cards extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/shop/cards.html']

  initialize: (options) =>
    super
    @cards = new App.Collections.Cards(app.me.get('credit_cards').data)

    @on 'card:selected', @onCardSelected
    return this

  events:
    'click [data-role="next"]': 'onNext'
    'click [data-role="cancel"]': 'onCancel'
    'click [data-role="add-card"]': 'onAddNewCreditCardClick'

  render: () =>
    super

    @addAllCards()

    return this

  getContext: =>
    return

  show: () =>
    $('#credit_card', @$el).fadeIn ('slow')

  hide: () =>
    $('#credit_card', @$el).fadeOut ('slow')

  addAllCards: () =>
    $('[data-role="credit-cards"]').empty()
    @cards.each @addOneCard

  addOneCard: (card) =>
    card = new App.Views.Main.Appointment.Shop.Card({model:card})
    @appendView card.render(), '[data-role="credit-cards"]'

  onCardSelected: (event) =>
    @card_selected = event.view.model

  onNext: (event) =>
    event.preventDefault()
    unless @card_selected
      card_id = app.me.get('default_credit_card')
    else
      card_id = @card_selected.id

    @$el.block()
    @order.save({
      card: card_id
    },{
      success: (model, respose) =>
        @$el.unblock()
        app.me.fetch()
        @fire 'add:consultation:paid'

      error: (model, response) =>
        @$el.unblock()
        @error(response.responseJSON)
    })


  onCancel: (event) =>
    event.preventDefault()
    @fire 'add:consultation:canceled'


  onAddNewCreditCardClick: =>
      stripe_data = {callback: @onSaveCard, client: app.me.toJSON()}
      stripe_card_view = new App.Views.Common.Main.AddCard(stripe_data)

  onSaveCard: (token) =>
    @$el.block()
    new_card = new App.Models.Card()
    new_card.save({source: token.id}, {
      success: (model, response) =>
        @$el.unblock()
        @cards.add model
        app.me.fetch({
          success: (model, response) =>
            @success "Card Added"
            @addAllCards()
        })
      error: (model, response) =>
        @$el.unblock()
        if  response?.responseJSON?
          @error response.responseJSON
        else
          @error 'Error adding card. Try again later.'
    })

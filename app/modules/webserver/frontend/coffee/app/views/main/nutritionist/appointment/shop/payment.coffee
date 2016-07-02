class App.Views.Main.Appointment.Shop.Payment extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/shop/payment.html']

  initialize: (options) =>
    super

    @context =
      amount: 0
      last4: '0000'

    return this

  events:
    'click [data-role="new"]': 'onNewAppointment'
    'click [data-role="cancel"]': 'onCancel'

  getContext: =>
    return {context: @context}


  show: () =>
    @render()
    $('#payment', @$el).fadeIn ('slow')

  hide: () =>
    $('#payment', @$el).fadeOut ('slow')

  setOrder: (order) =>
    @context.amount = order.get('stripe_order')?.amount || 0
    @context.last4 = Helpers.getCardData(order.get('card'), 'last4') || '0000'

  setSubcription: () =>
    @context.amount = app.me.get('subscription')?.stripe_data?.plan?.amount || 0
    @context.last4 = Helpers.getCardData(app.me.get('default_credit_card'), 'last4')

  onNewAppointment: (event) =>
    event.preventDefault()
    @fire 'add:consultation:new'

  onCancel: (event) =>
    event.preventDefault()
    @fire 'add:consultation:canceled'

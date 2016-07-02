class App.Views.Common.Main.AddCard extends App.Views.Base
  template: JST['app/common/main/add_card.html']

  initialize: (options) =>
    super
    @text = (if options?.text? then options.text else "Add Card")
    @client = (if options?.client? then options.client else undefined)
    @callback = (if options?.callback? then options.callback else undefined)
    @amount = (if options?.amount? then options.amount else undefined)
    @addCardHandler()

  events:
    "click .add-card-modal": "addCardHandler"

  render: () =>
    @addCardHandler()
    return this

  getContext: () =>
    return {text: @text}

  addCardHandler: (event) =>
    event.preventDefault() if event?
    event.stopPropagation() if event?
    console.log "adssad"
    data =
      key:         Config.stripe.public_key,
      address:     false,
      currency:    'usd',
      name:        'Qalorie',
      #description: polyglot.t('stripe.label'),
      panelLabel:  'Subscription'
      token:       @save,
      capture:     false,

    if @amount?
      data.amount = parseInt(@amount)

    data.email = @client.email if @client?.email?

    StripeCheckout.open(data)

  save: (stripe_response) =>
    unless stripe_response.id
      $.gritter.add({
        title: 'Add Card',
        text: 'Erro while adding card. Try again later',
        class_name: 'gritter-error gritter-center'
      })
      return

    return @callback(stripe_response) if @callback?

  newCustomer: (stripe) =>
    that = @
    @model = new App.Models.Customer()
    c = new App.Collections.Customers(@model)

    @model.save(
      {
        card: stripe.id
      },
      {
        success: (model, response) =>
          App.user.profile.customer = model.id
          $.cookies.set("user", App.user)
          $.gritter.add({
            title: 'Add Card',
            text: 'The card has been added',
            class_name: 'gritter-success gritter-center',
          })
          that.trigger("customer_created")
        ,
        error: (model, response) =>
          $.gritter.add({
            title: 'Add Card',
            text: 'Erro while adding card. Try again later',
            class_name: 'gritter-error gritter-center'
          })
        ,
        wait: true
      }
    )

  addCardToCustomer: (stripe) =>
    that = @

    @collection.create(
      {
        card: stripe.id
      },
      {
        success: (model, response) =>
          $.gritter.add({
            title: 'Add Card',
            text: 'The card has been added',
            class_name: 'gritter-success gritter-center',
          })
        ,
        error: (model, response) =>
          $.gritter.add({
            title: 'Add Card',
            text: 'Erro while adding card. Try again later',
            class_name: 'gritter-error gritter-center'
          })
        ,
        wait: true
      }
    )

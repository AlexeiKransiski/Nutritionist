class App.Views.Main.Nutritionist.Index extends Null.Views.Base
  template: JST['app/main/nutritionist/index.html']

  initialize: (options) =>
    super

    @is_fetched = false
    @filter =
      patient: app.me.id
      # status: 'open'

    @collection = new App.Collections.Appointments()

    @summary = new App.Views.Main.Appointment.Summary({
      collection: @collection
    })
    @new_appointment = new App.Views.Main.Appointment.New()
    @plans = new App.Views.Main.Appointment.Shop.Plans()
    if app.me.get('credit_cards')
      @cards = new App.Views.Main.Appointment.Shop.Cards()
    @payment = new App.Views.Main.Appointment.Shop.Payment()
    @upgrade = new App.Views.Main.Appointment.Shop.Upgrade()

    @list = new App.Views.Main.Appointment.List
      collection: @collection


    @listenToOnce @collection, 'sync', @fetched


    @on 'add:consultation:new', @showNewAppointment
    @on 'add:consultation:plan', @showPlanView
    @on 'add:consultation:card', @showCardView
    @on 'add:consultation:paid', @showPaymentView
    @on 'add:consultation:canceled', @showIndex
    @on 'add:consultation:upgrade', @showUpgradeView

    return this

  render: () =>
    unless @is_fetched
      @fetch()
      return
    super

    @appendView @summary.render(), '[data-role="appointments-views"]'
    @appendView @new_appointment.render(), '[data-role="appointments-views"]'
    @appendView @plans.render(), '[data-role="appointments-views"]'
    if app.me.get('credit_cards')
      @appendView @cards.render(), '[data-role="appointments-views"]'
    @appendView @upgrade.render(), '[data-role="appointments-views"]'
    @appendView @payment.render(), '[data-role="appointments-views"]'

    if @collection.length > 0
      $('.account_down', @$el).addClass('hide')
      @appendView @list.render(), '[data-role="wapper"]'
    return this

  getContext: =>
    return {
      lastAppointment: @collection.first()
      collection: @collection
    }

  fetch: () =>
    @collection.fetch {
      data: @filter
    }

  fetched: () =>
    return if @is_fetched
    @is_fetched = true
    @render()
    return

  showIndex: () =>
    @subviewCall('hide')
    @summary.render()
    @summary.show()

    return this

  showPlanView: (event) =>
    @subviewCall('hide')
    @plans.refresh()
    @plans.show()

    return this

  showCardView: (event) =>
    @cards.order = event.view.order
    @subviewCall('hide')
    @cards.show()

    return this

  showPaymentView: (event) =>
    if event.view == @cards
      @payment.setOrder event.view.order
    else
      @payment.setSubcription()

    @subviewCall('hide')
    @payment.show()

  showNewAppointment: (event) =>
    @subviewCall('hide')
    @new_appointment.show()
    return

  showUpgradeView: (event) =>
    @subviewCall('hide')
    @upgrade.show()
    return

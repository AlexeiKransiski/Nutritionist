class App.Views.Main.Settings.Subscriptions.Index extends App.Views.Base
  template: JST['app/main/settings/subscription/index.html']
  className: 'tab-pane fade'
  id: 'subscription'

  options:
    active: false

  @subs=null
  that = null

  initialize: (options) =>
    super

    @subscription_creditcard = new App.Views.Main.Settings.Subscriptions.CreditCard
      hidden: false

    @subscription_discount = new App.Views.Main.Settings.Subscriptions.Discount
      hidden: false

  events:
    'click .plan': 'onSelectPlan'
    'click .update-subscription': 'onSubscriptionUpdate'

  render: () =>
    super

    getGridSizes = ->
      if window.innerWidth < 600 then 1 else if window.innerWidth < 980 then 2 else 3

    @$('#planstwo', @$el).flexslider
      animation: 'slide'
      animationLoop: false
      itemWidth: 300
      itemMargin: 21
      minItems: getGridSizes()
      maxItems: getGridSizes()
      controlNav: false
      after: (slider) ->
        $('.flexslider', @$el).css( 'display', 'block' ).data('flexslider').resize()

    @

    # my profile extra boxes
    @appendView @subscription_creditcard.render(), '[data-role=credit_card_information]'

    @appendView @subscription_discount.render(), '[data-role=discounts]'

    return this

  onSelectPlan: (event) =>
    $plan = $(event.target)
    $('button.plan-selector.active', @$el).removeClass('active')
    $plan.addClass('active')

  onSubscriptionUpdate: (event) =>
    event.preventDefault()
    $plan = $('button.plan-selector.active', @$el)

    subscription = new App.Models.Subscription()
    subscription.set 'plan', $plan.val()
    @$el.block()
    subscription.update($plan.val(), {
      success: (model, response) =>
        @$el.unblock()
        @success('Plan updated')
        console.log "SUCCESS", model, response
        @render()
        
      error: (model, response) =>
        @$el.unblock()
        console.log "ERROR", model, response
        if response?.responseJSON?.message?
          @error response?.responseJSON
    })

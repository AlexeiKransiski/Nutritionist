class App.Views.Main.Appointment.Shop.Upgrade extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/shop/upgrade.html']

  events:
    'click .plan': 'onSelectPlan'
    'click [data-role="update-subscription"]': 'onSubscriptionUpdate'
    'click [data-role="cancel"]': 'onCancel'

  getContext: =>
    return

  show: () =>
    $('#upgrade_plan', @$el).fadeIn ('slow')

  hide: () =>
    $('#upgrade_plan', @$el).fadeOut ('slow')

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
        @fire 'add:consultation:paid'
      error: (model, response) =>
        @$el.unblock()
        console.log "ERROR", model, response
        if response?.responseJSON?.message?
          @error response?.responseJSON
    })

  onCancel: (event) =>
    event.preventDefault()
    @fire 'add:consultation:canceled'

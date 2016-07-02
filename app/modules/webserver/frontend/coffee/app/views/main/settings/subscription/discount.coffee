class App.Views.Main.Settings.Subscriptions.Discount extends App.Views.Base
  template: JST['app/main/settings/subscription/discount.html']
  className: 'rest_boxes discount'

  options:
    active: false

  events:
    'click .reedem': 'onReedem'
    'keyup input': 'onKeyup'

  initialize: (options) =>
    super

  render: () =>
    super
    return this

  onKeyup: (event) =>
    $input = $(event.target)
    if $input.val() != ''
      $('.reedem', @$el).removeAttr('disabled')
    else
      $('.reedem', @$el).attr('disabled', 'disabled')

  onReedem: () =>
    @$el.block()
    subscription = new App.Models.Subscription()
    subscription.coupon $('#promocode', @$el).val(), {
      success: (model, resp) =>
        @$el.unblock()
        @success('Coupon added')

      error: (model, response) =>
        @$el.unblock()
        if response?.responseJSON?.message?
          @error response.responseJSON
    }

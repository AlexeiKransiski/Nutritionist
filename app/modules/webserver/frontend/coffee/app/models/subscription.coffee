class App.Models.Subscription extends Null.Models.Base
  urlRoot: '/api/v1/subscriptions'

  constructor: (attributes, options) ->
    default_options =
      user: app.me

    _.extend default_options, attributes

    if default_options.user.toJSON?
      default_options._id = default_options.user.id
      default_options.plan = default_options.user.get('subscription').plan
      default_options.amount = default_options.user.get('subscription').amount
    else
      default_options._id = options.user

    delete default_options.user
    console.log "SUBSCRIPTON DATA:", default_options
    # super default_options
    # @initialize(default_options, options)
    return Null.Models.Base.call(@, default_options, options)

  update: (plan, options) =>
    @save({plan: plan}, {
      success: (model, resp) =>
        app.me.set model.toJSON()
        options.success(model, resp) if options?.success?
      error: (model, resp) =>
        options.error(model, resp) if options?.error?

    })

  coupon: (coupon, options) =>
    @save({coupon: coupon}, {
      success: (model, resp) =>
        app.me.set model.toJSON()
        options.success(model, resp) if options?.success?
      error: (model, resp) =>
        options.error(model, resp) if options?.error?

    })

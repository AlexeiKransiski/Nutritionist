class App.Views.Signup.ChoosePlan extends Null.Views.Base
  template: JST['app/signup/choose-plan.html']

  that = null

  events:
    'click .plan-selector': 'onPlanSelected'
    'change #card-form input': 'onChangeInput'
    'change #code': 'onChangeCodeInput'
    'change.bfhselectbox #card-form .bfh-selectbox': 'onChangeInput'
    # 'click #next-step': 'addCard'
    'click #next-step': 'getStripeToken'
    'submit #card-form': 'getStripeToken'
    'resize window': 'onResponsivePlan'

  initialize: ->
    @selectedPlan = Config.stripe.plans.trial.id

    @card = new App.Models.Card
    @subscription = new App.Models.Subscription()

    Stripe.setPublishableKey(Config.stripe.public_key)

    that = @

    return this
    # @subscription.set('plan', @selectedPlan)
    # @subscription.set 'amount', Config.stripe.plans.trial.amount

  render: ->
    super
    @$(".plan-selector[value='#{@selectedPlan}']").addClass('active')

    @$('.bfh-selectbox').bfhselectbox()

  onResponsivePlan: (event) ->
    flexslider
    gridSize = getGridSize();

    flexslider.vars.minItems = gridSize;
    flexslider.vars.maxItems = gridSize;

  onChangeCodeInput: (event) ->
    if @$(event.currentTarget).val() != ''
      @subscription.set('coupon', @$(event.currentTarget).val())
    else
      @subscription.unset('coupon')


  addCard: (event) =>

    stripe_data = {callback: @onNextStep, client: app.me.toJSON()}
    stripe_card_view = new App.Views.Common.Main.AddCard(stripe_data)

  onNextStep: (status, stripe) =>
    # console.log "Va a guardar y pasar al siguiente paso"
    console.log "UPDATE SUBSCRIPTION"
    if stripe.error
      $('.payment-errors', @$el).text(stripe.error.message)
      $('#next-step', @$el).prop('disabled', false)
      return

    @subscription.save({'source': stripe.id}, {
      success: (model, data, xhr) =>
        app.me.fetch({
          success: (model, data, xhr) =>
            unless data.error
              app.routers[1].navigate("suggest", {trigger: true})
        })
      error: (model, response) =>
        if response?.responseJSON?.message?
          alert response?.responseJSON?.message

    })

  onPlanSelected: (event) ->
    @$('.plan-selector').removeClass('active').html('select plan')
    $selectedPlan = @$(event.currentTarget).addClass('active').html('plan selected')
    @selectedPlan = $selectedPlan.val()

    @subscription.set('plan', @selectedPlan)

    @planText = $selectedPlan.attr('text-plan')

    switch @planText
      when "b"
        if $('#beginners', @$el).css('display') != 'block'
          $('.plans-descriptions-texts', @$el).fadeOut 'slow'
          $('#beginners', @$el).delay(650).fadeIn 'slow'
      when "m"
        if $('#monthly', @$el).css('display') != 'block'
          $('.plans-descriptions-texts', @$el).fadeOut 'slow'
          $('#monthly', @$el).delay(650).fadeIn 'slow'
      when "y"
        if $('#yearly', @$el).css('display') != 'block'
          $('.plans-descriptions-texts', @$el).fadeOut 'slow'
          $('#yearly', @$el).delay(650).fadeIn 'slow'

  onChangeInput: (event) ->
    changed = event.currentTarget
    value = @$(event.currentTarget).val()

    obj = {}
    if changed.name
      obj[changed.name] = if $(event.currentTarget).is(':checkbox') then $(event.currentTarget).is(':checked') else value
    else
      obj[$(event.currentTarget).data('name')] = value

    obj["user"] = app.me.id

    @card or= new App.Models.Card()
    @card.set(obj)

  checkValidation:()->
    @clearMessages()
    valid=true
    if $("#firstname").val() == ""
      valid=false
      $("#firstname_error").show()
      $("#firstname_error").empty()
      $("#firstname_error").append("Please enter your firstname")
      $("#firstname").addClass 'error'

    if $("#lastname").val() == ""
      valid=false
      $("#lastname_error").show()
      $("#lastname_error").empty()
      $("#lastname_error").append("Please enter your lastname")
      $("#lastname").addClass 'error'

    if $("#creditcard").val() == ""
      valid=false
      $("#creditcard_error").show()
      $("#creditcard_error").empty()
      $("#creditcard_error").append("Please enter your credit card number")
      $("#creditcard").addClass 'error'

    if $("#monthExp").val() == "" || $("#yearExp").val() == ""
      valid=false
      $("#expiration_error").show()
      $("#expiration_error").empty()
      $("#expiration_error").append("Please select an expiration date")
      if $("#monthExp").val() == ""
        $("#monthExp a").addClass 'error'
      if $("#yearExp").val() == ""
        $("#yearExp a").addClass 'error'

    if $("#cvv2").val() == ""
      valid=false
      $("#cvv2_error").show()
      $("#cvv2_error").empty()
      $("#cvv2_error").append("Please enter your cvv2 number")
      $("#cvv2").addClass 'error'

    return valid

  clearMessages:()->
    $("#firstname_error").show()
    $("#firstname_error").empty()
    $("#firstname").removeClass 'error'
    $("#lastname_error").show()
    $("#lastname_error").empty()
    $("#lastname").removeClass 'error'
    $("#creditcard_error").show()
    $("#creditcard_error").empty()
    $("#creditcard").removeClass 'error'
    $("#expiration_error").show()
    $("#expiration_error").empty()
    $("#monthExp a").removeClass 'error'
    $("#yearExp a").removeClass 'error'
    $("#cvv2_error").show()
    $("#cvv2_error").empty()
    $("#cvv2").removeClass 'error'


  getStripeToken: (event) =>
    event.preventDefault()

    return unless @checkValidation()

    app.me.save({'create_stripe_customer':1},
      success: (model) ->
        app.me.unset('create_stripe_customer')
        console.log "create stripe customer"
        
        $form = $('form#card-form', @$el)
        $(event.target).prop('disabled', true)

        $('[data-stripe=name]', @$el).val("#{$('#firstname').val()} #{$('#lastname').val()}")
        $('[data-stripe=exp-month]', @$el).val($('[data-name=month]').val())
        $('[data-stripe=exp-year]', @$el).val($('[data-name=year]').val())
        Stripe.card.createToken($form, that.onNextStep)
    )
    return false

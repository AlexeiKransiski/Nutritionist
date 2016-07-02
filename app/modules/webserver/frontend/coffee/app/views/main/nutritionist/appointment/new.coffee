class App.Views.Main.Appointment.New extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/new.html']

  initialize: (options) =>
    super

    @subscription = new App.Models.Subscription()
    Stripe.setPublishableKey(Config.stripe.public_key)

    return this

  events:
    'click [data-role=goto]': 'onGoto'
    'click [data-role=cancel]': 'cancel'
    'click [data-role=stripe]': 'getStripeToken'
    'click [data-role=new]': 'new'
    'click #btn-try-again': 'onTryCcForm'
    'keyup #question1': 'onLifeStyleChange'
    'change #question1': 'onLifeStyleChange'
    'keyup #question2': 'onObjetivesChange'
    'change #question2': 'onObjetivesChange'
    'click [data-role=save-lifestyle]': 'onSaveLifeStyle'
    'click [data-role="save-goal"]': 'onSaveGoal'
    'click [data-role=change-lifestyle]': 'onChangeLifeStyle'
    'click [data-role="change-goal"]': 'onChangeGoal'
    'keyup #messages': 'onMessageChange'
    'change #messages': 'onMessageChange'
    'click .emo': 'onToggleEmo'
    #'click .emoticons label': 'onClickEmo'

  render: () =>
    super
    
    @$('.bfh-selectbox').bfhselectbox()
    if ($('#question1', @$el).val() == '')
      $('[data-role="save-lifestyle"]', @$el).removeClass('hide')
    else
      $('[data-role="change-lifestyle"]', @$el).removeClass('hide')
      $('#question1', @$el).attr('readonly', true)

    if ($('#question2', @$el).val() == '')
      $('[data-role="save-goal"]', @$el).removeClass('hide')
    else
      $('[data-role="change-goal"]', @$el).removeClass('hide')
      $('#question2', @$el).attr('readonly', true)

    return this

  onToggleEmo: (event) =>
    console.log "toggle"
    $emo = $('.emoticons', @$el)
    if $emo.css('display') in ['none']
      $emo.slideDown('slow')
    else
      $emo.slideUp('slow')

  onClickEmo: (event) =>
    icon = $(event.target).find('i').attr('class')
    $(event.target).parent().parent().parent().find('.emoticons').slideUp 'slow'
    $(event.target).parent().parent().parent().find('button span[class*=\'icon-\']').attr 'class', icon
    $(event.target).parent().parent().parent().find('.caret').show 'fast'
    $(event.target).parent().parent().parent().find('.emo').removeClass 'active'
    return


  getContext: =>
    return

  show: () =>
    $('#appointments', @$el).fadeIn ('slow')

  hide: () =>
    $('#appointments', @$el).fadeOut ('slow')

  onGoto: (event) =>
    event.preventDefault()
    $link = $(event.target)
    goto = $link.data('goto')
    console.log 'goto'
    switch goto
      when 1
        $('[data-role="part-2"]', @$el).fadeOut 'slow', ->
          $('[data-role="part-1"]', @$el).fadeIn ('slow')
      when 2
        return unless @checkStep1Validation()
        $('[data-role="part-1"]', @$el).fadeOut 'slow', ->
          $('[data-role="part-2"]', @$el).fadeIn ('slow')
      when 4
        $('[data-role="part-3"]', @$el).fadeOut 'slow', ->
          $('[data-role="part-2"]', @$el).fadeIn ('slow')
      when 3
        return unless @checkStep2Validation()
        if app.me.get('subscription').plan == Config.stripe.plans.trial.id
          $('[data-role="part-2"]', @$el).fadeOut 'slow', ->
            $('[data-role="part-3"]', @$el).fadeIn ('slow')
        else
          this.new()
      else
    return

  cancel: (event) =>
    event.preventDefault()
    @fire 'add:consultation:canceled'

  onLifeStyleChange: (event) =>
    $txt = $(event.target)
    text = $txt.val()
    length = text.length
    limit = 200
    if length <= limit
      $('#letterlifestyle', @$el).html(length)
      return true
    else
      new_text = text.substr(0, limit);
      $txt.val(new_text);
      return false

  onObjetivesChange: (event) =>
    $txt = $(event.target)
    text = $txt.val()
    length = text.length
    limit = 200
    if length <= limit
      $('#lettergoal', @$el).html(length)
      return true
    else
      new_text = text.substr(0, limit);
      $txt.val(new_text);
      return false

  onSaveLifeStyle: (event) =>
    event.preventDefault()
    return unless @checkListStyle()
    lifestyle = $('#question1', @$el).val()

    app.me.save {lifestyle: lifestyle}, {
      success: (model, response) =>
        @success('Lifestyle saved')
        $('[data-role="save-lifestyle"]', @$el).addClass('hide')
        $('[data-role="change-lifestyle"]', @$el).removeClass('hide')
        $('#question1', @$el).attr('readonly', true)
      error: (model, response) =>
        @error(response.responseJSON)

    }

  onChangeLifeStyle: (event) =>
    $('[data-role="save-lifestyle"]', @$el).removeClass('hide')
    $('[data-role="change-lifestyle"]', @$el).addClass('hide')
    $('#question1', @$el).attr('readonly', false)

  onSaveGoal: (event) =>
    event.preventDefault()
    return unless @checkGoals()
    goal = $('#question2', @$el).val()
    current_goal = app.me.get('goals')
    current_goal.text = goal
    app.me.save {goals: current_goal}, {
      success: (model, response) =>
        @success('Goal saved')
        $('[data-role="save-goal"]', @$el).addClass('hide')
        $('[data-role="change-goal"]', @$el).removeClass('hide')
        $('#question2', @$el).attr('readonly', true)
      error: (model, response) =>
        @error(response.responseJSON)

    }

  onChangeGoal: (event) =>
    $('[data-role="save-goal"]', @$el).removeClass('hide')
    $('[data-role="change-goal"]', @$el).addClass('hide')
    $('#question2', @$el).attr('readonly', false)

  checkStep1Validation: () =>
    valid_lifestyle = @checkListStyle()
    valid_goal = @checkGoals()
    return valid_goal and valid_lifestyle

  checkStep2Validation: () =>
    valid_msg = @checkMessage()
    valid_stress = @checkStress()
    return valid_msg and valid_stress

  checkListStyle: () =>
    valid = true
    if $("#question1").val() == ""
      valid=false
      $("#question1_error").show()
      $("#question1_error").empty()
      $("#question1_error").append("Please enter your lifestyle")
    else
      $("#question1_error").show()
      $("#question1_error").empty()
    return valid

  checkGoals: () =>
    valid = true
    if $("#question2").val() == ""
      valid=false
      $("#question2_error").show()
      $("#question2_error").empty()
      $("#question2_error").append("Please enter your objetives")
    else
      $("#question2_error").show()
      $("#question2_error").empty()
    return valid

  checkMessage: () =>
    valid = true
    if $("#messages").val() == ""
      valid=false
      $("#messages_error").show()
      $("#messages_error").empty()
      $("#messages_error").append("Please enter a consultation")
    else
      $("#messages_error").show()
      $("#messages_error").empty()
    return valid

  checkStress: () =>
    valid = true
    if $("[name=question3]:checked").length <= 0
      valid=false
      $("#question3_error").show()
      $("#question3_error").empty()
      $("#question3_error").append("Please enter a stress level")
    else
      $("#question3_error").show()
      $("#question3_error").empty()
    return valid

  onMessageChange: (event) =>
    $txt = $(event.target)
    text = $txt.val()
    length = text.length
    limit = 400
    if length <= limit
      $('#letters', @$el).html(length)
      return true
    else
      new_text = text.substr(0, limit);
      $txt.val(new_text);
      return false

  new: () =>

    $('#btn-last-step span.loader').removeClass 'hidden'
    data =
      quiz:
        'question1': $('#question1', @$el).val()
        'question2': $('#question2', @$el).val()
        'question3': $('[name=question3]:checked', @$el).val()
      mood: $("[name=options]:checked", @$el).val()
      message: $('#messages', @$el).val()

    appointment = new App.Models.Appointment data
    appointment.save({}, {
      success: (model, response) =>
        @$el.unblock()
        app.me.fetch()
        Backbone.history.navigate("appointment/#{model.id}", {trigger: true})
      error: (model, response) =>
        @$el.unblock()
        @error(response.responseJSON)
        $('#btn-last-step span.loader').addClass 'hidden'
      wait: true
    })

  onTryCcForm: () =>
    $('.payment-declined', @$el).fadeOut 'slow', ->
      $('#card-form', @$el).fadeIn 'slow'
      $('#btn-last-step').show()
      $('#btn-try-again').hide()

  getStripeToken: (event) =>
    event.preventDefault()

    return unless @checkValidationCreditCards()

    $('#btn-last-step span.loader').removeClass 'hidden'
    $('#btn-last-step span.btn-text').hide()

    that = this

    $form = $('form#card-form', @$el)

    $('[data-stripe=name]', @$el).val("#{$('#firstname').val()} #{$('#lastname').val()}")
    $('[data-stripe=exp-month]', @$el).val($('[data-name=month]').val())
    $('[data-stripe=exp-year]', @$el).val($('[data-name=year]').val())

    Stripe.card.createToken($form, that.createSubscription)

    return false

  createSubscription: (status, stripe) =>

    that = this

    if stripe.error
      $('.payment-errors', @$el).text(stripe.error.message)
      $('#btn-last-step span.loader').addClass 'hidden'
      $('#btn-last-step span.btn-text').show()
      return

    coupon = $('#promo-code').val()

    app.me.save({'create_stripe_customer':1, 'source': stripe.id, 'coupon': coupon},
      success: (model) ->
        app.me.unset('create_stripe_customer')
        app.me.unset('source')
        
        app.me.fetch({
          success: (model, data, xhr) =>
            unless data.error
              $('#card-form', @$el).fadeOut 'slow', ->
                $('#plan-price').html(app.me.get('subscription').stripe_data.plan.amount / 100)
                $('#cc-last4').html(app.me.get('credit_cards').data[0].last4)
                $('.payment-ok', @$el).fadeIn ('slow')
                $('#btn-last-step').hide()
                $('#btn-consult-continue').show()
                $('#btn-last-step span.loader').addClass 'hidden'
                $('#btn-last-step span.btn-text').show()
        })
        
      error: (res) ->
        $('#btn-last-step span.loader').addClass 'hidden'
        $('#btn-last-step span.btn-text').show()
        $('#card-form', @$el).fadeOut 'slow', ->
          $('.payment-declined', @$el).fadeIn ('slow')
          $('#btn-last-step').hide()
          $('#btn-try-again').show()

    )
    

  checkValidationCreditCards:()->
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

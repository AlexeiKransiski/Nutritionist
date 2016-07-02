class App.Views.Main.Nutritionist.IndexOld extends Null.Views.Base
  template: JST['app/main/nutritionist/index.html']

  that = @

  events:
    'click #filters span': 'onListFilter'
    'click .filter-list .item .completed': 'onCloseAppointment'
    'click #active-account-2 .sidebar-right .addmore button': 'onOpenAppointmentForm'
    'click #appointments .panel-header .back a': 'onCloseAppointmentForm'
    'click #appointments #appointment_part_1 .panel-footer button.btn-primary': 'onNextStepAppointmentForm'
    #'click #appointments #appointment_part_2 .panel-footer button.btn-primary': 'onCreateAppointmentForm'
    'click #appointments #appointment_part_2a .panel-footer button.btn-primary': 'onCreateAppointmentForm'
    #'click #appointments #appointment_part_2 .panel-footer button.btn-default': 'onGoBackAppointmentForm'
    'click #appointments #appointment_part_2a .panel-footer button.btn-default': 'onGoBackAppointmentForm'
    'click .modal-footer #addCard': 'onAddCard'

    # nuevos eventos
    'click #active-account-2 .sidebar-right .getconsult button': 'onOpenMoreConsults'
    'click #add_more_consults .panel-header .back a': 'onCloseMoreConsults'
    'click #add_more_consults button.btn-default': 'onCancelMoreConsults'
    'click #choose_plan button.btn-primary': 'onNextStepCreditCard'
    'click #credit_card .panel-header .back a': 'onCloseCreditCard'
    'click #credit_card button.btn-default': 'onCancelCreditCard'
    'click #credit_card button.btn-primary': 'onProcessCreditCard'
    'click #payment button.btn-primary': 'onCreateNewConsult'
    'click #payment button.btn-default': 'onBackNutritionist'
    'click #active-account-2 .sidebar-right .upgradeplan button': 'onChooseNewPlan'
    'click #upgrade_plan .panel-header .back a': 'onCloseNewPlan'
    'click #upgrade_plan button.btn-default': 'onCancelNewPlan'
    'click #upgrade_plan button.btn-primary': 'onNextStepCreditCardPlan'

    'change #appointments input, #appointments textarea': 'onChangeInput'
    'change #myModalcard input': 'onChangeCardInput'
    'change.bfhselectbox #myModalcard .bfh-selectbox': 'onChangeCardInput'
    'ifChecked .terms input': 'onChangeCardInput'
    'ifUnchecked .terms input': 'onChangeCardInput'

    'ifChecked .custom_radio input': 'onChangeCard'

    'submit #search-appointment': 'onSearch'

  initialize: ->
    super
    @filterBy = 'all'
    @qSearch = ''
    @appointmentDate = new Date()
    @appointments = new  App.Collections.Appointments()
    @lastAppointment = new  App.Collections.Appointments()
    @cards = new App.Collections.Cards()
    @appointmentDates = new Array()

    @listenTo @appointments, 'reset', @getLastAppointment  # update last appointment on reset appoitments
    @listenTo @appointments, 'add', @getLastAppointment  # update last appointment on added appoitment
    @listenTo @lastAppointment, 'reset', @render  # when last appointment is update render again
    @listenTo @cards, 'reset', @updateCards
    @listenTo @cards, 'add', @updateCards


    @spinner = '<span class="spinner-loader"></span>'

    @appointments.fetch
      reset: true
      data:
        user:app.me.id

  getContext: ->
    context = super
    context['me'] = app.me
    context['appointments'] = @appointments
    context['lastAppointment'] = @lastAppointment.first()
    context['qSearch'] = @qSearch
    return context

  render: ->
    super
    @$("#filters li span[data-filter=#{ @filterBy }]").addClass('active')
    that = this

    @$('.terms input').iCheck
      checkboxClass: 'icheckbox_minimal-green'

    @$('.custom_radios input').iCheck
      radioClass: 'iradio_polaris'

    @$('.bfh-selectbox').bfhselectbox()

    @$('.calendario').datepicker
      minDate: 0
      onSelect: (asText, asObject) ->
        that.appointmentDate = $(this).datepicker('getDate')
      beforeShowDay: (date) =>
        withAppointment = $.inArray(date.getTime(), @appointmentDates) >= 0
        return [not withAppointment, if withAppointment then 'busy' else 0]
      dayNamesMin: [
        'S'
        'M'
        'T'
        'W'
        'T'
        'F'
        'S'
        'S'
      ]

    @

  onListFilter: (event) ->
    #$.param(@buildFilterSearchParams()),
    @filterBy = @$(event.currentTarget).data('filter')
    @appointments.fetch
      data: $.param(@buildFilterSearchParams()),
      reset: true,

  onCloseAppointment: (event) ->
    id = @$(event.currentTarget).closest('.item').data('appointment')
    @appointments.get(id).save({status: 'completed'}, {
      patch: true
      success: =>
        @appointments.fetch data: $.param(@buildFilterSearchParams()), reset: true, user:app.me.id
    })

  getLastAppointment: ->
    # we need only date, no time and as number
    @appointmentDates = _.map @appointments.pluck('date'), (date) ->
      return new Date(date.getFullYear(), date.getMonth(), date.getDate()).getTime()
    @lastAppointment.fetch data: $.param(limit: 1), reset: true, user:app.me.id

  onOpenAppointmentForm: (event) ->
    event.preventDefault()

    # create new appointment model
    @newAppointment = new App.Models.Appointment()
    @newAppointment.set('date', @appointmentDate)
    @newAppointment.set('user', app.me.id)

    @$('#active-account-2 .box_down').slideUp 'slow', =>
      @$('.account_down').slideUp 'slow'
      @$('#appointments').slideDown 'slow'

  onOpenMoreConsults: (event) ->
    event.preventDefault()

    @$('#active-account-2 .box_down').slideUp 'slow', =>
      @$('.account_down').slideUp 'slow'
      @$('#add_more_consults').slideDown 'slow'

  onCloseMoreConsults: (event) ->
    event.preventDefault()

    @$('#add_more_consults').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onCancelMoreConsults: (event) ->
    event.preventDefault()

    @$('#add_more_consults').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onNextStepCreditCard: (event) ->
    event.preventDefault()

    @$('#add_more_consults').slideUp 'slow', =>
      @$('#credit_card').slideDown 'slow'

  onCloseCreditCard: (event) ->
    event.preventDefault()

    @$('#credit_card').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onCancelCreditCard: (event) ->
    event.preventDefault()

    @$('#credit_card').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onProcessCreditCard: (event) ->
    event.preventDefault()

    @$('#credit_card button.btn-primary').html('').append(@spinner).delay '10000'

    @$('#credit_card').slideUp 'slow', =>
      @$('#payment').slideDown 'slow'

  onBackNutritionist: (event) ->
    event.preventDefault()

    @$('#payment').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onCreateNewConsult: (event) ->
    event.preventDefault()

    # create new appointment model
    @newAppointment = new App.Models.Appointment()
    @newAppointment.set('date', @appointmentDate)
    @newAppointment.set('user', app.me.id)

    @$('#payment').slideUp 'slow', =>
      @$('.account_down').slideUp 'slow'
      @$('#appointments').slideDown 'slow'

  onCloseAppointmentForm: (event) ->
    event.preventDefault()

    if @$('#appointment_part_2').css('display') == 'block'
      #@$('#appointments #appointment_part_2').toggle 'slide', { direction: 'right' }, 300
      @$('#appointments #appointment_part_2a').toggle 'slide', { direction: 'right' }, 300
      @$('#appointments #appointment_part_1').delay(301).show 'slide', { direction: 'left' }, 100

    @$('#appointments').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onChooseNewPlan: (event) ->
    event.preventDefault()

    @$('#active-account-2 .box_down').slideUp 'slow', =>
      @$('.account_down').slideUp 'slow'
      @$('#upgrade_plan').slideDown 'slow'

  onCloseNewPlan: (event) ->
    event.preventDefault()

    @$('#upgrade_plan').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onCancelNewPlan: (event) ->
    event.preventDefault()

    @$('#upgrade_plan').slideUp 'slow', =>
      @$('#active-account-2 .box_down').slideDown 'slow'
      @$('.account_down').slideDown 'slow'

  onNextStepCreditCardPlan: (event) ->
    event.preventDefault()

    @$('#upgrade_plan').slideUp 'slow', =>
      @$('#credit_card').slideDown 'slow'

  onCreateAppointmentForm: (event) ->
    event.preventDefault()

    #Estas lineas estaban activas
    # cardSelected = @newAppointment.get("card")
    # creditCardInfo =
    #   number: cardSelected.creditcard,
    #   cvc: parseInt(cardSelected.cvv2),
    #   exp_month: cardSelected.month,
    #   exp_year: cardSelected.year
    #
    # Stripe.card.createToken creditCardInfo, @stripeResponseHandler
    # # Hasta aqui
    #
    # @appointments.create(@newAppointment,
    #  wait: true,
    #  success: =>
    #    delete @newAppointment
    # )

  stripeResponseHandler: (status, response)->
    console.log status
    console.log response
    if response.error
      alert response.error.message
    else
      $.ajax
        url:'/api/v1/appointment/pay'
        method: "POST"
        data:
          stripeToken : response.id
          description: "Appointment payment $19.99 for " + app.me.name
        success:(data)->


          that.appointments.create(that.newAppointment,
            wait: true,
            success: =>
              #$("#globalMessage").notify("Hello Box")
              #$.notify({html:"Your consultation was succesfully sent ! Your nutritionist will reply shortly."},{globalPosition: 'bottom right'});
              $.notify.defaults({ className: "success" });
              $.notify("Your consultation was succesfully sent ! Your nutritionist will reply shortly.",{globalPosition: 'bottom right'});
              delete that.newAppointment
          )
        error:(data)->
          alert data.responseJSON.message



  checkValidation:()->
    @clearMessages()
    valid=true
    if $("#question1").val() == ""
      valid=false
      $("#question1_error").show()
      $("#question1_error").empty()
      $("#question1_error").append("Please enter your feelings")

    if $("#question2").val() == ""
      valid=false
      $("#question2_error").show()
      $("#question2_error").empty()
      $("#question2_error").append("Please enter a description")

    #estaba activo en la primera ventana pero se movio a la segunda ventana
    #if $("[name='question3']:checked").val() == undefined
      #valid=false
      #$("#question3_error").show()
      #$("#question3_error").empty()
      #$("#question3_error").append("Please select your stress level")

    return valid

  clearMessages:()->
      $("#question1_error").show()
      $("#question1_error").empty()
      $("#question2_error").show()
      $("#question2_error").empty()
      #se movio a la 2da ventana
      #$("#question3_error").show()
      #$("#question3_error").empty()

  onNextStepAppointmentForm: (event) ->
    event.preventDefault()
    if @checkValidation()
      @cards.fetch
        reset: true
        data:
          user:app.me.id

      that = this
      @$('#appointments #appointment_part_1').toggle 'slide', { direction: 'left' }, 300
      #, complete: -> $(this).block() if that.cards.length > 0
      #@$('#appointments #appointment_part_2').delay(301).show('slide', { direction: 'right'}, 100 )
      @$('#appointments #appointment_part_2a').delay(301).show('slide', { direction: 'right'}, 100 )

  onGoBackAppointmentForm: (event) ->
    event.preventDefault()

    #@$('#appointments #appointment_part_2').toggle 'slide', { direction: 'right' }, 300
    @$('#appointments #appointment_part_2a').toggle 'slide', { direction: 'right' }, 300
    @$('#appointments #appointment_part_1').delay(301).show 'slide', { direction: 'left' }, 100

  onChangeInput: (event) ->
    changed = event.currentTarget
    value = $(event.currentTarget).val()

    obj = @newAppointment.get('quiz')
    obj or= {}
    obj[changed.name] = value

    @newAppointment.set({quiz: obj})

  onChangeCardInput: (event) ->
    changed = event.currentTarget
    value = $(event.currentTarget).val()

    obj = {}
    if changed.name
      obj[changed.name] = if $(event.currentTarget).is(':checkbox') then $(event.currentTarget).is(':checked') else value
    else
      obj[$(event.currentTarget).data('name')] = value

    @card or= new App.Models.Card()
    @card.set(obj)

    console.log @card.toJSON()

  onSearch: (event) ->
    event.preventDefault()

    @qSearch = @$('#search-appointment :text').val().trim()
    @appointments.fetch data: $.param(@buildFilterSearchParams()), reset: true

  updateCards: ->
    if @cards.length > 0
      fragment = $(document.createDocumentFragment())
      @cards.forEach (card, index) =>
        input = $("<input type='radio' class='card' value='#{ card.id }' id='card-#{ card.id }' name='cards' />")
          .prop('checked', card.get('default'))

        li = $('<li class="custom_radio">')
          .append(input)
          .append(" <img src='img/visa_big.png' alt='' /> <label for='card-#{ card.id }'>#{ card.get('creditcard') }</label>")

        fragment.append(li)

        if card.get('default')
          # update card for model
          card = card.clone().toJSON()
          card.card = card._id
          delete card.__v
          delete card._id
          delete card.created
          delete card.owner
          @newAppointment.set 'card', card

      @$('#appointments #appointment_part_2 .list-unstyled').html(fragment)

      @$('.custom_radio input').iCheck
        checkboxClass: 'icheckbox_polaris'
        radioClass: 'iradio_polaris'
    else
      @$('#appointments #appointment_part_2 .list-unstyled').html "There is no any card registered."
    # @$('#appointments #appointment_part_2').unblock()

  onChangeCard: ->
    card = @cards.get(@$('.custom_radio input:checked').val())
    # update card for model
    card = card.clone().toJSON()
    card.card = card._id
    delete card.__v
    delete card._id
    delete card.created
    delete card.owner
    @newAppointment.set 'card', card

  buildFilterSearchParams: ->
    params = {}

    unless @qSearch == ''
      params =
        '$or':[
          'quiz.question1':
            "$regex": @qSearch, "$options": 'i'
        , 'replies':
            "$regex": @qSearch, "$options": 'i'
        ]

    unless @filterBy == 'all'
      params.status = @filterBy
      params.user=app.me.id

    params

  onAddCard: (event) ->
    if @card?
      @cards.create @card, { wait: true }

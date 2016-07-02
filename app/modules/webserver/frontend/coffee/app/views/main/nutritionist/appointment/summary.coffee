class App.Views.Main.Appointment.Summary extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/summary.html']

  initialize: (options) =>
    super
    @actions =
      'select_plan': @selectPlanAction
      'new_appointment': @newAppointmentAction
      'more_appointments': @addMoreAppointmentsAction

    return this

  events:
    'click [data-role=appointment-action]': 'onAppointmentsAction'

  render: () =>
    super
    @setupView()
    return this

  getContext: =>
    last = @collection.findWhere({status: 'completed'})
    return {
      lastAppointment: last
      collection: @collection
    }

  show: () =>
    $('[data-role="sumary-view"]', @$el).fadeIn ('slow')

  hide: () =>
    $('[data-role="sumary-view"]', @$el).fadeOut ('slow')

  setupView: () =>
    $('.calendario', @$el).datepicker
      showOn: "button",
      dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S','S'],

      onSelect: (date, inst) =>
        appointments = @collection.findAppointmentForDate(date)
        appointments[0].navigate()

      beforeShowDay: (date) =>
        if @collection.findAppointmentForDate(date).length > 0
          return [true, '']
        else
          return [false, '']


    what_next = @getNutricionistAppoinmentStatus()

    $('[data-role="last-appointment-status"]', @$el).html(what_next.status)
    $('[data-role="appointment-action"]', @$el).html(what_next.button)
    $('[data-role="appointment-action"]', @$el).data('action', what_next.action)
    return


  onAppointmentsAction: (event) =>
    event.preventDefault()
    $button = $(event.target)

    action = $button.data 'action'
    @actions[action]()

  getAppointmentStatus: () ->
    plan = app.me.get('subscription').plan

  getNutricionistAppoinmentStatus: () =>
    subscription = app.me.get('subscription')
    plan_id = subscription.plan
    for key, value of Config.stripe.plans
      if value.id == plan_id
        plan_data =
          name: key
          data: value

    unless plan_data?
      return ''

    results =
      create_new:
        status: Helpers.getPlanName()
        button: 'NEW APPOINTMENT'
        action: "new_appointment"

      buy_more:
        status: "Exceed number of consultations this month."
        button: "get more consults"
        action: "more_appointments"

      trial_end:
        status: "Trial ended. Please select plan"
        button: "select plan"
        action: "select_plan"

    result = results['create_new']

    # if app.me.get('credit_cards') and plan_id == Config.stripe.plans.trial.id
    #   if subscription.stripe_data.trial_end? or (not subscription.stripe_data.trial_end? and not subscription.stripe_data.trial_start?)
    #     trial_end = moment(subscription.stripe_data.trial_end * 1000)
    #     if trial_end.isBefore(moment())
    #       result = results['trial_end']
    #       return result
    console.log(@collection.at(0))
    if @collection.length > 0
      if app.me.get('subscription_appointments') > 0 or app.me.get('appointments') > 0
        result.status = @collection.at(0).get('status')
      else
        result = results.buy_more

    if @collection.findWhere({status: 'open'})
      result.status = @collection.findWhere({status: 'open'}).get('status')

    return result

      # <!-- Esto deberia cargar si no hay consultas y la cuenta es free -->
      # <p>
      #   STATUS: <%= Helpers.getPlanName() %>
      # </p>
      # <!-- Esto debe aparecer cuando se acaba el nro de consultas por mes del plan -->
      # <p class="hidden">
      #   STATUS: Exceed number of consultations this month
      # </p>
      # <!-- Este texto debe aparecer cuando se acaba el periodo de pruebas -->
      # <p class="hidden">
      #   STATUS: Trial ended. Please select plan
      # </p>

      # Button
      # <!-- Este bottom debe aparecer cuando se terminen las consultas -->
      # <div class="getconsult hidden">
      #   <button type="button" class="btn btn-primary pull-right">get more consults</button>
      # </div>
      #
      # <!-- Esto debe mostrarse cuando se termina el periodo de prueba -->
      # <div class="upgradeplan hidden">
      #   <p>0 Trial Days left.</p>
      #   <button type="button" class="btn btn-primary pull-right">select plan</button>
      # </div>

  newAppointmentAction: () =>
    @fire 'add:consultation:new'
    return

  selectPlanAction: () =>
    @fire 'add:consultation:upgrade'
    return

  addMoreAppointmentsAction: () =>
    @fire 'add:consultation:plan'

    return this

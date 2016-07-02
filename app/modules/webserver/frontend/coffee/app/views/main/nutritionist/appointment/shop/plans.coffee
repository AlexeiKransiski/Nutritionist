class App.Views.Main.Appointment.Shop.Plans extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/shop/plans.html']
  className: 'add_more_consults'

  initialize: (options) =>
    super

    @order = new App.Models.Order({
      items: 12
      discount: 3
    })

    return this


  events:
    'click .plan': 'onSelectPlan'
    'click .action': 'onAction'
    'click [data-role="cancel"]': 'onCancel'
    'resize #choose_plan': 'onResponsivePlan'

  render: ->
    super

    getGridSize = ->
      if window.innerWidth < 600 then 1 else if window.innerWidth < 980 then 2 else 3

    @$('#plans').flexslider
      animation: 'slide'
      animationLoop: false
      itemWidth: 300
      itemMargin: 21
      minItems: getGridSize()
      maxItems: getGridSize()
      controlNav: false
    
    @

  getContext: =>
    return

  refresh: () =>
    @render()
    return this

  show: () =>
    $('#add_more_consults', @$el).fadeIn ('slow')

  hide: () =>
    $('#add_more_consults', @$el).fadeOut ('slow')

  onResponsivePlan: (event) ->
    flexslider
    gridSize = getGridSize()

    flexslider.vars.minItems = gridSize
    flexslider.vars.maxItems = gridSize

  onSelectPlan: (event) =>
    $plan = $(event.target)
    $('button.plan-selector.active', @$el).removeClass('active')
    $plan.addClass('active')

    switch $plan.val()
      when "12" 
        $text = $plan.val() + ' Consults Plans + ' + $plan.attr('data-discount') + ' Consults FREE'
      when "6"
        $text = $plan.val() + ' Consults Plans + ' + $plan.attr('data-discount') + ' Consult FREE'
      when "2"
        $text = $plan.val() + ' Consults Plans'

    $('[data-role="plan-selected-label"]', @$el).html($text)

    @order.set {
      items: $plan.val()
      discount: $plan.data('discount')
    }

  onAction: (event) =>
    event.preventDefault()
    @fire 'add:consultation:card'
    return


  onCancel: (event) =>
    event.preventDefault()
    @fire 'add:consultation:canceled'

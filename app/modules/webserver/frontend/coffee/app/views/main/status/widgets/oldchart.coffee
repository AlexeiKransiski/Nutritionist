class App.Views.Main.Status.Widgets.Charts2 extends Null.Views.Base
  template: JST['app/main/status/widgets/charts33.html']

  events:
    'click .items_selected #items_tracked': 'openTrackedItems'
    'click .items_to_track #close, .items_to_track .btn-default': 'closeTrackedItems'
    'click .group_items button.pull-left': 'showBodyMeasurements'
    'click .group_items button.pull-right': 'showFactsMeasurements'
    'ifChecked .body_items li input[type=checkbox], .nut_items li input[type=checkbox]': 'onChecked'
    'ifUnchecked .body_items li input[type=checkbox], .nut_items li input[type=checkbox]': 'onUnchecked'
    'click #save-track-items': 'onClickTrackedItems'


  openTrackedItems: (event) ->
    event.preventDefault()
    @$('.items_selected').slideUp('1000', =>
      @$(".items_to_track").slideDown('slow')
    )

  closeTrackedItems: (event) ->
    event.preventDefault()
    @$('.items_to_track').slideUp('1000', =>
      @$(".items_selected").slideDown('slow')
      @$("#body").slideUp('slow')
      @$("#facts").slideUp('slow')
      @$("#oculto").slideUp('slow')
      @$(".itemss").slideDown('slow')
    )

  showBodyMeasurements: (event) ->
    @$('.itemss').slideUp('1000', =>
      @$("#body").slideDown('slow')
      @$("#oculto").slideDown('slow')
    )

  showFactsMeasurements: (event) ->
    @$('.itemss').slideUp('1000', =>
      @$("#facts").slideDown('slow')
      @$("#oculto").slideDown('slow')
    )

  onChecked: (event) ->
    console.log "test. test test"
    $el = @$(event.currentTarget)
    text = $el.attr('id')
    $el.parent().parent().addClass 'icon-' + text
    $el.parent().parent().find('label').addClass 'selected'

  onUnchecked: (event) ->
    console.log "test. test test test ifUnchecked"
    $el = @$(event.currentTarget)
    text = $el.attr('id')
    $el.parent().parent().removeClass 'icon-' + text
    $el.parent().parent().find('label').removeClass 'selected'

  onClickTrackedItems: (event) ->
    event.preventDefault()
    @$('.body_items li input[type=checkbox], .nut_items li input[type=checkbox]').each (index, value) ->
      console.log $(value).val()

  render: ->
    super

    @$('.progress-bar').progressbar()

    # custom scrollbar item track
    if @$('#body, #facts').length > 0
      @$('#body, #facts').mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true

    # datepicker status
    @$('#from').datepicker
      showOn: 'button'
      buttonImage: '../../img/calendar.png'
      firstDay: 1
      changeMonth: false
      numberOfMonths: 1
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
      onClose: (selectedDate) =>
        @$('#to').datepicker 'option', 'minDate', selectedDate
        return

    @$('#to').datepicker
      showOn: 'button'
      buttonImage: '../../img/calendar.png'
      firstDay: 1
      changeMonth: false
      numberOfMonths: 1
      dayNamesMin: [
        'S'
        'M'
        'T'
        'W'
        'T'
        'F'
        'S'
      ]
      onClose: (selectedDate) =>
        @$('#from').datepicker 'option', 'maxDate', selectedDate
        return

    @

class App.Views.Main.Progress.Item.New extends Null.Views.Base
  template: JST['app/main/progress/item/new.html']

  initialize: (options) =>
    super
    @show_cancel = (if options.show_cancel? then options.show_cancel else true)
    @on 'crop:done', @onCropCompleted
    @on 'crop:canceled', @onCropCanceled
    return this

  setupSubviews: () =>
    @crop_avatar = new App.Views.Common.Main.Crop.Index
      field: 'photo'
      crop_w: 313
      crop_h: 418
      preview: $('[data-role=progress-photo-container]', @$el)

    return

  events:
    'click button.submit': 'submit'
    'click button.cancel': 'cancel'
    'change input': 'inputChanged'
    'change textarea': 'inputChanged'

  render: () =>
    super

    if @collection.findProgresForDate().length == 0
      @model.set('date', moment().startOf('day').toISOString())
      $('#date', @$el).val moment(@model.escape('date')).format('MMM D, YYYY')

    @setupSubviews()
    @appendView @crop_avatar.render(), '[data-role=upload-photo]'

    @$( "#date" ).datepicker
        showOn: "button",
        buttonImage: "img/new-big_calendar.png",
        numberOfMonths: 1,
        dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S','S'],
        maxDate: +0
        onSelect: (text, inst) =>
          @model.set('date', moment(text).startOf('day').toISOString())
        beforeShowDay: (date) =>
          if @collection.findProgresForDate(date).length > 0
            return [false, '']
          else
            return [true, '']


    # custom details new
    if $('.details_bodynew', @$el).length > 0
      $('.details_bodynew', @$el).mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true, autoScrollOnFocus: false

    return this

  getContext: () =>
    return {model: @model, show_cancel: @show_cancel}

  refresh: (model) =>
    @model = model
    @removeSubviews()
    @render()

  cancel: (event) =>
    event.preventDefault() if event?.preventDefault?
    @fire 'new:canceled'

  submit: (event) =>
    that = @
    event.preventDefault() if event?.preventDefault?
    if @checkValidation()
      @model.set 'height', app.me.get('height').value

      @$el.block()
      $('[data-role=progress-form]', @$el).ajaxSubmit({
        url: @collection.url
        type: "post"
        data: @model.toJSON()
        success: @onCreateSuccess
        error: @onCreateError
      });

      # @collection.create(@model, {
      #   wait: true
      #   success: @onCreateSuccess
      #   error: @onCreateError
      # })

  onCreateSuccess: (model, response) =>
    @$el.unblock()
    @collection.add model
    $.notify.defaults({ className: "success" })
    $.notify("You've succesfully updated your progress.",{globalPosition: 'bottom right'})

    @fire 'new:success'

  onCreateError: (xhr, error, errorText) =>
    @$el.unblock()
    $.notify.defaults({ className: "error" })
    $.notify( xhr?.responseJSON?.message || "There was and error creating your progress.", {globalPosition: 'bottom right'})

  checkValidation:() =>
    @clearMessages()
    valid=true
    if $("#title", @$el).val() == ""
      valid=false
      $("#title_error", @$el).show()
      $("#title_error", @$el).empty()
      $("#title_error", @$el).append("Please enter your title")

    if $("#observations", @$el).val() == ""
      valid=false
      $("#observations_error", @$el).show()
      $("#observations_error", @$el).empty()
      $("#observations_error", @$el).append("Please enter your observations")

    unless @model.get('date')?
      valid = false
      alert 'Select a date from calendar'

    return valid

  clearMessages: () =>
    $("#title_error", @$el).show()
    $("#title_error", @$el).empty()
    $("#observations_error", @$el).show()
    $("#observations_error", @$el).empty()

  inputChanged: (e) =>
    changed = e.currentTarget
    value = $(e.currentTarget).val()

    valueChanged=0
    if app.me.get("widgets").meassure == "metric"
      valueChanged=value
    else
      heightFactor = 1.0 / 0.39370
      valueChanged=value*heightFactor


    return if changed.name in ['current', 'before', 'date']

    if $(e.currentTarget).is(':file')
      @photoChanged = true
    else
      name = changed.name.split('_')[1]
      obj = {}
      obj[name] = valueChanged
      if name in ['weight']

        #height = if changed.name == 'height' then value else @currentProgress.get('height')
        heigth = app.me.get("height").value
        if name == 'weight'
          weight = Helpers.getMeasureValueToStore(value, "mass", app.me.get('widgets').meassure)
        else
          weight = @model.get('weight')

        obj['weight'] = weight
        if weight > 0
          obj['bmi'] = (weight * 10000) / (heigth * heigth) # 10000 is to convert from cm2 to m2
          obj['bmi'] = obj['bmi'].toFixed(2)
        else
          obj['bmi'] = '...Calculating'

        $('#bmi-calculation', @$el).text(obj['bmi'])
      @model.set(obj)

  onCropCompleted: () =>
    $('[data-role=progress-photo-container]', @$el).removeClass('hide')
    $('[data-role=progress-empty-photo]', @$el).addClass('hide')
    return

  onCropCanceled: () =>
    $('[data-role=progress-empty-photo]', @$el).removeClass('hide')
    $('[data-role=progress-photo-container]', @$el).addClass('hide')
    return

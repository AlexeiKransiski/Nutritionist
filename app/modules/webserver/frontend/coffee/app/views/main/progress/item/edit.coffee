class App.Views.Main.Progress.Item.Edit extends Null.Views.Base
  template: JST['app/main/progress/item/edit.html']

  initialize: (options) =>
    super
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
    'click .submit': 'submit'
    'click button.cancel': 'onCanceled'
    'change input': 'inputChanged'
    'change textarea': 'inputChanged'

  render: () =>
    super
    # custom details new
    @setupSubviews()
    @appendView @crop_avatar.render(), '[data-role=upload-photo]'

    if @model.get('photo')
      @onCropCompleted()

    if $('.details_bodynew', @$el).length > 0
      $('.details_bodynew', @$el).mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true, autoScrollOnFocus: false

    return this

  getContext: () =>
    return {model: @model}

  refresh: (model) =>
    @model = model
    @removeSubviews()
    @render()

  onCanceled: (event) =>
    event.preventDefault()
    @fire 'edit:canceled'

  submit: (event) =>
    that = @
    event.preventDefault() if event?.preventDefault?
    if @checkValidation()
      @model.set 'height', app.me.get('height').value
      @$el.block()
      if $('input[name=photo]', @$el).val() != ''
        $('[data-role=progress-form]', @$el).ajaxSubmit({
          url: @model.url()
          type: "put"
          data: @model.toJSON()
          success: @onCreateSuccess
          error: @onCreateError
        });
      else
        @model.save {},{
          success: @onCreateSuccess
          error: @onCreateError
        }

  onCreateSuccess: (data, response) =>
    @$el.unblock()
    @model.set(data) unless data instanceof Backbone.Model
    $.notify.defaults({ className: "success" })
    $.notify("You've succesfully updated your progress.",{globalPosition: 'bottom right'})

    @fire 'edit:success'

  onCreateError: (modal, error, errorText) =>
    @$el.unblock()
    $.notify.defaults({ className: "error" })
    $.notify("There was and error creating your progress.",{globalPosition: 'bottom right'})

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


    return if changed.name in ['current', 'before']

    if $(e.currentTarget).is(':file')
      @photoChanged = true
    else
      obj = {}
      obj[changed.name] = valueChanged
      if changed.name in ['weight']
        heigth = app.me.get("height").value
        weight = Helpers.getMeasureValueToStore(value, "mass", app.me.get('widgets').meassure)
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

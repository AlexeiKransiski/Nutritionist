class App.Views.Common.Main.Crop.Index extends Null.Views.Base
  template: JST['app/common/main/crop/index.html']

  defaults:
    onUploadAndCrop: null # callback when user finish coproint to be called
    field: 'image' # defaul name and id for the file input
    crop_w: 300 # defult width in px of the cropped img
    crop_h: 300 # default height in px of the cropped img

  initialize: (options) =>
    super
    # @options = options
    # @field = options.field
    # @crop_w = options.width
    # @crop_h = options.height
    _.extend @defaults, options

    @on "canceled", @onCropCanceled
    @on "upload_file", @onUploadFile
    return this

  events:
    'change input[type=file]': 'onFileChange'

  render: () =>
    super
    $(":file", @$el).jfilestyle({input: false, buttonText: "upload photo", icon: false})

    return this

  getContext: () =>
    return {field: @defaults.field}


  onFileChange: (event) =>
    console.log "onchange file event"
    return unless  event.target.value != ''
    input = event.target
    @modal_view = new App.Views.Common.Main.Crop.Modal({crop_w: @defaults.crop_w, crop_h: @defaults.crop_h, preview: @defaults.preview})
    @appendView @modal_view.render(), "[data-role=crop-modal-container]"
    @modal_view.loadFile(input)

  onUploadFile: (event) =>
    for key, value of event.view.crop_data
      $("##{@defaults.field}_#{key}", @$el).val(value)
    $("##{@defaults.field}_sw", @$el).val(@defaults.crop_w)
    $("##{@defaults.field}_sh", @$el).val(@defaults.crop_h)
    @fire 'crop_done'
    @fire 'crop:done'
    @modal_view.hide()


  onCropCanceled: (event) =>
    $('input[type=file]', @$el).val(null)
    @fire 'crop:canceled'

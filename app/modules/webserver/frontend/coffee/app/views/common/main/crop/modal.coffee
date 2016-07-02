class App.Views.Common.Main.Crop.Modal extends Null.Views.Base
  template: JST['app/common/main/crop/modal.html']

  dafaults:
    crop_w: 250
    crop_h: 170

  initialize: (options) =>
    super
    @options =
      crop_w: @dafaults.crop_w
      crop_h: @dafaults.crop_h

    _.extend @options, options
    @crop_data

    return this

  events:
    'click [data-role=upload_and_crop]': 'onUploadAndCrop'
    'click [data-role=close]': 'onUploadCancel'

  render: () =>
    super

    $('.modal', @$el).modal({
      keyboard: false
      backdrop: 'static'
      show: false
    })
    $('.modal').on('hidden.bs.modal', @remove)
    $('.modal').on('show.bs.modal', () ->
       $(this).find('.modal-content').css({
         width:'auto', #probably not needed
         height:'auto', #probably not needed
         'max-height':'100%'
        })
    );
    return this

  loadFile: (input) =>
    if input.files and input.files[0]
      reader = new FileReader()
      reader.onload = (e) =>
        $('img[data-role=image-preview]', @$el).attr('src', e.target.result)
        if @options.preview?
          @previewIMG = @options.preview.find('img[data-role=preview-image]')
          @previewIMG.addClass('hide')
          @previewIMG.attr('src', e.target.result)

        @show()

      reader.readAsDataURL(input.files[0])

  setModalWidth: () =>
    if @options.crop_w >= @options.crop_h
      scale = 200/@options.crop_w
    else
      scale = 200/@options.crop_h


    @$pcnt.width(@options.crop_w * scale)
    @$pcnt.height(@options.crop_h * scale)
    return

  show: () =>
    @jc_box = $('.jc-demo-box', @$el)
    @$preview = $('#preview-pane', @$el)
    @$pcnt = $('#preview-pane .preview-container', @$el)
    @$pimg = $('#preview-pane .preview-container img', @$el)
    @setModalWidth()
    # $('.modal-dialog', @$el).css 'min-width', @setModalWidth()
    @cropModal()
    $('.modal', @$el).modal('show')

  hide: () ->
    $('.modal', @$el).modal('hide')



  cropModal: () =>
    that = @
    # uploadUrl: '/api/v1/image_crop_upload'
    # cropUrl: '/api/v1/image_crop_processing'
    @jcrop_api = undefined
    @boundx = undefined
    @boundy = undefined

    @xsize = @$pcnt.width()
    @ysize = @$pcnt.height()
    @aspectRatio = @xsize / @ysize

    $('#target', @$el).Jcrop {
      onChange: @updatePreview
      onSelect: @updatePreview
      aspectRatio: @aspectRatio
      boxWidth: 500
    }, ->
      # Use the API to get the real image size
      bounds = @getBounds()
      that.boundx = bounds[0]
      that.boundy = bounds[1]
      # Store the API in the jcrop_api variable
      that.jcrop_api = this
      # Move the preview into the jcrop container for css positioning
      # that.$preview.appendTo that.jcrop_api.ui.holder
      # that.$preview.appendTo that.jc_box
      that.jcrop_api.ui.holder.addClass('pull-left')
      window.jcapi = that.jcrop_api
      selection_coords = [
        that.boundx/2 - that.options.crop_w/2
        0
        that.boundx/2 + that.options.crop_w/2
        that.boundy
      ]
      that.jcrop_api.setSelect(selection_coords)
      return
    1

  updatePreview: (c) =>
    if parseInt(c.w) > 0
      @$pimg.removeClass('hide')
      @crop_data = c
      window.crop_data = @crop_data
      @rx = @xsize / c.w
      @ry = @ysize / c.h
      @$pimg.css
        width: Math.round(@rx * @boundx) + 'px'
        height: Math.round(@ry * @boundy) + 'px'
        marginLeft: '-' + Math.round(@rx * c.x) + 'px'
        marginTop: '-' + Math.round(@ry * c.y) + 'px'

    return

  onUploadAndCrop: (event) =>
    if @options.preview?
      xsize = @options.preview.width()
      ysize = @options.preview.height()

      rx = xsize/@crop_data.w
      ry = ysize/@crop_data.h
      @previewIMG.css
        width: Math.round(rx * @boundx) + 'px'
        height: Math.round(ry * @boundy) + 'px'
        marginLeft: '-' + Math.round(rx * @crop_data.x) + 'px'
        marginTop: '-' + Math.round(ry * @crop_data.y) + 'px'

      @previewIMG.removeClass('hide')

    @fire "upload_file", @crop_data

  onUploadCancel: (event) =>
    @fire 'canceled'
    @hide()

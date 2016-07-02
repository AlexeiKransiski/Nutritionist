class App.Views.Main.Progress.Index extends Null.Views.Base
  template: JST['app/main/progress/index.html']

  events:
    'click #newprogress': 'newProgress'
    # 'click .observations .edit_user_progress': 'editProgress'
    'click #body-show .icon-help': 'showHowTo'
    'click #howto a': 'hideHowTo'
    'keypress input.mask-number': 'inputKeypess'
    'mouseenter .picturenew': 'hoverEditOnPic'
    'mouseleave .picturenew': 'hoverEditOffPic'

    'mouseenter .observations, .tab-body .observations': 'hoverEditOn'
    'mouseleave .observations, .tab-body .observations': 'hoverEditOff'

  initialize: (options) =>
    super
    @progressCollection = new App.Collections.Progress()
    @listenToOnce @progressCollection, 'sync', @checkCollection
    @listenToOnce @progressCollection, 'add', @checkCollection
    @currentProgress = null
    @photoChanged = false

    @on 'new:entry', @onNewEntry
    @on 'new:canceled', @hideForm
    @on 'new:success', @hideForm
    @on 'last:edit', @hideFooter
    @on 'last:detail', @showFooter
    return this

  getContext: =>
    return {
      collection: @progressCollection
      currentProgress: @currentProgress
    }

  render: =>
    super
    # @loadLastItem()
    @loadCompare()
    @loadTimeline()
    @progressCollection.fetch
      reset: true
      data:
        user:app.me.id

    return this

  checkCollection: () =>
    @loadLastItem()

  loadCompare: () =>
    @compare_view = new App.Views.Main.Progress.Compare.Index
      collection: @progressCollection

    @addView @compare_view.render(), '[data-role=compare-tab]'

  onNewEntry: (event) =>
    $('[data-role="body"]', @$el).click()
    @newProgress()

  newProgress: (event) =>
    event.preventDefault() if event?.preventDefault?
    new_progress = new App.Models.Progress()

    @newItemView(new_progress)

  newItemView: (model, show_cancel = true) =>
    unless @new_item_view
      @new_item_view = new App.Views.Main.Progress.Item.New
        collection: @progressCollection
        model: model
        show_cancel: show_cancel
      @appendView @new_item_view.render(), '[data-role=new-item]'
    else
      @new_item_view.show_cancel = show_cancel
      @new_item_view.refresh(model)

    $('#first-view', @$el).fadeOut 'slow', =>
      $('.neworedit', @$el).fadeIn 'slow'
      return

  loadLastItem: () =>
    unless @progressCollection.length > 0
      console.log "load last item "
      new_progress = new App.Models.Progress()
      @newItemView(new_progress, false)
      return
    unless @last_item_view
      @last_item_view = new App.Views.Main.Progress.Item.Last
        collection: @progressCollection
        model: @progressCollection.first()
        #el: $('[data-role=last-item-container]', @$el)
      # @__appendedViews.add @last_item_view
      @addView @last_item_view.render(), '[data-role=last-item-container]'
    else
      @last_item_view.refresh()

  loadTimeline: () =>
    timeline_view = new App.Views.Main.Progress.Timeline
      collection: @progressCollection
      el: $('[data-role=timeline]')

    @__appendedViews.add timeline_view


  # Events handlers
  inputKeypess: (event) =>
    charCode = if event.which then event.which else event.keyCode
    if charCode != 46 and charCode > 31 and (charCode < 48 or charCode > 57)
      return false
    return true

  hoverEditOn: =>
    $('.edit_user_progress', @$el).fadeIn 'slow'

  hoverEditOff: =>
    $('.edit_user_progress', @$el).fadeOut 'slow'

  hoverEditOnPic: =>
    $('.custom_file', @$el).fadeIn 400

  hoverEditOffPic: =>
    $('.custom_file', @$el).fadeOut 400

  editProgress: (e) =>
    changed = e.currentTarget
    value = $(e.currentTarget).data('cid');
    @currentProgress = @progressCollection.get(value)
    @render()

    $('#first-view', @$el).fadeOut 'slow', =>
      $('#.neworedit', @$el).fadeIn 'slow'
      return
    false

  hideForm: =>
    $('.neworedit', @$el).fadeOut 'slow', =>
      $('#first-view', @$el).fadeIn 'slow'
      return
    false

  showErrorMessage:(response) =>
    if response.error
      alert response.error

  uploadPhoto: (model) =>
    that = @
    if @photoChanged
      $('#progress-form', @$el).ajaxSubmit({
        url: "#{model.url()}/photo"
        type: "post"
        success: (data, xhr) =>
          setTimeout(=>
            model.fetch(
              success: (data) =>
                that.render()
            );
          , 2000);
          that.photoChanged = false
        error: =>
          setTimeout(=>
            model.fetch();
          , 2000);
          console.log "errors: ", arguments
          that.photoChanged = false
      });

  showHowTo: =>
    $('#body-show', @$el).fadeOut 'slow', =>
      $('#howto', @$el).fadeIn 'slow'
      return
    false

  hideHowTo: =>
    $('#howto', @$el).fadeOut 'slow', =>
      $('#body-show', @$el).fadeIn 'slow'
      return
    false

  showFooter: =>
    console.log "show footer"
    $('[data-role=footer]', @$el).removeClass('hide')

  hideFooter: =>

    console.log "hide footer"
    $('[data-role=footer]', @$el).addClass('hide')

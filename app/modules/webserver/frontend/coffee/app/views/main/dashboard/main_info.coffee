class App.Views.Main.Dashboard.MainInfo extends Null.Views.Base
  template: JST['app/main/dashboard/main_info.html']
  className: 'row'

  that = null
  initialize: (options) =>
    super

    that = @
    @on 'crop_done', @changeAvatar

    return this

  setupSubviews: () =>
    @crop_avatar = new App.Views.Common.Main.Crop.Index
      field: 'photo'
      crop_w: 313
      crop_h: 418
      onUploadAndCrop: @changeAvatar

    @foodLog = new App.Collections.FoodLog()
    @exerciseLog = new App.Collections.ExerciseLog()

    id = null
    if app.me.get('patientPreferences') instanceof Object
      id = app.me.get('patientPreferences')._id
    else
      id = app.me.get('patientPreferences')

    @patientPreferences = new App.Models.PatientPreferences({_id: id })
    @patientPreferences.fetch()

    @foodLog.fetch
      data:
        user:app.me.id
        created:moment().hour(0).minutes(0).seconds(0).milliseconds(0).toISOString()

    @exerciseLog.fetch
      data:
        user:app.me.id,
        exercise_date: moment().hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()


    @listenTo @foodLog,'sync',@renderConsumed
    @listenTo @exerciseLog,'sync',@renderBurned

    @listenTo @foodLog,'sync',@renderRemaining
    @listenTo @exerciseLog,'sync',@renderRemaining
    # @listenToOnce @patientPreferences,'sync',@render

  events:

    'click #edit_motivation': 'onEditUserClick'
    'click .info_user_edit [data-role=save-goal]': 'onSaveUserClick'
    'click .info_user_edit [data-role=goal-dismiss], #close': 'onEditUserCloseClick'

    'mouseenter .picture': 'hoverEditOn'
    'mouseleave .picture': 'hoverEditOff'

    # 'change input#avatar': 'changeAvatar'

    'keyup #motivation': 'onMotivationChange'
    'change #motivation': 'onMotivationChange'

    'change .info_user_edit form input': 'inputChanged'
    'change .info_user_edit form textarea': 'inputChanged'
    # 'render': 'afterRender'

  render: (event) =>
    super
    @setupSubviews()

    # $(":file", @$el).jfilestyle({input: false, buttonText: "", icon: false});
    @appendView @crop_avatar.render(), '[data-role="upload-avatar"]'

    return this


  getContext: =>
    return {
      model: @model,
      patientPreferences: @patientPreferences
    }

  renderConsumed:()=>
    $("#consumed").empty()
    $("#consumed").append('<span class="small text-green">food:</span><p> ' + @getCaloriesConsumed() + ' <span class="smallest">Cal</span></p>')

  renderBurned:()=>
    $("#exercise").empty()
    $("#exercise").append('<span class="small text-green">exercise:</span><p> ' + @getCaloriesBurned() + ' <span class="smallest">Cal</span></p>')

  renderRemaining:()=>
    $("#remaining").empty()
    $("#remaining").append('<span class="small text-green">net:</span><p> ' + @getRemaining() + ' <span class="smallest">Cal</span></p>')

  getCaloriesConsumed:()=>
    calories = 0
    if @foodLog.length == 0
      return calories
    else
      @foodLog.each (food) =>
        calories =  parseFloat(calories) + parseFloat(food.get("calories"))
      return calories.toFixed(1)

  getCaloriesBurned:()=>
    calories = 0
    if @exerciseLog.length == 0
      return calories
    else
      @exerciseLog.each (exercise) =>
        calories =  parseFloat(calories) + parseFloat(exercise.get("calories_burned"))
      return calories.toFixed(1)

  getRemaining:()=>
    calories = parseFloat(@getCaloriesConsumed()) - parseFloat(@getCaloriesBurned())
    return calories.toFixed(1)


  # Events
  changeAvatar: =>
    that = @
    $('.pd-right_0 .selfie', @$el).block()
    $('#avatar-form', @$el).ajaxSubmit({
      url: @model.url()
      type: "put"
      success: (data, xhr) =>
        $('.pd-right_0 .selfie', @$el).unblock()
        app.me.set(data)
        @removeSubviews()
        @render()
      error: =>
        $('.pd-right_0 .selfie', @$el).unblock()
        console.log "errors: ", arguments
    });

  hoverEditOn: =>
    $('.custom_file', @$el).fadeIn 400

  hoverEditOff: =>
    $('.custom_file', @$el).fadeOut 400

  onInfoCenterHover: (event) =>
    $("#edit_user", @$el).fadeIn(400)

  onInfoCenterBlur: (event) =>
    $("#edit_user", @$el).fadeOut(400)

  onMotivationChange: (event) =>
    $txt = $(event.target)
    text = $txt.val()
    length = text.length
    limit = 200
    if length <= limit
      $('#motivationletter', @$el).html(length)
      return true
    else
      new_text = text.substr(0, limit);
      $txt.val(new_text);
      return false

  onEditUserClick: (event) =>
    event.preventDefault()
    $('.info_user', @$el).fadeOut 'slow', ->
      $('.info_bottom', @$el).fadeOut(100)
      $(".info_user_edit", @$el).fadeIn('slow')

  onEditUserCloseClick: (event) =>
    event.preventDefault()
    $('.info_user_edit', @$el).fadeOut 'slow', ->
      $('.info_user', @$el).fadeIn('slow')
      $('.info_bottom', @$el).fadeIn('slow')

  onSaveUserClick: (event) =>
    event.preventDefault()
    @model.save {goals: @model.get('goals')},
      patch: true

    @render()
    @renderConsumed()
    @renderBurned()
    @renderRemaining()
    #@renderConsumed()
    #@renderConsumed()

  inputChanged: (e) =>
    changed = event.target
    value = $(event.target).val()

    obj = @model.get('goals')
    obj or= {}
    obj[changed.name] = value

    @model.set({goals: obj})

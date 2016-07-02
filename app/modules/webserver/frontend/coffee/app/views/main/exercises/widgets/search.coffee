###
 All this code should be used also on dashboard, to add food.
###

class App.Views.Main.Exercises.Widgets.Search extends Null.Views.Base
  ###
  Widget designed to serve for many views, and integration is done
  by events.

  Events:
    displayed -> (section) where sections will be:
      * 'search'
      * 'recent'
      * 'favorites'
      * 'list'
      * 'new-exercise'
  ###
  template: JST['app/main/exercises/widgets/search.html']

  events:
    'click .tab-content .addmore p a': 'onAddExerciseManually'
    'click [data-role="search"]': 'onSearch'
    'click [data-toggle=tab]': 'onTabChange'
    'ifChecked .custom_radio input': 'onChangeTypeExercise'
    'focus [data-role="search-results"] input': 'onFocus'
    'submit [ data-role=search-form]': 'preventSubmit'


  onFocus: (event) =>
    console.log "focus"
    $(".result", @$el).mCustomScrollbar("scrollTo",event.target)

  eventsTo:
    onAddExerciseManually: 'new-exercise'
    onShowSearch: 'search'

  initialize: ->
    super

    @totalCalories = new Backbone.Model()

    @favoriteType = 'exercise'

    @tab = 'fb-searchs'
    limit = 50

    @filters =
      #'fb-searchs':
      #  '$or': [{ type: 'generic' }, { type: 'user', user: app.me.id }]
      #  name: ''

      'fb-searchs':
        limit: limit

        # user: app.me.id
        # name: ''

      'fb-recently':
        user: app.me.id
        limit: limit
        # name: ''

      'fb-favorites':
        limit: limit
        favorites:
          '$in': [app.me.id]
        # name: ''

      'fb-list':
        limit: limit
        user: app.me.id
        # name: ''

      # Recipes search is implemented at inicial state but
      # have to done for phase 2
      recipes:
        # user: app.me.id
        limit: limit
        name: ''

    #this are the collections of the 4 types of searchs.
    @searches = new App.Collections.Exercises()
    @recent = new App.Collections.ExerciseLog()
    @favorites = new App.Collections.Exercises()
    @myFavorites = new App.Collections.Favorites()
    @my_lists = new App.Collections.ExerciseLists()

    @tabs =
      'fb-searchs':
        collection: @searches
        item_class: App.Views.Main.Exercises.Widgets.ExerciseItem
        element: '[data-role=search-results]'

      'fb-recently':
        collection: @recent
        item_class: App.Views.Main.Exercises.Widgets.ExerciseItem
        element: '[data-role=recent-results]'

      'fb-favorites':
        collection: @favorites
        item_class: App.Views.Main.Exercises.Widgets.ExerciseItem
        element: '[data-role=favorites-results]'
        isFavorites: true

      'fb-list':
        collection: @my_lists
        item_class: App.Views.Main.Exercises.Widgets.ExerciseListItem
        element: '[data-role=list-results]'


    #@listenTo @searches, 'sync', @updateItems
    @listenTo @searches, 'sync', @addAll
    @listenTo @recent, 'sync', @addAll
    @listenTo @favorites, 'sync', @addAll
    @listenTo @myFavorites, 'sync', @addAll
    @listenTo @my_lists, 'sync', @addAll

    @listenTo @totalCalories, "change", @updateTotalCalories

    @on 'exercise:add', @addExercise
    @on 'cart:add', @onAddToCart
    @on 'list:confirm_delete', @onConfirmDelete
    @on 'list:calculate_total_calories', @onCalculateCalories


    @myFavorites.fetch
      data:
        type: @favoriteType
        owner: app.me.id

    return this

  render: =>
    super

    #@updateItems()

    $(".sec-cont .box", @$el).mCustomScrollbar({
      advanced: {
        updateOnContentResize: true
        autoScrollOnFocus: false
      }
    })

    $(".result", @$el).mCustomScrollbar({
      autoHideScrollbar:true,
      advanced: {
        updateOnContentResize: true
        autoScrollOnFocus: false
      }
    })

    @

  setCaloriesToZero: ()->
    @totalCalories.set "value", 0

  restTotalCalories: (model) ->
    currentVal = 0
    if @totalCalories.get("value") != undefined
      currentVal = @totalCalories.get("value")

    @totalCalories.set "value", parseInt(currentVal) - parseInt(model.get("calories_burned"))

  onCalculateCalories: (event) ->
    console.log event.view.model
    @totalCalories.set "value", 0
    console.log event.view.model.get("exercises")
    for value in event.view.model.get("exercises")
      currentVal = 0
      if @totalCalories.get("value") != undefined
        currentVal = @totalCalories.get("value")

      exerciseCalories = 0
      if value.calories_burned != undefined
            exerciseCalories = value.calories_burned

      @totalCalories.set "value", parseInt(currentVal) + parseInt(exerciseCalories)

  updateTotalCalories: (event) ->
    $("#totalCalories").empty()
    $("#totalCalories").append(@totalCalories.get("value").toFixed(0) + " kcal")

  onAddExerciseManually: (event) ->
    event.preventDefault()

    @newExercise = new App.Models.Exercise()

    @trigger @eventsTo.onAddExerciseManually

    # after trigger update UI
    @$('.first-cont').fadeOut('slow', () =>
      @$('.sec-cont').fadeIn('slow')
    )

    $('.custom_radio input').iCheck({
      radioClass: 'iradio_polaris'
    });

    $('#name').val("")

  onChangeTypeExercise: (event) =>
    if $(event.target).val()=="2"
      $("#cardio").fadeOut 'slow', =>
        $("#strengh").fadeIn 'slow'
    else
      $("#strengh").fadeOut 'slow', =>
        $("#cardio").fadeIn 'slow'

  goBack: ->
    @trigger @eventsTo.onShowSearch

    delete @newExercise if @newExercise?

    @$('.sec-cont').fadeOut('slow', () =>
      @$('.first-cont').fadeIn('slow')
    )

  submit: =>
    that = @

    #@newExerciseLog = new App.Models.ExerciseLog()
    if @$('.sec-cont').is(':visible')  # if form is displayed

      if @checkValidation()
        data = @getFormInputs $('[data-role="new-exercise-form"]'), []

        if data.exercise_type == "1"
          data.met = 7.2
          data.time = parseInt(data.cardio_minutes)
        else
          data.met = 6.3
          data.time = parseInt(data.strenght_minutes)

        data.time = data.time
        weight = app.me.get('weight').value

        data.calories_burned = (data.met * 3.5 * weight/200) * data.time
        data.calories_burned = parseInt(data.calories_burned)

        if data.exercise_type == "1"
          data.calories_burned = parseFloat(data.cardio_cal) if data.cardio_cal != ''
        else
          data.calories_burned = parseFloat(data.strenght_cal) if data.strenght_cal != ''

        @newExercise.set data

        # save and update UI
        @newExercise.save {}, {
          success: =>
            @cleanForm $('[data-role="new-exercise-form"]')
            # @tabs[that.tab].collection.fetch()

            data =
              exercise: @newExercise.id
              exercise_detail: @newExercise.toJSON()
              name: @newExercise.get('name')
              description: @newExercise.get('description')

              distance: data.distance
              time: data.time
              weight: data.weight
              sets: data.sets
              repetitions: data.repetitions
              met: data.met

              calories_burned: data.calories_burned
              exercise_type: @newExercise.get('exercise_type')


            if $('[name=add_log]:checked', @$el).val() == "1"
              exercise_log = new App.Models.ExerciseLog(data)
              exercise_log.set 'user', app.me.id

              @fire 'cart:add', exercise_log

            @goBack()
        }
    else
      @fire 'list:use_not_list'




  checkValidation:()->
    @clearMessages()
    valid=true
    if $("#name").val() == ""
      valid=false
      $("#name_exercise_error").show()
      $("#name_exercise_error").empty()
      $("#name_exercise_error").append("Please enter the exercise name")

    if $("#description",@$el).val() == ""
      valid=false
      $("#description_exercise_error").show()
      $("#description_exercise_error").empty()
      $("#description_exercise_error").append("Please enter the exercise description")

    if $("#time",@$el).val() == ""
      valid=false

    return valid

  clearMessages:()->
    $("#name_exercise_error").show()
    $("#name_exercise_error").empty()
    $("#description_exercise_error").show()
    $("#description_exercise_error").empty()
    #$("#description_list_error").show()
    #$("#description_list_error").empty()

  getNewExcercise: ->
    @newExercise

  onSearch: (event) ->
    event.preventDefault() if event.preventDefault?
    clearTimeout(@delay_search)

    $input = $(event.target).parents('form').find('input')#$(event.target)
    # return @$('.result:visible').unblock() if $input.val().length <= 1 and $input.val().length > 0

    @$('.result:visible').block()
    filter = @filters[@tab]
    filter.name = $input.val()

    @delay_search = setTimeout(() =>
      @tabs[@tab].collection.reset()
      if $input.val().length == 0
        @$('.result:visible').unblock()
      else
        if @tabs[@tab].isFavorites
          favs = _this.myFavorites.pluck('object')
          console.log(favs)
          if favs.length > 0
            @tabs[@tab].collection.fetch
              data:
                _id:
                  $in: favs
                name: $input.val()
        else
          @tabs[@tab].collection.fetch
            data: filter

    , 200)

  onTabChange: (event) =>
    $a = $(event.target)
    @tab = $a.data('role')

    if $a.data('role') == 'fb-list'
      $('.newList').show()
    else
      $('.newList').hide()

    #unless $a.data('role') == 'fb-searchs'
       # if is favorite just request favorite food, not all
    @delay_search = setTimeout(() =>
      @tabs[@tab].collection.reset()
      if @tabs[@tab].isFavorites
        favs = _this.myFavorites.pluck('object')
        if favs.length > 0
          @tabs[@tab].collection.fetch
            data:
              _id:
                $in: favs
        else
          @tabs[@tab].collection.trigger 'sync'
      else if @tab != 'fb-searchs'
        @tabs[@tab].collection.fetch
          data: @filters[@tab]
              # user:app.me.id
    , 200)


  addAll: () =>
    $(@tabs[@tab].element, @$el).html('')
    $(@tabs[@tab].element, @$el).parents('.result').unblock()

    if @tabs[@tab].collection.length
      $(".empty.#{@tab}", @$el).addClass('hide')
      $(".list-unstyled.#{@tab}", @$el).removeClass('hide')
    else
      $(".empty.#{@tab}", @$el).removeClass('hide')
      $(".list-unstyled.#{@tab}", @$el).addClass('hide')
      return

    @tabs[@tab].collection.each @addOne

    $('.ratings input', @$el).iCheck({
      checkboxClass: 'icheckbox_futurico'
    })
    # $(".result", @$el).mCustomScrollbar("update")


  addOne: (item) =>
    item_view = new @tabs[@tab].item_class({model: item, favorites: @myFavorites})
    @appendView item_view.render(), @tabs[@tab].element

  addExercise: (event) =>
    @add_serving.removeAll() if @add_serving?
    @add_serving = new App.Views.Main.Exercises.AddExercise.Search.AddServings({model: event.view.model})
    @appendAfterView @add_serving.render(), event.view.$el

  onAddToCart: (event, exercise_log) =>
    addIt = true
    tempModel=null
    @collection.each (exer) =>
      console.log exer
      if exer.get("name") == exercise_log.get("name")
        addIt = false
        tempModel = exer

    if addIt
      @collection.add exercise_log
    else
      currentVal = 0
      if @totalCalories.get("value") != undefined
        currentVal = @totalCalories.get("value")

      @totalCalories.set "value", parseInt(currentVal) - parseInt(tempModel.get("calories_burned"))
      @collection.remove(tempModel)
      @collection.add exercise_log

    currentVal = 0
    if @totalCalories.get("value") != undefined
      currentVal = @totalCalories.get("value")

    @totalCalories.set "value", parseInt(currentVal) + parseInt(exercise_log.get("calories_burned"))

  onConfirmDelete: (event) =>
    modal = new App.Views.Common.DeleteConfirmation(model: event.view.model)
    @appendView modal.render(), $("[data-role=modal-container]")

    return

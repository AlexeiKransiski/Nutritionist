class App.Views.Main.Exercises.AddExercise.Search.Index extends Null.Views.Base
  template: JST['app/main/exercises/add_exercise/search/index.html']
  className: 'box_search'

  options:
    tab: 'search'

  initialize: (options) =>
    super
    @setup_filters(options)
    @setup_collections(options)
    @setup_tabs(options)
    @setup_listeners(options)
    return @

  events:
    'click [data-toggle=tab]': 'onTabChange'
    'keyup #optsearch': 'onSearchKeyUp'
    'submit [ data-role=search-form]': 'onSearchKeyUp'
    'click [data-role=recent]': 'onRecentTab'
    'click [data-role=new-exercise]': 'onNewExercise'

  render: () =>
    super
    console.log("RENDER")
    return @

   addAll: () =>
    $(@tabs[@options.tab].element, @$el).html('')
    $(@tabs[@options.tab].element, @$el).parents('.result').unblock()

    if @tabs[@options.tab].collection.length
      $(".empty.#{@options.tab}", @$el).addClass('hide')
      $(".list-unstyled.#{@options.tab}", @$el).removeClass('hide')
    else
      $(".empty.#{@options.tab}", @$el).removeClass('hide')
      $(".list-unstyled.#{@options.tab}", @$el).addClass('hide')
      return

    @tabs[@options.tab].collection.each @addOne

    # render the start icon instead of checkbox
    $('.ratings input', @$el).iCheck({
      checkboxClass: 'icheckbox_futurico'
    })

  addOne: (item) =>
    console.log("Add one: " + item)
    console.log(item)
    console.log(@tabs[@options.tab].element)
    item_view = new @tabs[@options.tab].item_class({model: item})
    @appendView item_view.render(), @tabs[@options.tab].element


  setup_listeners: (options) =>
    @listenTo @exercise_search, 'sync', @addAll
    #@listenTo @recent, 'sync', @addAll
    #@listenTo @favorites, 'sync', @addAll
    #@listenTo @my_lists, 'sync', @addAll
    #@listenTo @my_recipes, 'sync', @addAll
    #
    @on 'servings:add', @onAddServings
    @on 'cart:add', @onAddToCart
    @on 'list:confirm_delete', @onConfirmDelete
    return

  setup_tabs: (options) =>
     @tabs =
      search:
        collection: @exercise_search
        item_class: App.Views.Main.Exercises.AddExercise.Search.ExerciseItem
        element: '[data-role=search-results]'
      recent:
        collection: @recent
        item_class: App.Views.Main.Exercises.AddExercise.Search.ExerciseLogItem
        element: '[data-role=recent-results]'
      favorites:
        collection: @favorites
        item_class: App.Views.Main.Exercises.AddExercise.Search.ExerciseItem
        element: '[data-role=favorites-results]'
      list:
        collection: @my_lists
        item_class: App.Views.Main.Exercises.AddExercise.Search.ListItem
        element: '[data-role=list-results]'
      recipes:
        collection: @my_recipes
        item_class: App.Views.Main.Exercises.AddExercise.Search.RecipeItem
        element: '[data-role=recipes-results]'

  setup_collections: (options) =>
    @exercise_search = new App.Collections.Exercises()
    return

  setup_filters: (options) =>
    @filters =
      search:
        '$or': [
          {
            type: 'generic'
          },
          {
            type: 'user'
            user: app.me.id
          }
        ]
        name: ''

      recent:
        user: app.me.id
        name: ''

      favorites:
        favorites:
          '$in': [app.me.id]
        name: ''

      list:
        user: app.me.id
        name: ''

      workouts:
        user: app.me.id
        name: ''

  # events

  # fired by an item element
  # onAddServings: (event) =>
  #   console.log "search.index#onAddServings"
  #   @add_serving.removeAll() if @add_serving?
  #   @add_serving = new App.Views.Main.Exercises.AddExercise.Search.AddServings({model: event.view.model})
  #   @appendAfterView @add_serving.render(), event.view.$el

  onSearchKeyUp: (event) =>
    clearTimeout(@delay_search)
    $input = $(event.target)
    return $(@tabs[@options.tab].element, @$el).parents('.result').unblock() if $input.val().length <= 2

    $(@tabs[@options.tab].element, @$el).parents('.result').block()
    filter = @filters[@options.tab]
    filter.name = $input.val()

    @delay_search = setTimeout(() =>
      @tabs[@options.tab].collection.reset()
      @tabs[@options.tab].collection.fetch
        data: filter

    , 200)

  onTabChange: (event) =>
    $a = $(event.target)
    @options.tab = $a.data('role')

  # fired by an item element
  onAddServings: (event) =>
    @add_serving.removeAll() if @add_serving?
    @add_serving = new App.Views.Main.Exercises.AddExercise.Search.AddServings({model: event.view.model})
    @appendAfterView @add_serving.render(), event.view.$el


  onAddToCart: (event, exercise_log) =>
    #exercise_log.set "exercise_type", @options.meal_type
    @collection.add exercise_log
    @collection.sync()

  onConfirmDelete: (event) =>
    modal = new App.Views.Common.DeleteConfirmation(model: event.view.model)
    @appendView modal.render(), $("[data-role=modal-container]")

    return

  onNewExercise: (event) =>
    event.preventDefault()
    console.log "click exercise manualy"
    @fire 'exercise:new'

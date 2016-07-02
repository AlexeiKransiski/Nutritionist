class App.Views.Main.Exercises.AddExercise.Cart.IndexBK extends Null.Views.Base 
  template: JST['app/main/exercises/add_exercise/cart/index.html']
  options:
    list: 'cart'

  initialize: (options) =>
    super
    @exercise_list_items = new App.Collections.ExerciseLog()

    @lists =
      cart:
        element: '[data-role=exercise-cart]'
        items: '[data-role=cart-items]'
        collection: @collection
      list:
        element: '[data-role=list-viewer]'
        items: '[data-role=list-items]'
        collection: @exercise_list_items
      exercise_info:
        element: '[data-role=food-info]'
        items: null
        collection: null
      create_list:
        element: '[data-role=create-list]'
        items: null
        collection: null

    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'remove', @removeOne
    @listenTo @exercise_list_items, 'reset', @addListItems

    return @


  events:
    'click [data-role=use-list]': 'onUseList'
    'click [data-role=save-list]': 'onSaveList'
    'submit [data-role=new-list-form]': 'onSubmitNewList'
    'click [data-role=cancel-send]': 'onCancelNewList'

  render: () =>
    super
    return @

  getContext: =>
    super

  checkListElement: () =>

    if @lists[@options.list].collection.length 
      $(".empty.#{@options.list}", @$el).addClass('hide')
      $(".list-unstyled.#{@options.list}", @$el).removeClass('hide')
      $(".actions", @$el).removeClass('hide')
      $(".title_sidebar", @$el).addClass('text-left')
    else
      $(".empty.#{@options.list}", @$el).removeClass('hide')
      $(".list-unstyled.#{@options.list}", @$el).addClass('hide')
      $(".actions", @$el).addClass('hide')
      $(".title_sidebar", @$el).removeClass('text-left')
      return

  showList: (list) =>
    current_list = "#{@options.list}"
    @options.list = list
    $("#{@lists[current_list].element}", @$el).slideUp('slow', () =>
      $("#{@lists[list].element}", @$el).slideDown('slow')
    )

  addListItems: () =>
    @checkListElement()
    @exercise_list_items.each @addItem

  addOne: (item) =>
    @showList('cart')
    @checkListElement()
    @addItem(item)

  addItem: (item) =>
    item_view = new App.Views.Main.Exercises.AddExercise.Cart.Item({model: item})
    @appendView item_view.render(), @lists[@options.list].items

  removeOne: (model) =>
    @checkListElement()

  showExerciseInfo: (exercise) =>
    console.log "Exercises.Cart show info"
    @showList('exercise_info')
    if @exercise_info
      @exercise_info.model = exercise
      @exercise_info.render()
    else
      @exercise_info = new App.Views.Main.Exercises.AddExercise.Cart.ExerciseInfo
        model: exercise
        el: $("#{@lists.exercise_info.element}", @$el)

  showListItems: (model) =>
    @showList('list')

    exercises = _.map model.get('exercises'), (exercise) =>
      delete exercise._id
      return exercise

    @exercise_list_items.each (exercise) =>
      item_view = @__appendedViews.findByModel(exercise)
      if item_view
        item_view.removeAll()
        @__appendedViews.remove(item_view)

    @exercise_list_items.reset exercises

  onUseList: (event) =>
    event.preventDefault()
    @exercise_list_items.each (exercise) =>
      exercise_log = new App.Models.ExerciseLog(exercise.toJSON())
      #exercise_log.set('meal_type', @options.meal_type)
      @collection.add exercise_log

  onSaveList: (event) =>
    event.preventDefault()
    @showList('create_list') 

  onSubmitNewList: (event) =>
    event.preventDefault()
    $form = $('[data-role="new-list-form"]', @$el)
    data = @getFormInputs $form
    console.log "new list: ", data
    exercise_list =
      name: data.name
      description: data.description
      #meal_type: @options.meal_type
      exercises: @collection.toJSON()

    #Temporary saving the exercise log, there we have doubts about the model.  
    new_list = new App.Models.ExerciseList(exercise_list)
    new_list.save()

    @showList('cart')
    @cleanForm($form) 

  onCancelNewList: (event) =>
    event.preventDefault()
    @cleanForm($form)
    @showList('cart')

  resetList: () =>
    @collection.each (exercise) =>
      #food.trigger 'remove' if food
      item_view = @__appendedViews.findByModel(exercise)
      if item_view
        item_view.removeAll()
        @__appendedViews.remove(item_view)
    @collection.reset()
    @checkListElement()

  setNewExercise: (exercise) ->
    @newExercise = exercise

    @$('.exercise-cart').slideUp 'slow', () =>
      @$('.newexer-list').slideDown 'slow'
      
  goBack: ->
    delete @newExercise if @newExercise?

    @$('.newexer-list').slideUp 'slow', () =>
      @$('.exercise-cart').slideDown 'slow'

  # onInputChanged: ->
  #   changed = event.currentTarget
  #   value = $(event.currentTarget).val()
  #   console.log changed

  #   obj = {}
  #   obj[changed.name] = value

  #   @newExercise.set(obj)

  submit: ->
    if @$('.newexer-list').is(':visible')  # if form is displayed
      @$('.newexer-list input').each( (index, input) =>
        $ele = @$(input)
        @newExercise.set $ele.prop('name'), $ele.val()
      )


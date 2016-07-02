class App.Views.Main.Food.AddFood.Cart.Index extends Null.Views.Base
  template: JST['app/main/food/add_food/cart/index.html']
  options:
    list: 'cart'

  #If model is null, its because its a new list.
  @model = null

  initialize: (options) =>
    super
    #@exercise_list_items = new App.Collections.ExerciseLog()

    @lists =
      cart:
        element: '[data-role=food-cart]'
        items: '[data-role=cart-items]'
        collection: @collection
      create_list:
        element: '[data-role=create-list]'
        items: null
        collection: null

    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'remove', @removeOne
    @listenTo @collection, 'reset', @addListItems

    @on 'cart:delete_new_destroy', @onNewList


    return @


  events:
    'click [data-role=use-list]': 'onUseList'
    'click [data-role=save-list]': 'onSaveList'
    'submit [data-role=new-list-form]': 'onSubmitNewList'
    'click [data-role=cancel-send]': 'onCancelNewList'
    'click [data-role=new-list-food]': 'onNewList'

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
    $("#{@lists[current_list].element}", @$el).fadeOut('slow', () =>
      $("#{@lists[list].element}", @$el).fadeIn('slow')
    )

  addListItems: () =>
    @checkListElement()
    @collection.each @addItem

  addOne: (item) =>
    $(".useList").hide()
    $(".saveList").show()
    @checkListElement()
    @addItem(item)

  addItem: (item) =>
    # item_view = new App.Views.Main.Exercises.AddExercise.Cart.Item({model: item})
    item_view = new App.Views.Main.Food.AddFood.Cart.Item({model: item})
    @appendView item_view.render(), @lists[@options.list].items

  removeOne: (model) =>
    @checkListElement()
    $(".saveList").show()
    $(".useList").hide()

  showExerciseInfo: (exercise) =>
    @showList('exercise_info')
    if @exercise_info
      @exercise_info.model = exercise
      @exercise_info.render()
    else
      @exercise_info = new App.Views.Main.Exercises.AddExercise.Cart.ExerciseInfo
        model: exercise
        el: $("#{@lists.exercise_info.element}", @$el)

  showListItems: (model) =>
    @model = model
    $("#listName").empty();
    $("#listName").append(model.get('name'));

    foods = _.map model.get('foods'), (food) =>
      delete food._id
      return food

    @collection.each (food) =>
      item_view = @__appendedViews.findByModel(food)
      if item_view
        item_view.removeAll()
        @__appendedViews.remove(item_view)

    @collection.reset foods

  onUseList: (event) =>
    event.preventDefault()
    @fire 'list:use'


  onSaveList: (event) =>
    event.preventDefault()
    #if @checkValidation()
    if @model != null && @model != undefined
      @model.set("foods",@collection.toJSON())
      @model.save()
      $(".saveList").hide();
      $(".useList").show();
    else
      @showList('create_list')


  checkValidation:()->
    @clearMessages()
    valid=true
    if $("#name",@$el).val() == ""
      valid=false
      $("#name_list_error").show()
      $("#name_list_error").empty()
      $("#name_list_error").append("Please enter a list name")

    if $("#description",@$el).val() == ""
      valid=false
      $("#description_list_error").show()
      $("#description_list_error").empty()
      $("#description_list_error").append("Please enter the list description")
    return valid

  clearMessages:()->
    $("#name_list_error").show()
    $("#name_list_error").empty()
    $("#description_list_error").show()
    $("#description_list_error").empty()

  onSubmitNewList: (event) =>
    event.preventDefault()
    if @checkValidation()
      $form = $('[data-role="new-list-form"]', @$el)
      data = @getFormInputs $form
      food_list =
        name: data.name
        description: data.description
        meal_type: @options.meal_type
        foods: @collection.toJSON()

      new_list = new App.Models.FoodList(food_list)
      new_list.save()
      @model = new_list
      @showList('cart')
      @cleanForm($form)
      $(".saveList").hide();
      $("#listName").empty();
      $("#listName").append(data.name);

    #$form = $('[data-role="new-list-form"]', @$el)
    #data = @getFormInputs $form
    #console.log "new list: ", data
    #exercise_list =
    #  name: data.name
    #  description: data.description
    #  #meal_type: @options.meal_type
    #  exercises: @collection.toJSON()

    #Temporary saving the exercise log, there we have doubts about the model.
    #new_list = new App.Models.ExerciseList(exercise_list)
    #new_list.save()

    #@model = new_list

    #$("#listName").empty();
    #$("#listName").append(data.name);

    #@showList('cart')
    #@cleanForm($form)
    #$(".saveList").hide();
    #$(".useList").show()
    #@fire 'list:save'


  onCancelNewList: (event) =>
    event.preventDefault()
    $form = $('[data-role="new-list-form"]', @$el)
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

    @$('.exercise-cart').fadeOut 'slow', () =>
      @$('.newexer-list').fadeIn 'slow'

  goBack: ->
    delete @newExercise if @newExercise?

    @$('.newexer-list').fadeOut 'slow', () =>
      @$('.exercise-cart').fadeIn 'slow'


  submit: ->
    if @$('.newexer-list').is(':visible')  # if form is displayed
      @$('.newexer-list input').each( (index, input) =>
        $ele = @$(input)
        @newExercise.set $ele.prop('name'), $ele.val()
      )

  onNewList: ->
    @model = null
    _.invoke(@collection.toArray(), 'destroy');
    $("#listName").empty();
    $("#listName").append("NEW LIST");
    @fire 'list:calories_to_zero'

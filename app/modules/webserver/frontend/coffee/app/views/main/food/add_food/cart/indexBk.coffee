class App.Views.Main.Food.AddFood.Cart.Index2 extends Null.Views.Base
  template: JST['app/main/food/add_food/cart/index.html']
  options:
    meal_type: ''
    list: 'cart'

  initialize: (options) =>
    super
    @food_list_items = new App.Collections.FoodLog()

    @lists =
      cart:
        element: '[data-role=food-cart]'
        items: '[data-role=cart-items]'
        collection: @collection
      list:
        element: '[data-role=list-viewer]'
        items: '[data-role=list-items]'
        collection: @food_list_items
      food_info:
        element: '[data-role=food-info]'
        items: null
        collection: null
      create_list:
        element: '[data-role=create-list]'
        items: null
        collection: null

    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'remove', @removeOne

    @listenTo @food_list_items, 'reset', @addListItems
    @

  events:
    'click [data-role=use-list]': 'onUseList'
    'click [data-role=save-list]': 'onSaveList'
    'submit [data-role=new-list-form]': 'onSubmitNewList'
    'click [data-role=cancel-send]': 'onCancelNewList'

  render: () =>
    super

    @

  getContext: =>
    return {meal_type: @options.meal_type}

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
    @food_list_items.each @addItem

  addOne: (item) =>
    @showList('cart')
    @checkListElement()
    @addItem(item)

  addItem: (item) =>
    item_view = new App.Views.Main.Food.AddFood.Cart.Item({model: item})
    @appendView item_view.render(), @lists[@options.list].items


  removeOne: (model) =>
    @checkListElement()

  showFoodInfo: (food) =>
    @showList('food_info')
    if @food_info
      @food_info.model = food
      @food_info.render()
    else
      @food_info = new App.Views.Main.Food.AddFood.Cart.FoodInfo
        model: food
        el: $("#{@lists.food_info.element}", @$el)

  showListItems: (model) =>
    @showList('list')

    foods = _.map model.get('foods'), (food) =>
      delete food._id
      return food

    @food_list_items.each (food) =>
      item_view = @__appendedViews.findByModel(food)
      if item_view
        item_view.removeAll()
        @__appendedViews.remove(item_view)

    @food_list_items.reset foods

  onUseList: (event) =>
    event.preventDefault()
    @food_list_items.each (food) =>
      food_log = new App.Models.FoodLog(food.toJSON())
      food_log.set('meal_type', @options.meal_type)
      @collection.add food_log

  onSaveList: (event) =>
    event.preventDefault()
    @showList('create_list')

  onSubmitNewList: (event) =>
    event.preventDefault()
    $form = $('[data-role="new-list-form"]', @$el)
    data = @getFormInputs $form
    food_list =
      name: data.name
      description: data.description
      meal_type: @options.meal_type
      foods: @collection.toJSON()

    new_list = new App.Models.FoodList(food_list)
    new_list.save()
    @showList('cart')
    @cleanForm($form)

  onCancelNewList: (event) =>
    event.preventDefault()
    @cleanForm($form)
    @showList('cart')

  resetList: () =>
    @collection.each (food) =>
      #food.trigger 'remove' if food
      item_view = @__appendedViews.findByModel(food)
      if item_view
        item_view.removeAll()
        @__appendedViews.remove(item_view)
    @collection.reset()
    @checkListElement()

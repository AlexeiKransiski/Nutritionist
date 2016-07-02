class App.Views.Main.Food.AddFood.Index extends Null.Views.Base
  template: JST['app/main/food/add_food/index.html']
  options:
    meal_type: ''

  @selectedFoodList=null

  that = null
  @patientPreferences=null

  initialize: (options) =>
    super
    @dateSearch = options.dateSearch

    # flag to know which views are rendered
    # used on onCancel

    that = @
    @new_food = false

    @patientPreferences=options.patientPreferences

    @collection = new App.Collections.FoodLog()
    @listenTo @collection, 'add', @onListChange
    @listenTo @collection, 'remove', @onListChange
    @listenTo @collection, 'reset', @onListChange

    @listenToOnce @patientPreferences, 'sync', @render

    @on 'servings:add', @onShowFoodInfo
    @on 'servings:cancel', @onServingsCancel

    @on 'list:view', @onListView
    @on 'food:new', @onNewFood
    @on 'food:create', @onCreateFood
    @on 'food:cancel', @onCancel
    @on 'list:delete_current_list', @onDeleteCurrentList
    @on 'list:use_not_list', @onUseNotList


  events:
    'click #backButton': 'onBack'
    'click [data-role=cancel]': 'onCancel'
    'click [data-role=send-food-log]': 'onSendFoodLog'

  render: () =>
    super

    $('#todayListDates', @$el).datepicker({
      dateFormat: "M d, yy",
      showOn: "button",
      buttonImage: "img/new-big_calendar.png",
      numberOfMonths: 1,
      dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S','S'],
      maxDate: +0
    })

    $('#todayListDates', @$el).datepicker('setDate', @dateSearch.toDate())

    # search box
    @search = new App.Views.Main.Food.AddFood.Search.Index
      collection: @collection
      meal_type: @options.meal_type

    @appendView @search.render(), "[data-role=search]"

    # food cart box
    @cart = new App.Views.Main.Food.AddFood.Cart.Index
      collection: @collection
      meal_type: @options.meal_type

    @appendView @cart.render(), '[data-role=cart]'

    # new food
    @food_info = new App.Views.Main.Food.AddFood.NewFood.FoodInfo(
      meal_type: @options.meal_type
    )
    @appendView @food_info.render(), "[data-role=new-food-info]"
    @nutricional_facts = new App.Views.Main.Food.AddFood.NewFood.NutricionalFacts()
    @appendView @nutricional_facts.render(), "[data-role=cart]"


    # food log tables
    @food_log_table = new App.Views.Main.Food.Table
      collection: @options.food_log
      patientPreferences:@patientPreferences

      filter:
        meal_type: @options.meal_type
        created: @dateSearch.toISOString()

    #@options.food_log.fetch()
    @appendView @food_log_table.render(), "[data-role=food_log-table]"

    @options.food_log.each(@food_log_table.addOne) if @options.food_log instanceof App.Collections.FoodLog
    @listenTo @options.food_log, 'add', @setKcals
    @listenTo @options.food_log, 'remove', @setKcals
    @listenTo @options.food_log, 'sync', @setKcals
    @setKcals()

    return this

  getContext: =>
    return { meal_type: @options.meal_type}

  setKcals: () =>
    kcals = _.reduce(@options.food_log.pluck('calories'), (memo, cals) ->
      return memo + parseFloat(cals)
    , 0)
    $("[data-role=meal-kcals]", @$el).html("#{kcals.toFixed(1)} kcals")
    $("[data-role=meal-kcals-footer]", @$el).html("#{kcals.toFixed(1)}")

  setMealType: (meal_type) =>
    @options.meal_type = meal_type
    @render()

  setCollection: (collection) =>
    @collection = collection

  # events
  onBack: (event) =>
    event.preventDefault()
    if @new_food
      $('[data-role=new-food-info]', @$el).fadeOut('slow', () =>
        $('[data-role=search]', @$el).fadeIn('slow')
      )

      @nutricional_facts.$el.fadeOut('slow', () =>
        @cart.$el.removeClass('hide')
        @nutricional_facts.$el.addClass('hide')
        @cart.$el.fadeIn('slow')
      )
      @new_food = false  # no new food
    else
      @cart.resetList()
      @fire('show:all')

  onShowFoodInfo: (event) =>
    # @cart.showFoodInfo(event.view.model)

  onServingsCancel: (event) =>
    @cart.showList('cart')

  onListView: (event) =>
    @selectedFoodList=event.view.model
    @cart.showListItems(event.view.model)

  onListChange: () =>
    calories = @collection.pluck('calories')
    total = _.reduce(calories, (memo, num) ->
      memo + parseFloat(num)
    , 0)
    $('[data-role=meal-total-kcal]', @$el).html(total.toFixed(1))

  onCancel: (event) =>
    # cancel can do 2 things
    # if the user on search then reset the cart
    # if the user on newFood render cart
    event.preventDefault() if event?.preventDefault?
    if @new_food
      $('[data-role=new-food-info]', @$el).fadeOut('slow', () =>
        $('[data-role=search]', @$el).fadeIn('slow')
      )

      @nutricional_facts.$el.fadeOut('slow', () =>
        $('[data-role=food-cart]', @$el).fadeIn('slow')
        #@cart.$el.removeClass('hide')
        #@nutricional_facts.$el.addClass('hide')
        #@cart.$el.fadeIn('slow')
      )
      @new_food = false  # no new food
    else
      @cart.resetList()
      @fire('show:all')

  onSendFoodLog: (event) =>
    event.preventDefault()
    # if food_info is visible add the food and should add to cart
    if @food_info.$el.is(':visible')

      if @checkValidation()
        addToCart = @food_info.to_food_log
        @food_info.model.set "user", app.me.id
        # @food_info.model.set "fat", $('#total_fat').val()
        # @food_info.model.set "carbs", $('#total_carbs').val()
        console.log "Save New Food"
        @food_info.model.set({
          serving_types: [{
            name: @food_info.model.escape('serving_type')
            factor: 1
          }]
        })
        $('.totalcal', @$el).block()
        @food_info.model.save({},
          success: =>
            $('.totalcal', @$el).unblock()
            @onCancel()

            servings = parseInt(@food_info.num)
            if isNaN(servings) || servings == undefined
              servings = 0

            data =
              # we need to add food to cart
              food: @food_info.model.id
              food_detail: @food_info.model.toJSON()
              name: @food_info.model.get('name')

              carbs: parseInt(@food_info.model.get('carbs')) * servings,
              fat: parseInt(@food_info.model.get('fat')) * servings,
              protein: parseInt(@food_info.model.get('protein')) * servings,
              cholesterol: parseInt(@food_info.model.get('cholesterol')) * servings,
              sodium: parseInt(@food_info.model.get('sodium')) * servings,
              potassium: parseInt(@food_info.model.get('potassium')) * servings,
              calories: parseInt(@food_info.model.get('calories')) * servings,
              satured: parseInt(@food_info.model.get('satured')) * servings,
              polyunsaturated: parseInt(@food_info.model.get('polyunsaturated')) * servings,
              dietary_fiber: parseInt(@food_info.model.get('dietary_fiber')) * servings,
              monounsaturated: parseInt(@food_info.model.get('monounsaturated')) * servings,
              sugars: parseInt(@food_info.model.get('sugars')) * servings,
              trans: parseInt(@food_info.model.get('trans')) * servings,
              vitamin_a: parseInt(@food_info.model.get('vitamin_a')) * servings,
              vitamin_c: parseInt(@food_info.model.get('vitamin_c')) * servings,
              calcium: parseInt(@food_info.model.get('calcium')) * servings,
              iron: parseInt(@food_info.model.get('iron')) * servings,
              servings: servings
              serving_type: @food_info.model.escape('serving_type')
              serving_factor: 1

            if $("#addToFoodLog").is(':checked')
              newFoodLog = new App.Models.FoodLog(data)

              newFoodLog.set "user", app.me.id
              newFoodLog.set "created", @dateSearch.toISOString()

              newFoodLog.set "meal_type", @food_info.meal_type
              $('.totalcal', @$el).block()
              newFoodLog.save {},
                {
                  success:()->
                    $('.totalcal', @$el).unblock()
                }

            @options.food_log.add(newFoodLog) if @options.meal_type == @food_info.meal_type

            delete @food_info.model

            @search.reloadFoodSearch()

      )
    else
      @foodLogs = new App.Collections.FoodLog()
      @collection.each (item) =>
        newFoodLog = new App.Models.FoodLog(item.toJSON())

        # newFoodLog.set "user", app.me.id
        newFoodLog.set "created", @dateSearch.toISOString()
        newFoodLog.set "meal_type", @options.meal_type # ensure default value
        $('.totalcal', @$el).block()
        newFoodLog.save {},
          {
            success:() =>
              $('.totalcal', @$el).unblock()
          }

        @options.food_log.add(newFoodLog)
      @onNewList()

  onNewList: =>
    _.invoke(@collection.toArray(), 'destroy');

  onNewFood: (event) =>
    @new_food = true
    @food = new App.Models.Food()
    @food_info.refresh(@food)
    @nutricional_facts.model = @food

    $('[data-role=search]', @$el).fadeOut('slow', () =>
      $('[data-role=new-food-info]', @$el).fadeIn('slow')
    )

    #@$('div[class$=\'-list\']').fadeOut 'slow', =>
    @$('.food-cart').fadeOut 'slow', =>
      @$('.newexer-list').fadeIn 'slow'
      @$('.first-cont').fadeOut 'slow'
      @$('.sec-cont').fadeIn 'slow'


  onCreateFood: (event) =>
    console.log "Create Food"
    required = ["calories", "carbs", "cholesterol", "description", "fat", "name", "potassium", "protein", "serving_per_container", "serving_type_name", "sodium"]
    errors = {}
    for field in required
      unless @food.get(field)
        errors[field] = "Required field"

    if Object.keys(errors).length > 0
      @food_info.formErrors $('[data-role="food-info"]', @food_info.$el), errors
      @nutricional_facts.formErrors $('[data-role="nutricional-fatcs"]', @nutricional_facts.$el), errors
      @nutricional_facts.formErrors @nutricional_facts.$el, errors
      return

    @food.set({
      serving_type: [{
        name: @food.get('serving_type_name')
        factor: 1
      }]
    })
    @food.set({type: 'user'})
    @food.save({},{
      success: (model, response) =>
        @onCancel()

      error: (model, error) =>
        console.log "error creating food: ", error if error?
    })

  onDeleteCurrentList: (event,current) =>
    if @selectedFoodList == undefined
        @cart.model = null
    else
      if current.id == @selectedFoodList.id
        @cart.model = null
        _.invoke(@collection.toArray(), 'destroy');
        $("#listName").empty();
        $("#listName").append("NEW LIST");

  onChangeDate:(event) =>
    @options.meal_type

    @food_log_table.collection.fetch
      data:
        user:app.me.id,
        meal_type: @food_info.meal_type,
        created: @dateSearch.toISOString()

    @appendView @food_log_table.render(), "[data-role=food_log-table]"

  checkValidation:()->
    @clearMessages()
    valid=true
    if $("#name").val() == ""
      valid=false
      $("#name_error").show()
      $("#name_error").empty()
      $("#name_error").append("Please enter a food name")

    if $("#description").val() == ""
      valid=false
      $("#description_error").show()
      $("#description_error").empty()
      $("#description_error").append("Please enter a food description")

    if $("#size").val() == ""
      valid=false
      $("#size_error").show()
      $("#size_error").empty()
      $("#size_error").append("Please enter serving size")

    return valid

  clearMessages:()->
    $("#name_error").show()
    $("#name_error").empty()
    $("#description_error").show()
    $("#description_error").empty()
    $("#size_error").show()
    $("#size_error").empty()
    $("#container_error").show()
    $("#container_error").empty()
    $("#sodium_error").show()
    $("#sodium_error").empty()
    $("#total_fat_error").show()
    $("#total_fat_error").empty()
    $("#potassium_error").show()
    $("#potassium_error").empty()
    $("#saturated_error").show()
    $("#saturated_error").empty()
    $("#total_carbs_error").show()
    $("#total_carbs_error").empty()
    $("#polyunsaturated_error").show()
    $("#polyunsaturated_error").empty()
    $("#dietary_fiber_error").show()
    $("#dietary_fiber_error").empty()
    $("#monounsaturated_error").show()
    $("#monounsaturated_error").empty()
    $("#sugars_error").show()
    $("#sugars_error").empty()
    $("#protein_error").show()
    $("#protein_error").empty()
    $("#cholesterol_error").show()
    $("#cholesterol_error").empty()
    $("#vitamin_a_error").show()
    $("#vitamin_a_error").empty()
    $("#calcium_error").show()
    $("#calcium_error").empty()
    $("#vitamin_c_error").show()
    $("#vitamin_c_error").empty()
    $("#iron_error").show()
    $("#iron_error").empty()
    $("#trans_error").show()
    $("#trans_error").empty()

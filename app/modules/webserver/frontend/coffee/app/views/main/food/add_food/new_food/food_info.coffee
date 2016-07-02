class App.Views.Main.Food.AddFood.NewFood.FoodInfo extends Null.Views.Base
  template: JST['app/main/food/add_food/new_food/food_info.html']
  options:
    meal_type: ''

  initialize: (options) =>
    super
    @meal_type =  options.meal_type
    @to_food_log = false
    @on 'food:submit', @onSubmit

    @total_carbs_manualy = false
    @total_fat_manualy = false
    return this

  events:
    'click #backButtonInfo': 'onBack'
    'change input': 'onInputChange'
    'change textarea': 'onInputChange'
    'ifChecked input[type=checkbox]': 'onInputChange'
    'ifUnchecked input[type=checkbox]': 'onInputChange'
    'ifChecked input[type=radio]': 'onInputChange'
    'ifUnchecked input[type=radio]': 'onInputChange'
    'change.bfhselectbox .bfh-selectbox': 'onInputChange'


  render: =>
    super
    $('.custom_radio input[type=radio]').iCheck({
      radioClass: 'iradio_polaris'
    });

    @$('.box_search .box').mCustomScrollbar
      autoHideScrollbar: true
      advanced:
        autoScrollOnFocus: false
        updateOnContentResize: true
        updateOnBrowserResize: true

    @$('.bfh-selectbox').bfhselectbox({
      value: @meal_type
    })

    @

  refresh: (model) =>
    @total_carbs_manualy = false
    @total_fat_manualy = false
    @model = model
    @render()

  onBack:() =>
    @fire 'food:cancel'

  onSubmit: (event) =>
    console.log "food info: submit"

  onInputChange: (event) =>
    console.log "asdasdsadadasdasdsd"
    changed = event.currentTarget
    value = $(event.currentTarget).val()
    @model.set({type: 'generic'})
    if changed.name and changed.name not in ['to_food_log', 'meal_type', 'num']
      obj = {}
      obj[changed.name] = value
      @model.set(obj)
    else
      if changed.name
        # this is used to add to food log
        if changed.name == 'to_food_log'
          @[changed.name] = value == 'yes'
        else
          @[changed.name] = value
      else  # custom select
        @[$(event.currentTarget).data('name')] = value

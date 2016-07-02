class App.Views.Main.Food.Index extends Null.Views.Base
  template: JST['app/main/food/index.html']

  initialize: (options) =>
    super

    @dateSearch = moment().startOf('day')
    # collections
    @breakfast_collection = new App.Collections.FoodLog()
    @early_snack_collection = new App.Collections.FoodLog()
    @lunch_collection = new App.Collections.FoodLog()
    @afternoon_snack_collection = new App.Collections.FoodLog()
    @dinner_collection = new App.Collections.FoodLog()
    @late_snack_collection = new App.Collections.FoodLog()

    @patientPreferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))

    @all = new App.Views.Main.Food.All.Index
      model: app.me
      dateSearch: @dateSearch
      # collections
      breakfast: @breakfast_collection
      early_snack: @early_snack_collection
      lunch: @lunch_collection
      afternoon_snack: @afternoon_snack_collection
      dinner: @dinner_collection
      late_snack: @late_snack_collection

    @on 'add:food-log', @addFood
    @on 'show:all', @showAll
    @on 'shearch:water_log', @showWaterLog

  events:
    'change #todayListDatesGlobal': 'onChangeDate'
    'change #todayListDates': 'onChangeDate'

  render: () =>
    super

    @appendView @all.render(), '[data-role=all]'
    @all.fetchColections()

    return this

  onChangeDate: (event) =>
    new_date = moment($(event.target).val(), "MMM DD, YYYY")
    @dateSearch.year(new_date.year())
    @dateSearch.month(new_date.month())
    @dateSearch.date(new_date.date())

    @all.onChangeDate()
    @add_food.onChangeDate() if @add_food?

  addFood: (event, meal_type) =>
    @add_food.removeAll() if @add_food?

    @add_food = new App.Views.Main.Food.AddFood.Index
      title: meal_type
      patientPreferences: @patientPreferences
      meal_type: meal_type
      food_log: @["#{meal_type}_collection"]
      dateSearch: @dateSearch

    @appendView @add_food.render(), '[data-role=add-food]'

    # Add food behaviors
    @$('.custom_radio input').iCheck
      checkboxClass: 'icheckbox_polaris'
      radioClass: 'iradio_polaris'

    @$('.terms input').iCheck checkboxClass: 'icheckbox_minimal-green'

    # @add_food.setCollection @["#{meal_type}_collection"]
    # @add_food.setMealType(meal_type)
    $('[data-role=all]', @$el).fadeOut('slow', () =>
      $('[data-role=add-food]', @$el).fadeIn('slow')
    )

  showAll: () =>
    @all.refreshAccordion()
    $('[data-role=add-food]', @$el).fadeOut('slow', () =>
      $('[data-role=all]', @$el).fadeIn('slow')
      @all.getDiary("#todayListDateMealDiary")
    )

  showWaterLog:()=>
    alert 1

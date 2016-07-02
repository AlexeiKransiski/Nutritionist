class App.Views.Main.Food.All.Index extends Null.Views.Base
  template: JST['app/main/food/all/index.html']



  initialize: (options) =>
    super
    @dateSearch = options.dateSearch

    @totalCalories = 0

    @patientPreferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))

    @log_stats = new App.Views.Main.Food.All.LogStats
      dateSearch: @dateSearch

    @water_tracker = new App.Views.Main.Food.All.WaterTracker
      dateSearch: @dateSearch

    @nutricional_facts = new App.Views.Main.Food.All.NutricionalFacts
      dateSearch: @dateSearch


    # collections
    @breakfast_collection = @options.breakfast
    @early_snack_collection = @options.early_snack
    @lunch_collection = @options.lunch
    @afternoon_snack_collection = @options.afternoon_snack
    @dinner_collection = @options.dinner
    @late_snack_collection = @options.late_snack

    # for total calories intake - burned section
    @exerciseLog = new App.Collections.ExerciseLog()

    # events
    @listenTo @breakfast_collection, 'sync', @breakfast_kcal
    @listenTo @breakfast_collection, 'remove', @kcal_remove

    @listenTo @early_snack_collection, 'sync', @early_snack_kcal
    @listenTo @early_snack_collection, 'remove', @kcal_remove

    @listenTo @lunch_collection, 'sync', @lunch_kcal
    @listenTo @lunch_collection, 'remove', @lunch_kcal

    @listenTo @afternoon_snack_collection, 'sync', @afternoon_snack_kcal
    @listenTo @afternoon_snack_collection, 'remove', @kcal_remove

    @listenTo @dinner_collection, 'sync', @dinner_kcal
    @listenTo @dinner_collection, 'remove', @kcal_remove

    @listenTo @late_snack_collection, 'sync', @late_snack_kcal
    @listenTo @late_snack_collection, 'remove', @kcal_remove

    @listenTo @exerciseLog, "sync", @getCalorieBurned




    # tables
    @breakfast_table = new App.Views.Main.Food.Table
      collection: @breakfast_collection
      patientPreferences:@patientPreferences
      filter:
        meal_type: 'breakfast'
        user: app.me.id
        created: @dateSearch.toISOString()

    @early_snack_table = new App.Views.Main.Food.Table
      collection: @early_snack_collection
      patientPreferences:@patientPreferences
      filter:
        meal_type: 'early_snack'
        user: app.me.id
        created: @dateSearch.toISOString()

    @lunch_table = new App.Views.Main.Food.Table
      collection: @lunch_collection
      patientPreferences:@patientPreferences
      filter:
        meal_type: 'lunch'
        user: app.me.id
        created: @dateSearch.toISOString()

    @afternoon_snack_table = new App.Views.Main.Food.Table
      collection: @afternoon_snack_collection
      patientPreferences:@patientPreferences
      filter:
        meal_type: 'afternoon_snack'
        user: app.me.id
        created: @dateSearch.toISOString()

    @dinner_table = new App.Views.Main.Food.Table
      collection: @dinner_collection
      patientPreferences:@patientPreferences
      filter:
        meal_type: 'dinner'
        user: app.me.id
        created: @dateSearch.toISOString()

    @late_snack_table = new App.Views.Main.Food.Table
      collection: @late_snack_collection
      patientPreferences:@patientPreferences
      filter:
        meal_type: 'late_snack'
        user: app.me.id
        created: @dateSearch.toISOString()


  render: () =>
    super
    
    @appendView @log_stats.render(), '[data-role=log_stats]'
    @appendView @water_tracker.render(), '[data-role=sidebar]'
    @appendView @nutricional_facts.render(), '[data-role=sidebar]'

    # render tables
    @appendView @breakfast_table.render(), '[data-role=breakfast-table]'
    @appendView @early_snack_table.render(), '[data-role=early_snack-table]'
    @appendView @lunch_table.render(), '[data-role=lunch-table]'
    @appendView @afternoon_snack_table.render(), '[data-role=afternoon_snack-table]'
    @appendView @dinner_table.render(), '[data-role=dinner-table]'
    @appendView @late_snack_table.render(), '[data-role=late_snack-table]'

    return this

  fetchColections: () =>
    async.parallel(
      'breakfast': (done) =>
        @breakfast_table.refresh((err, res) =>
          done(err, res)
        )
      'early_snack': (done) =>
        @early_snack_table.refresh((err, res) =>
          done(err, res)
        )
      'lunch': (done) =>
        @lunch_table.refresh((err, res) =>
          done(err, res)
        )
      'afternoon_snack': (done) =>
        @afternoon_snack_table.refresh((err, res) =>
          done(err, res)
        )
      'dinner': (done) =>
        @dinner_table.refresh((err, res) =>
          done(err, res)
        )
      'late_snack': (done) =>
        @late_snack_table.refresh((err, res) =>
          done(err, res)
        )

      'exercise_log': (done) =>
        @exerciseLog.fetch
          data:
            user:app.me.id,
            exercise_date: @dateSearch.toISOString()

          success: (col, res) =>
            done()
          error: (col, res) =>
            done()

    , (err, results) =>
      $( "#accordion", @$el ).accordion({
          collapsible: true,
          heightStyle: "content"
      })
    )

  refreshAccordion: () =>
    $( "#accordion", @$el ).accordion("refresh")

  # events
  kcal_remove: (item) =>
    kcals = item.get('calories') * -1
    @setTotalKcals(kcals)
    meal_kclas = parseFloat($("[data-role=#{item.get('meal_type')}-kcals]", @$el).html())
    $("[data-role=#{item.get('meal_type')}-kcals]", @$el).html("#{parseFloat(meal_kclas + kcals).toFixed(1)} kcals")

    @log_stats.setKcals(item.get('meal_type'),meal_kclas + kcals)

  breakfast_kcal: () =>
    kcals = _.reduce(@breakfast_collection.pluck('calories'), (memo, cals) ->
      return memo + parseFloat(cals)
    , 0)
    @setKcals('breakfast', kcals)
    @setTotalKcals(kcals)
    @log_stats.setKcals('breakfast',kcals)
    #$("#breakfast-kcals-logs").append("Testkcals")

  early_snack_kcal: () =>
    kcals = _.reduce(@early_snack_collection.pluck('calories'), (memo, cals) ->
      return memo + parseFloat(cals)
    , 0)
    @setKcals('early_snack', kcals)
    @setTotalKcals(kcals)
    @log_stats.setKcals('early-snack',kcals)

  lunch_kcal: () =>
    kcals = _.reduce(@lunch_collection.pluck('calories'), (memo, cals) ->
      return memo + parseFloat(cals)
    , 0)
    @setKcals('lunch', kcals)
    @setTotalKcals(kcals)
    @log_stats.setKcals('lunch',kcals)

  afternoon_snack_kcal: () =>
    kcals = _.reduce(@afternoon_snack_collection.pluck('calories'), (memo, cals) ->
      return memo + parseFloat(cals)
    , 0)
    @setKcals('afternoon_snack', kcals)
    @setTotalKcals(kcals)
    @log_stats.setKcals('afternoon-snack',kcals)

  dinner_kcal: () =>
    kcals = _.reduce(@dinner_collection.pluck('calories'), (memo, cals) ->
      return memo + parseFloat(cals)
    , 0)
    @setKcals('dinner', kcals)
    @setTotalKcals(kcals)
    @log_stats.setKcals('dinner',kcals)

  late_snack_kcal: () =>
    kcals = _.reduce(@late_snack_collection.pluck('calories'), (memo, cals) ->
      return memo + parseFloat(cals)
    , 0)
    @setKcals('late_snack', kcals)
    @setTotalKcals(kcals)
    @log_stats.setKcals('late-snack',kcals)

  setKcals: (table, kcals) =>
    $("[data-role=#{table}-kcals]", @$el).html("#{kcals.toFixed(1)} kcals")


  getCalorieBurned: () =>
    exercise_caloires = @exerciseLog.pluck 'calories_burned'
    @totalCaloriesBurned = _.reduce exercise_caloires, (memo, item) =>
      return memo + parseFloat(item)
    , 0
    @totalCaloriesBurned = @totalCaloriesBurned
    $(".totalCaloriesBurnedLbl", @$el).html(@totalCaloriesBurned.toFixed(1))
    @setCaloriesBalance()


  setTotalKcals:(cals) =>
    @totalCalories =  @totalCalories + parseFloat(cals.toFixed(1))
    $(".totalCaloriesLbl", @$el).html(@totalCalories.toFixed(1))
    @setCaloriesBalance()

  setCaloriesBalance: () =>
    $(".totalCaloriesBalanceLbl", @$el).html((@totalCalories - @totalCaloriesBurned).toFixed(1))


  onChangeDate: ()=>
    @getDiary()

  getDiary:() =>
    @totalCalories = 0
    @water_tracker.getWaterLog(@dateSearch.toISOString())
    @nutricional_facts.getNutritionFacts(@dateSearch.toISOString())

    @breakfast_table.filter =
      user:app.me.id,
      meal_type:"breakfast"
      created: @dateSearch.toISOString()

    @breakfast_table.refresh (err,results) =>
      console.log err, results if err?


    @early_snack_table.filter =
      user:app.me.id,
      meal_type:"early_snack"
      created: @dateSearch.toISOString()

    @early_snack_table.refresh (err,results) =>
      console.log err, results if err?


    @lunch_table.filter =
      user:app.me.id,
      meal_type:"lunch"
      created: @dateSearch.toISOString()

    @lunch_table.refresh (err,results) =>
      console.log err, results if err?


    @afternoon_snack_table.filter =
      user:app.me.id,
      meal_type:"afternoon_snack"
      created: @dateSearch.toISOString()

    @afternoon_snack_table.refresh (err,results) =>
      console.log err, results if err?


    @dinner_table.filter =
      user:app.me.id,
      meal_type:"dinner"
      created: @dateSearch.toISOString()

    @dinner_table.refresh (err,results) =>
      console.log err, results if err?


    @late_snack_table.filter =
      user:app.me.id,
      meal_type:"late_snack"
      created: @dateSearch.toISOString()

    @late_snack_table.refresh (err,results) =>
      console.log err, results if err?

    @exerciseLog.fetch
      data:
        user:app.me.id,
        exercise_date: @dateSearch.toISOString()

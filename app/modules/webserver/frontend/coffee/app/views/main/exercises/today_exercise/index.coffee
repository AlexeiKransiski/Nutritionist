class App.Views.Main.Exercises.TodayExercise.Index extends Null.Views.Base
  template: JST['app/main/exercises/today_exercise/index.html']

  @favsTodayList= null



  initialize: (options) =>
    super

    @totalCaloriesCardio = new Backbone.Model()
    @totalCaloriesStrenght = new Backbone.Model()
    @totalCalories = new Backbone.Model()


    @favoriteType = 'exercise'

    @myFavorites = new App.Collections.Favorites()

    dateStart = moment().hours(0).minutes(0).seconds(0).milliseconds(0)
    dateEnd = moment().hours(23).minutes(59).seconds(59).milliseconds(0)

    @exerciseLog = new App.Collections.ExerciseLog()
    @listenTo @exerciseLog, "sync", @getExercises

    @exerciseLog.fetch
      data:
        user:app.me.id,
        exercise_date: dateStart.toISOString()


    @listenTo @totalCaloriesCardio, "change", @updateCaloriesCardio
    @listenTo @totalCaloriesStrenght, "change", @updateCaloriesStrenght
    @listenTo @totalCalories, "change", @updateTotalCalories

    @on 'cardio:calculate_calories' , @restCalories

    @myFavorites.fetch
      data:
        type: @favoriteType
        owner: app.me.id

  events:
    'change #todayListDate': 'onChangeDate'

  render: () =>
    super

  updateTotalCalories:() =>
    $("#totalCaloriesTodayList").empty()
    $("#totalCaloriesTodayList").append(@totalCalories.get("value"))

  updateCaloriesCardio: () =>
    $("#caloriesCardio").empty()
    $("#caloriesCardio").append(@totalCaloriesCardio.get("value") + " kcal")
    @updateTotalCalories()

  updateCaloriesStrenght: () =>
    $("#caloriesStrength").empty()
    $("#caloriesStrength").append(@totalCaloriesStrenght.get("value") + " kcal")
    @updateTotalCalories()

  restCalories: (event) =>
    caloriesDeleted = event.view.model.get("calories_burned")

    if caloriesDeleted == undefined
        caloriesDeleted=0


    if event.view.model.get("exercise_type") == "1"

       currentCalories = 0
       if @totalCaloriesCardio.get("value") != undefined
            currentCalories=@totalCaloriesCardio.get("value")

       @totalCaloriesCardio.set "value", parseInt(parseFloat(currentCalories) - parseFloat(caloriesDeleted))

    else
      currentCalories = 0
      if @totalCaloriesStrenght.get("value") != undefined
            currentCalories=@totalCaloriesStrenght.get("value")

       @totalCaloriesStrenght.set "value", parseInt(parseFloat(currentCalories) - parseFloat(caloriesDeleted))



    tmpTotalCaloriesStrenght=0
    if @totalCaloriesStrenght.get("value") != undefined
        tmpTotalCaloriesStrenght=@totalCaloriesStrenght.get("value")

    tmpTotalCaloriesCardio=0
    if @totalCaloriesCardio.get("value") != undefined
        tmpTotalCaloriesCardio=@totalCaloriesCardio.get("value")


    @totalCalories.set "value", parseFloat(parseFloat(tmpTotalCaloriesStrenght) + parseFloat(tmpTotalCaloriesCardio)).toFixed(0)


  drawTodayList: (currentExerciseToday) =>
    that = @
    @myFavorites.fetch
      data:
        type: @favoriteType
        owner: app.me.id

      success:(favs)->
        @favsTodayList= favs
        currentExerciseToday.each that.clasifyExercise

  getExercises: ()=>
    @myFavorites.fetch
      data:
        type: @favoriteType
        owner: app.me.id

      success:(favs) =>
        @favsTodayList = favs
        @exerciseLog.each @clasifyExercise

  renderItem:(view,item) =>
    @appendView view, item

  onChangeDate:(event) =>

    dateStart = moment(moment($("#todayListDate").val()).format('MM/DD/YYYY')).hour(0).minute(0).second(0).millisecond(0)

    @totalCaloriesCardio.set "value", 0
    @totalCaloriesStrenght.set "value", 0
    @totalCalories.set "value", 0

    $("#cardioTable").empty()
    $("#strenghtTable").empty()
    @exerciseLog.fetch({data:{"user":app.me.id,"exercise_date":dateStart.toISOString()}})


  clasifyExercise: (exercise) =>
    if exercise.get("exercise_type") == "1"
        tot = 0
        if @totalCaloriesCardio.get("value") != undefined
            tot = @totalCaloriesCardio.get("value")

        exerciseCalories = 0
        if exercise.get("calories_burned") != undefined
            exerciseCalories = exercise.get("calories_burned")

        @totalCaloriesCardio.set "value", parseFloat(parseFloat(tot) + parseFloat(exerciseCalories)).toFixed(0)

    else
        tot = 0
        if @totalCaloriesStrenght.get("value") != undefined
            tot = @totalCaloriesStrenght.get("value")

        exerciseCalories = 0
        if exercise.get("calories_burned") != undefined
            exerciseCalories = exercise.get("calories_burned")

        @totalCaloriesStrenght.set "value", parseFloat(parseFloat(tot) + parseFloat(exerciseCalories)).toFixed(0)


    tmpTotalCaloriesStrenght=0
    if @totalCaloriesStrenght.get("value") != undefined
        tmpTotalCaloriesStrenght=@totalCaloriesStrenght.get("value")

    tmpTotalCaloriesCardio=0
    if @totalCaloriesCardio.get("value") != undefined
        tmpTotalCaloriesCardio=@totalCaloriesCardio.get("value")


    @totalCalories.set "value", parseFloat(parseFloat(tmpTotalCaloriesStrenght) + parseFloat(tmpTotalCaloriesCardio)).toFixed(0)


    if exercise.get("exercise_type") == "1"
        itemView = new App.Views.Main.Exercises.TodayExercise.Cardio({model:exercise, favorites: @favsTodayList})
        @appendView itemView.render(), "[data-role=cardio]"
    else
        itemView = new App.Views.Main.Exercises.TodayExercise.Strength({model:exercise, favorites: @favsTodayList})
        @appendView itemView.render(), "[data-role=strenght]"


    $('.ratings input').iCheck
        checkboxClass: 'icheckbox_futurico'

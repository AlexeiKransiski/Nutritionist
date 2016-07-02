class App.Views.Main.Exercises.Index extends Null.Views.Base
  template: JST['app/main/exercises/index.html']

  @selectedExerciseList=null

  events:
    'click .totalcal #cancel-button': 'onCancel'
    'click .totalcal #submit-button': 'onSubmit'
    'change #todayListDate': 'onChangeDate'

  initialize: (options) ->
    super
    @collection = new App.Collections.ExerciseLog()

    @searchView = new App.Views.Main.Exercises.Widgets.Search
      collection: @collection
    @cartView = new App.Views.Main.Exercises.AddExercise.Cart.Index
      collection: @collection

    @todaysView = new App.Views.Main.Exercises.TodayExercise.Index()

    @listenTo @searchView, 'new-exercise', @onNewExercise
    @listenTo @searchView, 'search', @cartView.goBack

    @on 'list:view', @onListView
    @on 'list:use', @onListUse
    @on 'list:delete_current_list', @onDeleteCurrentList
    @on 'list:save', @onSetCurrentList
    @on 'list:use_not_list', @onUseNotList
    @on 'list:calculate_total_calories_remove_list', @onCalculateCaloriesOnRemoveList
    @on 'list:calories_to_zero', @onCaloriesToZero

  render: ->
    super
    @appendView @searchView.render(), "[data-role=search]"
    @appendView @cartView.render(), "[data-role=cart]"

    #append todays exercise view
    @appendView @todaysView.render(), "[data-role=todays-info]"

    @$( "#accordion" ).accordion
      collapsible: true,
      heightStyle: "content"

    @$('.ratings input').iCheck
      checkboxClass: 'icheckbox_futurico'

  onCancel: (event) ->
    @searchView.goBack()

  onSubmit: (event) ->
    @cartView.submit()
    @searchView.submit()

  onCaloriesToZero: ()->
     @searchView.setCaloriesToZero()

  onNewExercise: ->
    @cartView.setNewExercise(@searchView.getNewExcercise())

  onCalculateCaloriesOnRemoveList:(event) ->
    @searchView.restTotalCalories(event.view.model)

  onListView: (event) =>
    $(".saveList").hide();
    @selectedExerciseList=event.view.model
    @cartView.showListItems(event.view.model)

  onSetCurrentList: (event) =>
    console.log("Al guardar una lista obtenemos")
    console.log event.view.model
    @selectedExerciseList=event.view.model

  onDeleteCurrentList: (event,current) =>
    if @selectedExerciseList == undefined
        @cartView.model = null
    else
      if current.id == @selectedExerciseList.id
        @cartView.model = null
        _.invoke(@collection.toArray(), 'destroy');
        console.log @collection
        $("#listName").empty();
        $("#listName").append("NEW LIST");

  succesSave: (event) =>
    alert(1)

  onUseNotList:(event) =>
    console.log @cartView.collection
    exerciseList = @cartView.collection
    #dateSearch = new Date($("#todayListDate").val());
    @exerciseLogs = new App.Collections.ExerciseLog()
    console.log "Valores"
    for value, index in exerciseList.models
      console.log value

      #dateSearch = new Date($("#todayListDate").val())
      dateSearch = moment($("#todayListDate").val(),"YYYY-MM-DD").hours(0).minutes(0).seconds(0).milliseconds(0)

      newExerciseLog = new App.Models.ExerciseLog()
      newExerciseLog.set "calories_burned", value.get("calories_burned")
      newExerciseLog.set "description",value.get("description")
      newExerciseLog.set "distance",value.get("distance")
      newExerciseLog.set "exercise",value.get("exercise")
      newExerciseLog.set "exercise_date",new Date(dateSearch._i).toISOString()
      newExerciseLog.set "exercise_type",value.get("exercise_type")
      newExerciseLog.set "name",value.get("name")
      newExerciseLog.set "repetitions",value.get("repetitions")
      newExerciseLog.set "sets",value.get("sets")
      newExerciseLog.set "time",value.get("time")
      newExerciseLog.set "weight",value.get("weight")
      newExerciseLog.set "user", app.me.id

      $('.totalcal', @$el).block()
      newExerciseLog.save({}, {
        success: (model, response) =>
          $('.totalcal', @$el).unblock()
        error: (model, response) =>
          $('.totalcal', @$el).unblock()
      })
      @exerciseLogs.add(newExerciseLog)

    @cartView.onNewList()

    @todaysView.drawTodayList(@exerciseLogs)

  onChangeDate:(event)=>
    @todaysView.onChangeDate(event);

  onListUse: (event) =>
    #First we got the exercises list, and add to the exercise log with the current date.

    exerciseList = event.view.model
    exercisesFromList = exerciseList.get("exercises")

    #ExerciseLog Collection
    @exerciseLogs = new App.Collections.ExerciseLog()

    dateSearch = new Date($("#todayListDate").val());

    for value, index in exercisesFromList
      console.log value
      exercise_details =
          exercise: value.exercise,
          name: value.name,
          description: value.description,
          exercise_type: value.exercise_type ,
          time: value.time,
          calories_burned: value.calories_burned,
          sets: value.sets,
          repetitions: value.reps,
          weight: value.weight,
          distance: value.distance


      data =
        exercise_date: new Date(dateSearch.toISOString()).toJSON().slice(0,10),
        exercise: value.exercise,
        exercise_detail: exercise_details,
        name: value.name,
        description: value.description ,

        time: value.time,
        sets: value.sets,
        repetitions: value.reps,
        weight: value.weight,
        distance: value.distance,

        calories_burned: value.calories_burned,
        distance: value.distance,
        exercise_type: value.exercise_type


      exercise_log = new App.Models.ExerciseLog(data)
      exercise_log.set 'user', app.me.id

      console.log "Se va a guardar"
      console.log exercise_log
      exercise_log.save()
      @exerciseLogs.add(exercise_log)


    @todaysView.drawTodayList(@exerciseLogs)

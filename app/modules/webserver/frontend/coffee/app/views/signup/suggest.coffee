class App.Views.Signup.Suggest extends Null.Views.Base
  template: JST['app/signup/suggest.html']

  @caloriesRecommended = 0
  @waterConsumeRecommended = 0
  @timeRecommended = 0
  @patientPreferences=null
  that = null
  events:
    'click #go-back': 'goBack'
    'click #go-dashboard': 'goDashboard'

  initialize: ->
    super
    # TODO: calculate values
    that = @

    id = null
    if app.me.get('patientPreferences') instanceof Object
      id = app.me.get('patientPreferences')._id
    else
      id = app.me.get('patientPreferences')

    @patientPreferences = new App.Models.PatientPreferences({_id: id })
    @patientPreferences.fetch()

    @listenToOnce @patientPreferences, 'sync', @saveUser

    # Google Code for Suggested Conversion Page 
    window.google_trackConversion({
      google_conversion_id: 949533076,
      google_conversion_label: "F89LCKngrWUQlPPixAM",
      google_conversion_language: "en",
      google_conversion_format: "3",
      google_conversion_color: "ffffff",
      google_remarketing_only: false
    });

  render: ->
    super
    $("#suggestions").show();
    @getCaloriesPerDay()
    @getWaterConsume()
    @excerciseRecommendation()

  getWaterConsume:()->
    weight = 0
    weight = parseFloat(app.me.get("weight").value)
    activity = app.me.get("patientPreferences").activity
    weather = app.me.get("patientPreferences").weather

    waterConsume = Helpers.getWaterConsumtion(activity,weight, weather)

    @waterConsumeRecommended = parseFloat(waterConsume).toFixed(1)

    $("#waterConsummePerDay").empty();
    $("#waterConsummePerDay").append(@waterConsumeRecommended + "&nbsp;<span>Lt/ 12 Glasses of Water</span>");

  getCaloriesPerDay:() =>
    @caloriesRecommended = Helpers.getCaloriesPerDay(app.me.get("patientPreferences").activity)

    $("#caloriesPerDay").empty();
    $("#caloriesPerDay").append(@caloriesRecommended + "&nbsp;<span>Cals/day</span>");

  #chos=carbohidratos;chon=proteinas;cooh=grasas
  # TODO: review all the commendations and add the source of this data
  getProteinRecommendation:()->
    return Helpers.getProteinRecommendation(@caloriesRecommended, app.me.get("patientPreferences").activity)
    # return parseFloat(((13 * @caloriesRecommended)/100)/4).toFixed(0)

  getCarbsRecommendation:()->
    return Helpers.getCarbsRecommendation(@caloriesRecommended, app.me.get("patientPreferences").activity)
    # return parseFloat(((65 * @caloriesRecommended)/100)/4).toFixed(0)

  getFatRecommendation:()->
    return Helpers.getFatRecommendation(@caloriesRecommended, app.me.get("patientPreferences").activity)
    # return parseFloat(((20 * @caloriesRecommended)/100)/9).toFixed(0)

  getVitaminARecommendation:()->
    return Helpers.getVitaminARecommendation()

  getVitaminCRecommendation:()->
    return Helpers.getVitaminCRecommendation()

  getIronRecommendation:()->
    return Helpers.getIronRecommendation()

  getCalciumRecommendation:()->
    return Helpers.getCalciumRecommendation()

  getPotassiumRecommendation:()->
    return Helpers.getPotassiumRecommendation()

  getSodiumRecommendation:()->
    return Helpers.getSodiumRecommendation()

  getSugarRecommendation:()->
    return Helpers.getSugarRecommendation()

  getFiberRecommendation:()->
    return Helpers.getFiberRecommendation()

  getCholesterolRecommendation:()->
    return Helpers.getCholesterolRecommendation()

  getTransRecommendation:()->
    return Helpers.getTransRecommendation(@caloriesRecommended)

  getMonounsaturatedRecommendation:()->
    return Helpers.getMonounsaturatedRecommendation(@caloriesRecommended)

  getPolyunsaturatedRecommendation:()->
    return Helpers.getPolyunsaturatedRecommendation(@caloriesRecommended)

  getSaturatedRecommendation:()->
    return Helpers.getSaturatedRecommendation(@caloriesRecommended)

  excerciseRecommendation:()->
    excerciseRecommended = ""
    workout = app.me.get("patientPreferences").workout
    if workout == 15
      $("#excerciseRecommended").empty()
      $("#excerciseRecommended").append("30 <span>mins/Exercise per day</span>")
      @timeRecommended = 30
    else if workout == 30
      $("#excerciseRecommended").empty()
      $("#excerciseRecommended").append("45 <span>mins/Exercise per day</span>")
      @timeRecommended = 45
    else if workout == 45
      $("#excerciseRecommended").empty()
      $("#excerciseRecommended").append("60 <span>mins/Exercise per day</span>")
      @timeRecommended = 60
    else if workout == 60
      $("#excerciseRecommended").empty()
      $("#excerciseRecommended").append("60 <span>mins or more!/Exercise per day</span>")
      @timeRecommended = 60


  goBack: ->
    app.routers[1].navigate("preferences", {trigger: true})

  saveUser:()=>
    app.me.set "calories_recomended", @caloriesRecommended
    app.me.set "water_recomended", @waterConsumeRecommended
    app.me.set "time_recomended", @timeRecommended
    app.me.set "profileFilled", true

    fitness_goals={
        iron : @getIronRecommendation(),
        calcium : @getCalciumRecommendation(),
        vitamin_a : @getVitaminARecommendation(),
        vitamin_c : @getVitaminCRecommendation(),
        trans : @getTransRecommendation(),
        sugars : @getSugarRecommendation(),
        monounsaturated : @getMonounsaturatedRecommendation(),
        dietary_fiber : @getFiberRecommendation(),
        polyunsaturated : @getPolyunsaturatedRecommendation(),
        satured : @getSaturatedRecommendation(),
        calories : 0,
        potassium : @getPotassiumRecommendation(),
        sodium : @getSodiumRecommendation(),
        cholesterol : @getCholesterolRecommendation(),
        protein : @getProteinRecommendation(),
        fat : @getFatRecommendation(),
        carbs : @getCarbsRecommendation()
    }

    app.me.save {profileFilled: true, welcome:1},
      success: =>
        app.me.unset('welcome')
        $.cookies.set('user_id', app.me.id)
        @patientPreferences.set "fitness_goals", fitness_goals
        @patientPreferences.save {}

  goDashboard: (event) =>
    event.preventDefault()

    window.location = '/'

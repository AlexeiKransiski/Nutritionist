class App.Views.Main.Settings.Goals extends App.Views.Base
  template: JST['app/main/settings/goals/goals.html']
  className: 'tab-pane'
  id: 'goals'

  options:
    active: false
  that=null
  slideWeight=null
  slideActivity=null
  slideWorkout=null
  slideWeather=null
  @model=null

  initialize: (options) =>
    super
    that=@

    id = null
    if app.me.get('patientPreferences') instanceof Object
      id = app.me.get('patientPreferences')._id
    else
      id = app.me.get('patientPreferences')


    @patientPreferences = new App.Models.PatientPreferences({_id: id })
    @patientPreferences.fetch
      success:(data)=>
        that.render()


  events:

    'click #edit_goals': 'onEditGoals'
    'click .save_goals_btn .btn': 'onSaveGoals'

  getContext: =>
    return {
      patientPreferences: @patientPreferences
    }


  render: () =>
    super

    $('#weight', @$el).flexslider
      animation: 'slide'
      animationLoop: false
      slideshow: false
      controlNav: false
      start: (slider) =>
        #@slide1=slider
        maintain = that.patientPreferences.get("maintain")
        if maintain == "lose"
          slider.currentSlide=0
          slideWeight=0
        else if maintain == "maintain"
          slider.currentSlide=1
          slideWeight=1
        else if maintain == "gain"
          slider.currentSlide=2
          slideWeight=2
        #lose, maintain, gain

        #slider.flexAnimate(1,true);
        #slider.flexAnimate(1);
        #$( '.flexslider' ).css 'display', 'none'
        return
      after: (slider) =>
        slideWeight = slider.currentSlide
        @getCaloriesPerDay(@getActivityPerIndex(slideActivity), @getMaintainPerIndex(slideWeight), @getWorkoutPerIndex(slideWorkout))


    #@slide1.flexAnimate(2)

    @$('#activity', @$el).flexslider
      animation: 'slide'
      animationLoop: false
      slideshow: false
      controlNav: false
      start: (slider) =>
        #sedentary, light, active, very_active
        activity = that.patientPreferences.get("activity")
        if activity == "sedentary"
          slider.currentSlide = 0
          slideActivity = 0
        else if activity == "light"
          slider.currentSlide = 1
          slideActivity = 1
        else if activity == "active"
          slider.currentSlide = 2
          slideActivity = 2
        else if activity == "very_active"
          slider.currentSlide = 3
          slideActivity = 3

        #$( '.flexslider' ).css 'display', 'none'
        return
      after: (slider) =>
        slideActivity = slider.currentSlide
        @getCaloriesPerDay(@getActivityPerIndex(slideActivity), @getMaintainPerIndex(slideWeight), @getWorkoutPerIndex(slideWorkout))
        @getWaterConsume(@getActivityPerIndex(slideActivity),app.me.get("weight").value,@getWeatherPerIndex(slideWeather))


    @$('#daily', @$el).flexslider
      animation: 'slide'
      animationLoop: false
      slideshow: false
      controlNav: false
      start: (slider) =>
        #15, 30, 45, 60
        workout = that.patientPreferences.get("workout")
        if workout == 15
          slider.currentSlide=0
          slideWorkout=0
        else if workout == 30
          slider.currentSlide=1
          slideWorkout=1
        else if workout == 45
          slider.currentSlide=2
          slideWorkout=2
        else if workout == 60
          slider.currentSlide=3
          slideWorkout=3
        #$( '.flexslider' ).css 'display', 'none'
        return
      after: (slider) =>
        slideWorkout = slider.currentSlide
        @getCaloriesPerDay(@getActivityPerIndex(slideActivity), @getMaintainPerIndex(slideWeight), @getWorkoutPerIndex(slideWorkout))

    @$('#weather', @$el).flexslider
      animation: 'slide'
      animationLoop: false
      slideshow: false
      controlNav: false
      start: (slider) =>
        #cold, temperate, warm, hot
        weather = that.patientPreferences.get("weather")
        if weather == "cold"
          slider.currentSlide=0
          slideWeather=0
        else if weather == "temperate"
          slider.currentSlide=1
          slideWeather=1
        else if weather == "warm"
          slider.currentSlide=2
          slideWeather=2
        else if weather == "hot"
          slider.currentSlide=3
          slideWeather=3
        #$( '.flexslider' ).css 'display', 'none'
        return
      after: (slider) =>
        slideWeather = slider.currentSlide
        @getWaterConsume(@getActivityPerIndex(slideActivity), app.me.get("weight").value, @getWeatherPerIndex(slideWeather))

    @$('#intakes', @$el).flexslider
      animation: 'slide'
      animationLoop: false
      slideshow: false
      controlNav: false

    @$('#water', @$el).flexslider
      animation: 'slide'
      animationLoop: false
      slideshow: false
      controlNav: false

    @

  #Events
  onEditGoals: =>
    event.preventDefault()
    $('.current_goals' , @$el).fadeOut 'slow', =>
      $('.new_goals' , @$el).fadeIn 'slow'
      $('.flexslider', @$el).css( 'display', 'block' ).data('flexslider').resize();
      $('#edit_goals', @$el).fadeOut 'slow', =>
        $('.save_goals_btn' , @$el).fadeIn 'slow'

  onSaveGoals: =>
    event.preventDefault()
    @patientPreferences.set "maintain", @getMaintainPerIndex(slideWeight)
    @patientPreferences.set "activity", @getActivityPerIndex(slideActivity)
    @patientPreferences.set "workout", @getWorkoutPerIndex(slideWorkout)
    @patientPreferences.set "weather", @getWeatherPerIndex(slideWeather)

    @getCaloriesPerDay(@getActivityPerIndex(slideActivity), @getMaintainPerIndex(slideWeight), @getWorkoutPerIndex(slideWorkout))

    fitness_goals = {
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

    @patientPreferences.set "fitness_goals", fitness_goals

    app.me.set "water_recomended", @getWaterConsume(@getActivityPerIndex(slideActivity),app.me.get("weight").value,@getWeatherPerIndex(slideWeather))
    app.me.set "calories_recomended", @caloriesRecommended

    app.me.save {},
      success:(data)=>
        that.patientPreferences.save {},
          success:(data)=>
            that.render()
            @fire('fitness:refresh')


    $('.new_goals' , @$el).fadeOut 'slow', =>
      $('.current_goals' , @$el).fadeIn 'slow'
      $('.save_goals_btn', @$el).fadeOut 'slow', =>
        $('#edit_goals' , @$el).fadeIn 'slow'

  getMaintainPerIndex:(index)=>
    if index == 0
      return "lose"
    else if index == 1
      return "maintain"
    else if index == 2
      return "gain"

  getActivityPerIndex:(index)=>
    if index == 0
      return "sedentary"
    else if index == 1
      return "light"
    else if index == 2
      return "active"
    else if index == 3
      return "very_active"

  getWorkoutPerIndex:(index)=>
    if index == 0
      return 15
    else if index == 1
      return 30
    else if index == 2
      return 45
    else if index == 3
      return 60

  getWeatherPerIndex:(index)=>
    if index == 0
      return "cold"
    else if index == 1
      return "temperate"
    else if index == 2
      return "warm"
    else if index == 3
      return "hot"

  getWaterConsume:(activity,weight,weather)=>
    waterConsume = Helpers.getWaterConsumtion(activity,weight,weather)
    $('.water_lt', @$el).html(parseFloat(waterConsume).toFixed(1))
    $('.water_glasses', @$el).html(Helpers.getWaterGlasses(parseFloat(waterConsume)))
    $('#waterLbl .bottom h3').html(parseFloat(waterConsume).toFixed(1) + ' &nbsp; Lt <span>/ ' + Helpers.getWaterGlasses(parseFloat(waterConsume)) + ' Glasses of Water</span>')
    return parseFloat(waterConsume).toFixed(1)

  getCaloriesPerDay:(activity, maintain, workout)=>
    @caloriesRecommended = Helpers.getCaloriesPerDay(activity, maintain, workout)
    $('.recommened_calories', @$el).html(@caloriesRecommended)
    $('#calorieLbl .bottom h3').html('<h3>' + @caloriesRecommended + ' &nbsp; <span>Cals/day</span></h3>')
    return @caloriesRecommended

  getProteinRecommendation:()->
    return Helpers.getProteinRecommendation(@caloriesRecommended)

  getCarbsRecommendation:()->
    return Helpers.getCarbsRecommendation(@caloriesRecommended)

  getFatRecommendation:()->
    return Helpers.getFatRecommendation(@caloriesRecommended)

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

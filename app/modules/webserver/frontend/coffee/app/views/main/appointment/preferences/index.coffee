class App.Views.Main.Appointment.Preferences.Index extends App.Views.Base
  template: JST['app/main/appointment/preferences/index.html']
  className: 'tab-pane fade'
  id: 'preferences'

  options:
    active: false
    model: null

  initialize: (options) =>
    super

    @options = options
    console.log(@options)

  getContext: ->
    result = super
    result['model'] = @options.model
    result['breakfast'] = @getBreakfast()
    result['early_snack'] = @getEarlySnack()
    result['lunch'] = @getLunch()
    result['afternoon_snack'] = @getAfternoonSnack()
    result['dinner'] = @getDinner()
    result['late_snack'] = @getLateSnack()
    result['exerciseCardioList'] = @getCardioExcersices()
    result['exerciseStrenghtList'] = @getCardioStrength()
    result['totalFoodCalories'] = @getFoodTotalCalories()
    result['totalExcersiceCalories'] = @getExcerciseTotalCalories()
    return result

  getFoodTotalCalories:()->
    totalCalories=0
    @options.foodList.each (value,index)->
      totalCalories=totalCalories + value.get("calories")
    return parseInt(totalCalories)

  getExcerciseTotalCalories:()->
    totalCalories=0
    @options.exerciseList.each (value,index)->
      totalCalories=totalCalories + value.get("calories_burned")
    return parseInt(totalCalories)

  getCardioExcersices:()->
    collection = []
    @options.exerciseList.each (value,index)->
      if value.get("exercise_type") == "1"
        collection.push(value)
    return collection

  getCardioStrength:()->
    collection = []
    @options.exerciseList.each (value,index)->
      if value.get("exercise_type") == "2"
        collection.push(value)
    return collection

  getBreakfast:()->
    collection = []
    @options.foodList.each (value,index)->
      if value.get("meal_type") == "breakfast"
        collection.push(value)
    return collection

  getEarlySnack:()->
    collection = []
    @options.foodList.each (value,index)->
      if value.get("meal_type") == "early_snack"
        collection.push(value)
    return collection

  getLunch:()->
    collection = []
    @options.foodList.each (value,index)->
      if value.get("meal_type") == "lunch"
        collection.push(value)
    return collection

  getAfternoonSnack:()->
    collection = []
    @options.foodList.each (value,index)->
      if value.get("meal_type") == "afternoon_snack"
        collection.push(value)
    return collection

  getDinner:()->
    collection = []
    @options.foodList.each (value,index)->
      if value.get("meal_type") == "dinner"
        collection.push(value)
    return collection

  getLateSnack:()->
    collection = []
    @options.foodList.each (value,index)->
      if value.get("meal_type") == "late_snack"
        collection.push(value)
    return collection

  render: () =>
    super

    @$el.addClass('active') if @options.active

    @$('.progress_status', @$el).mCustomScrollbar
      autoHideScrollbar: true,
      advanced: updateOnContentResize: true

    $('.box-body ul', @$el).mCustomScrollbar(
      autoHideScrollbar:true,
      live: true
      advanced:
        updateOnContentResize: true
    )

    @
  #Events

window.meal_types =
  'breakfast': 'breakfast'
  'early_snack': 'early snack'
  'lunch': 'lunch'
  'afternoon_snack': 'afternoon snack'
  'dinner': 'dinner'
  'late_snack': 'late snack'

window.Helpers ={
  parseJID: (jid) ->
    with_customer = new RegExp('([A-Za-z0-9]*)#([A-Za-z0-9]*)@(.*)$')
    without_customer = new RegExp('([A-Za-z0-9]*)@(.*)$')
    local_customer = new RegExp('([A-Za-z0-9]*)#([A-Za-z0-9]*)$')

    if with_customer.test(jid)
      return jid.split("#")[0]
    else if without_customer.test(jid)
      return jid.split("@")[0]
    else if local_customer.test(jid)
      return jid.split('#')[0]

    return jid

  toFixed: (num, decimal) =>
    return num.toFixed(decimal) if num?.toFixed?
    return num

  upper: (text) ->
    return text.toUpperCase()

  lower: (text) ->
    return text.toLowerCase()

  age: (dob) ->
    return moment().diff(moment(dob), 'years')

  metric: (metric) ->
    return "#{metric.value}#{metric.units}"

  weeksFrom: (date) ->
    return moment().diff(moment(date), 'weeks')

  statusIcon: (status) ->
    return Config.status[status].icon

  truncateString: (text, length) ->
    return text if text?.length <= length
    return $.trim(text).substring(0, length).split(" ").slice(0, -1).join(" ") + "..."

  foodLogServing: (serving_type, serving_per_container, servings) ->
    # food_detail = model.get('food_detail')
    # servings = model.get('servings')
    # return "#{food_detail.serving_per_container * servings} #{food_detail.serving_type}"
    return "#{serving_per_container * servings} #{serving_type}"

  checkedIfUserFoodFavorites: (food, favorites) ->
    return "checked" if _.indexOf(favorites, food.id) >= 0

  checkedIfUserExerciseFavorites: (exercise, favorites) ->
    return "checked" if _.indexOf(favorites, exercise.id) >= 0 or _.indexOf(favorites, exercise.get('exercise')) >= 0

  checkedIfUserExerciseFavoritesOnTodayList: (exercise, favorites) ->
    return "checked" if _.indexOf(favorites, exercise.get("exercise")) >= 0

  checkedIfUserFoodLogFavorites: (foodLog, favorites) ->
    return "checked" if _.indexOf(favorites, foodLog.get('food')) >= 0

  listCalories: (list) ->
    foods = new Backbone.Collection list.get('foods')
    calories = _.reduce foods.pluck('calories'), (memo, num) ->
      return memo + num
    , 0

    return "#{calories} Cal"
  mealTypeUpper: (meal_type) ->
    return meal_types[meal_type].toUpperCase()

  mealTypeLower: (meal_type) ->
    return meal_types[meal_type].toLowerCase()

  nutricionalFactPercent: (food, nut_faq) ->
    serving_per_container = food.get('serving_per_container')
    return food.get(nut_faq)

  bfYearOptions: (date, from, to) ->
    range = [from..to]
    html = ""
    for i in range
      temp = moment(date) if i == 0
      temp = moment(date).add('y', i) if i > 0
      temp = moment(date).subtract('y', i * -1) if i < 0

      html +="<div data-value='#{temp.year()}'>#{temp.year()}</div>"
    return html


  bfMonthOptions: () ->
    html = ""
    for i in [1..12]
      temp = moment("2000-#{i}-01", "YYYY-M-DD")
      html +="<div data-value='#{temp.format('MM')}'>#{temp.format('MMMM')}</div>"
    return html

  bfDayOptions: () ->
    html = ""
    for i in [1..31]
      temp = moment("2000-12-#{i}", "YYYY-MM-D")
      html +="<div data-value='#{temp.format('DD')}'>#{temp.format('DD')}</div>"
    return html

  uploadedFileUrl: (file) ->
    if file && file.rel
      return "/#{file.rel}"
    else
      ''

  getCalories: (exercises) ->
    calories = 0;
    exercises.forEach (exercise) ->
      if exercise.calories_burned != undefined
        calories = parseInt(calories) + parseInt(exercise.calories_burned)

    return calories

  getExerciseTypeDescription: (exerciseType) ->
    if (exerciseType == "1")
      return "Cardiovascular"
    else
      return "Strenght"

  getImageStatusUrl: (status)=>
    if status == "Great"
      return "img/status/great.png"
    if status == "Happy"
      return "img/status/happy.png"
    if status == "Chill"
      return "img/status/chill.png"
    if status == "Sick"
      return "img/status/sick.png"
    if status == "Bad"
      return "img/status/sad.png"
    if status == "Depress"
      return "img/status/depress.png"

  getCurrentDate:()=>
    monthNames = ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[moment().format('M')-1]


  convertMoodToNumber:(moodStr)->
    if moodStr == "Great"
      return 100
    else if moodStr == "Happy"
      return 80
    else if moodStr == "Chill"
      return 60
    else if moodStr == "Sick"
      return 40
    else if moodStr == "Bad"
      return 10
    else if moodStr == "Depress"
      return 10

  renderMood:(mood) ->
    that = @
    totalMood = 0
    mood.each (value)->
      totalMood = totalMood + Helpers.convertMoodToNumber(value.get("status"))
    totalMood = totalMood/mood.length

    return totalMood

  renderStressLv:(stressLv) ->
    return parseInt(100 - (stressLv * 10))

  getNutritionLvPerCalories:(nutritionLv,recommended)->
    percentaje = (nutritionLv * 100)/recommended
    if percentaje > 100
      return 200 - percentaje
    else
      return 100 - percentaje

  renderNutritionLv:(foodList) ->
    that = @
    nutritionLv = 0
    foodList.each (value)->
      nutritionLv = nutritionLv + value.get("calories")
    nutritionLv = nutritionLv/foodList.length

    return @getNutritionLvPerCalories(nutritionLv,app.me.get("calories_recomended"))

  #app.me.get("patientPreferences").activity
  getExcerciseRecommendationInMinutes:(activityStatus)->
    if activityStatus == "sedentary"
      return 30
    else if activityStatus == "light"
      return 45
    else if activityStatus == "active"
      return 60 * 1.5
    else if activityStatus == "very_active"
      return 60 * 2

  getFitnessLvPerTime:(fitnessLv,recommended)->
    percentaje = (fitnessLv * 100)/recommended
    if percentaje > 100
      return 100
    else
      return percentaje


  renderFitnessLv:(exerciseList) ->
    that = @
    fitnessLv = 0
    exerciseList.each (value)->
      fitnessLv = fitnessLv + value.get("time")
    fitnessLv = fitnessLv/exerciseList.length
    return @getFitnessLvPerTime(fitnessLv,app.me.get('time_recomended'))

  getWeatherIcon:(weather)->
    #weather = app.me.get("patientPreferences").weather
    if weather == "cold"
      return "icon-weather_cold"
    else if weather == "temperate"
      return "icon-weather_temperate"
    else if weather == "warm"
      return "icon-weather_warm"
    else if weather == "hot"
      return "icon-weather_hot"

  getWeatherMessage:(weather)->
    #weather = app.me.get("patientPreferences").weather
    if weather == "cold"
      return "Cold Weather"
    else if weather == "temperate"
      return "Temperate Weather"
    else if weather == "warm"
      return "Warm Weather"
    else if weather == "hot"
      return "Hot Weather"

  getActivityIcon:(activity)->
    #activity = app.me.get("patientPreferences").activity
    if activity == "sedentary"
      return "icon-activity_sedentary"
    else if activity == "light"
      return "icon-activity_light"
    else if activity == "active"
      return "icon-activity_active"
    else if activity == "very_active"
      return "icon-activity_very"

  getActivityMessage:(activity)->
    #activity = app.me.get("patientPreferences").activity
    if activity == "sedentary"
      return "Sedentary Lifestyle"
    else if activity == "light"
      return "Light Lifestyle"
    else if activity == "active"
      return "Active Lifestyle"
    else if activity == "very_active"
      return "Very Lifestyle"

  getWorkoutIcon:(workout)->
    switch workout
      when 15
        return "icon-workout_15"
      when 30
        return "icon-workout_30"
      when 45
        return "icon-workout_45"
      when 60
        return "icon-workout_60"
      else
        return "icon-workout_60"


  getGoalIcon:(goal)->
    #goal = app.me.get("patientPreferences").maintain
    if goal == "lose"
      return "icon-weight_lose"
    else if goal == "maintain"
      return "icon-weight_maintain"
    else if goal == "gain"
      return "icon-weight_gain"

  getGoalMessagePreference:(maintainGoal)->
    if maintainGoal == "lose"
      return "I WANT TO LOSE WEIGHT"
    else if maintainGoal == "maintain"
      return "I WANT TO MAINTAIN WEIGHT"
    else if maintainGoal == "gain"
      return "I WANT GAIN WEIGHT"

  getGoalMessage:(goal)->
    #goal = app.me.get("patientPreferences").maintain
    if goal == "lose"
      return "Lose Weight"
    else if goal == "maintain"
      return "Maintain Weight"
    else if goal == "gain"
      return "Gain Weight"

  getMaintainIcon:(maintain)->
    if maintain=="lose"
      return '<img src="img/weightgoal/losegoal.png" alt="" />'
    else if maintain=="maintain"
      return '<img src="img/weightgoal/maintaingoal.png" alt="" />'
    else if maintain=="gain"
      return '<img src="img/weightgoal/gaingoal.png" alt="" />'

  getWeightGoalIcon: (weight_goal) =>
    return "/img/goals/Weight-#{weight_goal}.png"

  getActivityGoalIcon: (activity) =>
    switch activity
      when 'very_active'
        return "/img/goals/Activity-veryactive.png"
      else
        return "/img/goals/Activity-#{activity}.png"

  getWorkoutGoalIcon: (workout) =>
    return "/img/goals/Workout-#{workout}.png"

  getWeatherGoalIcon: (weather) =>
    return "/img/goals/Weather-#{weather}.png"


  getBMIPerMonth:(progress,month)->
    bmi = 0
    count = 0
    progress.each (value,index)->
      if parseInt(moment(value.get("created")).format("M")) == month
        bmi = parseFloat(bmi) + parseFloat(value.get("bmi"))
        count++

      bmi = parseFloat(bmi / count)

    return bmi

  widgetSettingsChecked:(status)->
    if status
      return "checked"
    else
      return ""

  sortByIndex:(a,b)->
    sortStatus = 0
    if a.index < b.index
      sortStatus = -1
    else if a.index > b.index
      sortStatus = 1

    return sortStatus


  getColumns:(widgets_settings)->
    showOrder = []
    $.each widgets_settings, (i,value)->
      obj =
        index: value.index
        key: i
      
      showOrder.push(obj)

    showOrder.sort(@sortByIndex)
    html=""
    
    #for val in showOrder
    for i in [1..6]
      html = html+ "<th>" + Config.abbr.nutricional_facts[showOrder[i].key] + "</th>"

    return html

  renderColumns: (model,widgets_settings) ->
    showOrder = []
    $.each widgets_settings, (i, value) ->
      obj=
        index: value.index
        key: i
      showOrder.push(obj)

    showOrder.sort(@sortByIndex)
    html = ""

    #for val in showOrder
    for i in [1..6]
      html = html+ "<td>" + model.escape(showOrder[i].key) + "</td>"

    return html

  getPercentaje: (done, total) ->
    return parseFloat(100 * done)/parseFloat(total)

  renderNutrientsPercentajes:(patientPreferences, facts) ->
    widgets_settings = patientPreferences.get("widgets_settings")

    fitness_goals = patientPreferences.get("fitness_goals")

    showOrder = []
    $.each widgets_settings, (i, value)->
      obj =
        index: value.index
        key: i
        done: parseFloat(facts[i]).toFixed(1)
        percent: parseFloat(Helpers.getPercentaje(facts[i], fitness_goals[i])).toFixed(0)
        goal: fitness_goals[i].toFixed(1)
      
      showOrder.push(obj)

    showOrder.sort(@sortByIndex)

    html = ""
    
    for i in [1..6]
      html = html + '<li>' +
        '<p class="text-left">' + Config.abbr.nutricional_facts_name[showOrder[i].key] + ' <span>' + showOrder[i].done + Config.units.nutritional[showOrder[i].key] + '</span><span class="pull-right">' + showOrder[i].done + Config.units.nutritional[showOrder[i].key] + '/' + showOrder[i].goal + Config.units.nutritional['carbs'] + '</span></p>' +
        '<div class="progress">' +
        '  <div class="progress-bar progress-bar-macro-fact-' + i + '" role="progressbar" aria-valuetransitiongoal="' + showOrder[i].percent + '">' +
        '  </div>' +
        '</div>' +
        '</li>'

    return html

  convertGlassesToOunces:(glasses)->
    return (parseFloat(8.3) * parseFloat(glasses)).toFixed(0)

  renderNutrientsCharts:(widgets_settings)->

    showOrder = []
    $.each widgets_settings, (i,value)->
      obj=
        index:value.index
        value:value
      if value.checked
        showOrder.push(obj)

    showOrder.sort(@sortByIndex)
    limit=6
    html=""
    if showOrder.length<6
      limit=showOrder.length

    #for val in showOrder
    for i in [0..limit-1]
    #for val in showOrder
      if showOrder[i].value.description == "Carbs"
          html=html + '<div class="checkbox carb">
              <label>
                <span class="indicator2"></span>
                <input class="nutrition_tracker_stat" type="checkbox" value="carbs" checked="checked"> Carb
              </label>
            </div>'

      if showOrder[i].value.description == "Vitamin A"
        html=html + '<div class="checkbox vita">
              <label>
                <span class="indicator2"></span>
                <input class="nutrition_tracker_stat" type="checkbox" value="vitamin_a" checked="checked"> VitA
              </label>
            </div>'

      if showOrder[i].value.description == "Cholesterol"
          html=html + '<div class="checkbox chol">
            <label>
              <span class="indicator2"></span>
              <input class="nutrition_tracker_stat" type="checkbox" value="cholesterol" checked="checked"> Chol
            </label>
          </div>'

      if showOrder[i].value.description == "Protein"
          html= html + '<div class="checkbox prot">
            <label>
              <span class="indicator2"></span>
              <input class="nutrition_tracker_stat" type="checkbox" value="protein" checked="checked"> Prot
            </label>
          </div>'


      if showOrder[i].value.description == "Sodium"
            html=html + '<div class="checkbox sod">
              <label>
                <span class="indicator2"></span>
                <input class="nutrition_tracker_stat" type="checkbox" value="sodium" checked="checked"> Sod
              </label>
            </div>'
      if showOrder[i].value.description == "Potassium"
            html= html + '<div class="checkbox pot">
              <label>
                <span class="indicator2"></span>
                <input class="nutrition_tracker_stat" type="checkbox" value="potassium" checked="checked"> Pot
              </label>
            </div>'

      if showOrder[i].value.description == "Fat"
            html = html + '<div class="checkbox fat">
              <label>
                <span class="indicator2"></span>
                <input class="nutrition_tracker_stat" type="checkbox" value="fat" checked="checked"> Fat
              </label>
            </div>'

      if showOrder[i].value.description == "Calories"
            html=html + '<div class="checkbox cal">
              <label>
                <span class="indicator2"></span>
                <input class="nutrition_tracker_stat" type="checkbox" value="calories" checked="checked"> Cal
              </label>
            </div>'


    return html

  getUnitsPerMeassurement:(type, meassure)->
    if meassure == "metric"
      if type in ["longitud", "height"]
        return "cm"
      else if type=="mass"
        return "kg"
    else
      if type=="height"
        return ''
      if type=="longitud"
        return "inch"
      else if type=="mass"
        return "lb"

  getValuesPerMeassurement:(value, type, meassure) ->
    value = parseFloat(value)
    return 0 if isNaN(value)
    if value?.toFixed?
      value = value.toFixed(2)
    else
      value = 0

    if type == "height"
      if meassure == "imperial"
        return Helpers.renderHeightImperial(value)
      else
        return value

    if meassure == "metric"
      return value
    else
      if type=="longitud"
        heightFactor = 0.39370
        return parseFloat(value * heightFactor).toFixed(2)
      else if type=="mass"
        weightFactor = 2.204623
        return parseFloat(value * weightFactor).toFixed(2)

  getActivePlan:(plan)->
    getPlans = (trail, monthly, yearly) ->
      plans = {}
      plans[Config.stripe.plans.trial.id] = trail
      plans[Config.stripe.plans.monthly.id] = monthly
      plans[Config.stripe.plans.yearly.id] = yearly
      return plans

    states = getPlans()
    states[Config.stripe.plans.trial.id] = getPlans('active', 'enabled', 'enabled')
    states[Config.stripe.plans.monthly.id] = getPlans('expired', 'active', 'enabled')
    states[Config.stripe.plans.yearly.id] = getPlans('expired', 'expired', 'active')

    subscription = app.me.get('subscription')
    if app.me.get('subscription').plan == plan == Config.stripe.plans.trial.id
      if subscription.stripe_data.trial_end? or (not subscription.stripe_data.trial_end? and not subscription.stripe_data.trial_start?)
        trial_end = moment(subscription.stripe_data.trial_end * 1000)
        if trial_end.isBefore(moment())
          return 'expired'

    return states[app.me.get('subscription').plan][plan]

  getActivePlanBtnLabel: (plan) ->
    if app.me.get('subscription').plan == plan
      return "plan selected"
    else
      return "select plan"

  getActivePlanBtn:(userPlan,plan)->
    if userPlan == plan
      return "btn-primary"
    else
      return "btn-default"

  isLimitationSelect:(id,limits)->
    for value,index in limits
      if id == value
        return "checked"

  getExerciseTypeLabel: (exercise_type) ->
    if Config.exercises_types[exercise_type]?.label?
      return Config.exercises_types[exercise_type].label.toUpperCase()
    else
      return ''

  fixDecimals: (value, decimals) ->
    fixed = parseFloat(value).toFixed(decimals)
    return fixed

  colorful_language: (string) ->
    if string.length == 0
      return {hsl: 'hsl(0, 0, 100%)', hue: 0, saturation: '0%', lightness: '100%'}
    else
      sanitized = string.replace(/[^A-Za-z]/, '')
      letters = sanitized.split('')
      #Determine the hue
      hue = Math.floor((letters[0].toLowerCase().charCodeAt() - 96) / 26 * 360)
      ord = ''
      _.each letters, (char) ->
        return unless char.charCodeAt?
        ord = char.charCodeAt()
        if ord >= 65 and ord <= 90 or ord >= 97 and ord <= 122
          hue += ord - 64
      hue = hue % 360
      #Determine the saturation
      vowels = [
        'A'
        'a'
        'E'
        'e'
        'I'
        'i'
        'O'
        'o'
        'U'
        'u'
      ]
      count_cons = 0
      #Count the consonants
      for i of letters
        `i = i`
        if vowels.indexOf(letters[i]) == -1
          count_cons++
      #Determine what percentage of the string is consonants and weight to 95% being fully saturated.
      saturation = count_cons / letters.length / 0.95 * 100
      if saturation > 100
        saturation = 100
      #Determine the luminosity
      ascenders = [
        't'
        'd'
        'b'
        'l'
        'f'
        'h'
        'k'
      ]
      descenders = [
        'q'
        'y'
        'p'
        'g'
        'j'
      ]
      luminosity = 50
      increment = 1 / letters.length * 50
      for i of letters
        `i = i`
        if ascenders.indexOf(letters[i]) != -1
          luminosity += increment
        else if descenders.indexOf(letters[i]) != -1
          luminosity -= increment * 2
      if luminosity > 100
        luminosity = 100

      return {
        hsl: 'hsl(' + hue + ', ' + saturation + '%, ' + luminosity + '%);',
        hue: hue,
        saturation: "#{saturation}%",
        lightness: "#{luminosity}%"
      }

  checkDefaultCard: (card) ->
    default_card = app.me.get('default_credit_card')
    if default_card == card.get('id')
      return true
    return false

  getCardData: (card_id, field) ->
    cards = []
    if app.me.get('credit_cards')
      cards = app.me.get('credit_cards').data
    for card in cards
      if card.id == card_id
        return card[field]
    return ''

  getDefaultCreditCard: (format, ifEmpty) ->
    ## format: replace <card_property>
    ## ifEmpty: if no card text to show, if not set a default text will be returned
    default_card = app.me.get('default_credit_card')
    cards = []
    if app.me.get('credit_cards')
      cards = app.me.get('credit_cards').data
    if cards.length < 1
      return ifEmpty if ifEmpty
      return 'NO CARDS ON FILE'

    unless default_card
      default_card = cards[0].id

    card_index = _.findLastIndex cards, {id: default_card}
    if card_index?
      card = cards[card_index]

    replace = {}
    keys = format.match(/(<[a-z0-9]*>)/g)
    for key in keys
      field = key.replace(/[<>]/g, '')
      replace[key] = card[field]

    for key, value of replace
      format = format.replace(key, value)

    return format

  getCoupon: () ->
    return app.me.get('subscription').coupon || ''

  getPlanName: () ->
    plan = app.me.get('subscription').plan
    for key, value of Config.stripe.plans
      if value.id == plan
        return value.name
    return ''

  getCardBrandLogo: (brand) ->
    brands =
      "MasterCard": "img/card-1.png"
      "American Express": "img/card-2.png"
      "Visa": "img/card-3.png"
      "Discover": "img/card-3.png"
      "Diners Club": "img/card-3.png"
      "JCB": "img/card-3.png"

    return brands[brand] || brands['Visa']

  floatToFixed: (value, precision) ->
    precision = precision or 0
    power = 10 ** precision
    absValue = Math.abs(Math.round(value * power))
    result = (if value < 0 then '-' else '') + String(Math.floor(absValue / power))
    if precision > 0
      fraction = String(absValue % power)
      padding = new Array(Math.max(precision - (fraction.length), 0) + 1).join('0')
      result += '.' + padding + fraction
    result

  centsToDollar: (value) ->
    return "---" if isNaN(value)
    return  Helpers.floatToFixed value/100, 2

  getGoal: () ->
    return app.me.get('goals')?.text || ''

  getLifeStyle: () ->
    return app.me.escape('lifestyle') || ''

  timeToNow: (date, format) ->
    end = moment()
    start = moment(date)
    return start.fromNow()

  dateFormat: (date, format) ->
    unless format
      format = 'YYYY/MM/DD'
    return moment(date).format(format)

  getAppointmentReason: (model) ->
    messages = model.get('replies')
    first = _.first messages
    if first?
      return first.message
    else
      return ''

  getAppointmentStatusMessage: (status) ->
    status_msgs =
      'open': 'New consultation open'
      'answered': 'Answered'
      'waiting': 'Waiting for reply'
      'completed': 'Completed'

    if status_msgs[status]?
      return status_msgs[status]
    else
      return status

  getMeasureValueToStore: (value, type, system) ->
    return value if system == 'metric'

    switch type
      when 'mass'
        return value * 0.453592
      when 'longitud'
        return value * 0.0254
      else
        return false

  generateWaterTracker: (end, step = 250) ->
    $water_traker = $('<ul>')

    steps = Math.ceil(parseInt(end * 1000)/250)
    getStepHtml = (label) ->
      default_label = if label? then "#{(label/1000).toFixed(1)} Lt." else "&nbsp;"
      return "<li class='water-tracker-step' style='max-height:#{100/steps}%;height:#{100/steps}%;'><span></span><i>#{default_label}</i></li>"

    for i in [0..steps]
      unless (i * step) % 500 # if step multiplier of 500
        $step = getStepHtml(i * step)
      else
        $step = getStepHtml()
      $water_traker.prepend $step

    return $water_traker

  waterPercent: (end, glasses) ->
    ml = 250
    steps = Math.ceil(parseInt(end * 1000)/250)
    return ((100/steps) * glasses).toFixed(1)
    # return (ml * glasses/max) * 100

  getCaloriesPerDay: (activity, maintain, workout)->

    # patient preferences
    patientPreferences = app.me.get('patientPreferences')

    # get workout
    workout = patientPreferences.workout if !workout

    # factors
    factors = 
      sedentary_15: 1.2
      sedentary_30: 1.2
      sedentary_45: 1.2
      sedentary_60: 1.2
      light_15: 1.2
      light_30: 1.2
      light_45: 1.2
      light_60: 1.2
      active_15: 1.2
      active_30: 1.2
      active_45: 1.3
      active_60: 1.3
      very_active_15: 1.3
      very_active_30: 1.3
      very_active_45: 1.5
      very_active_60: 1.7

    #get gender coeficient
    genderCoeficient = 0
    ageCoeficient = 0
    if app.me.get("gender")=="M"
      genderCoeficient = 66.5
      ageCoeficient = 6.7
    else
      genderCoeficient = 665
      ageCoeficient = 4.6

    #get activity coeficient
    activityStatus = activity
    activityCoeficient = factors[activityStatus + '_' + workout]

    #Check if weigth is in cms.
    weight = 0
    if app.me.get("weight").units != "kg"
      weight = parseFloat(app.me.get("weight").value) * parseFloat(0.45359237)
    else
      weight = parseFloat(app.me.get("weight").value)

    #Get years.
    years = new moment().diff(app.me.get('dob'), 'years')

    #get height
    height=0
    if app.me.get("height").units != "cm"
      height = parseFloat(app.me.get("height").value) * parseFloat(2.54)
    else
      height = parseFloat(app.me.get("height").value)

    goal=0
    if patientPreferences.maintain == 'lose'
      goal = -300
    else if patientPreferences.maintain == 'gain'
      goal = 700
    else if patientPreferences.maintain == 'maintain'
      goal = 0

    if app.me.get("gender")=="M"
      calories = ((genderCoeficient + (12.7 * weight) + (5 * height) - (ageCoeficient * years)) * activityCoeficient) + goal
    else
      if app.me.get("pregnant") == "Yes"
        goal = 300

      if app.me.get("breastfeeding") == "Yes"
        goal = 300
        goal += 300 if app.me.get("pregnant") == "Yes"

      calories = ((genderCoeficient + (9.5 * weight) + (1.8 * height) - (ageCoeficient * years)) * activityCoeficient) + goal

    # change weight goal
    change_calories =
      lose_maintain: 150
      maintain_lose: -300
      lose_gain: 700
      gain_lose: -700
      maintain_gain: 700
      gain_maintain: -700
    if maintain and maintain != patientPreferences.maintain
      calories += change_calories[patientPreferences.maintain + '_' + maintain]

    caloriesRecommended = parseInt(calories)
    return caloriesRecommended

  getWaterGlasses: (water) =>
    glass = 250
    return (parseFloat(water) * 1000 /glass).toFixed(0)

  getFtIn: (value) =>
    value_inches = value * 0.3937008

    value_ft = value_inches/12

    fts = parseInt(value_ft)
    inch = parseInt ((value_ft % 1) * 12)
    return [fts, inch]

  getCmFromFtInch: (ft, inch) =>
    ft = if not isNaN(parseInt(ft)) then parseInt(ft) else 0
    inch = if not isNaN(parseInt(inch)) then parseInt(inch) else 0
    inchs = (ft * 12) + inch
    cm = inchs * 2.54
    return 0 if isNaN(cm)
    return cm

  generateImperalHeightSelect: (value, id, name) =>
    fts = [4, 5, 6]
    inchs = [0..11]
    steps = 1

    $select = $('<select>')
    $select.attr('id', id)
    $select.attr('name', name)
    $select.addClass('hidden')

    addOption = (value, text_ft, text_in, selected = false) =>
      $option = $('<option>')
      $option.attr('value', value)
      $option.html("#{text_ft}&rsquo;&nbsp;#{text_in}&rdquo;")
      $option.attr('selected', 'selected') if selected
      $select.append $option
      return

    [value_fts, value_in] = Helpers.getFtIn(value) if value?
    value_added = false
    for ft in fts
      for inch in inchs
        selected = false
        cms = Helpers.getCmFromFtInch(ft, inch)
        if not value_added and value_fts == ft and value_in == inch
          value_added = true
          selected = true

        addOption(cms, ft, inch, selected)

    return $select[0].outerHTML

  generateSlider: (element, onChange) =>
    element.selectToUISlider({
      labels: 5,
      labelSrc: 'text'
      sliderOptions:
        stop: onChange
		});

  renderHeightImperial: (value) =>
    if value?
      [value_fts, value_in] = Helpers.getFtIn(value)
      return "#{value_fts}'#{value_in}\""
    return ''

  getWaterConsumtion: (activity,weight,weather) =>
    waterConsume=0
    activityStatus = activity
    if activityStatus in ["sedentary", "light", "active"]
      if weather == "cold"
          waterConsume=(parseFloat(30 * weight))/1000
      else if weather == "temperate"
          waterConsume=(parseFloat(30 * weight))/1000
      else if weather == "warm"
          waterConsume=(parseFloat(35 * weight))/1000
      else if weather == "hot"
          waterConsume=(parseFloat(35 * weight))/1000

    else if activityStatus in ["very_active"]
      if weather == "cold"
          waterConsume=(parseFloat(35 * weight))/1000
      else if weather == "temperate"
          waterConsume=(parseFloat(35 * weight))/1000
      else if weather == "warm"
          waterConsume=(50 + parseFloat(35 * weight))/1000
      else if weather == "hot"
          waterConsume=(50 + parseFloat(35 * weight))/1000

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        waterConsume = 3
      if app.me.get('breastfeeding') == "Yes"
        waterConsume = 3.5

    return waterConsume

  getProteinRecommendation:(calories) ->
    maintain = app.me.get("patientPreferences").maintain

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        maintain = 'maintain'
      if app.me.get('breastfeeding') == "Yes"
        maintain = 'maintain'

    coefficients =
      'maintain': 20
      'lose': 20
      'gain': 22

    return parseFloat(((coefficients[maintain] * calories)/100)/4).toFixed(0)

  getCarbsRecommendation:(calories) ->
    maintain = app.me.get("patientPreferences").maintain

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        maintain = 'maintain'
      if app.me.get('breastfeeding') == "Yes"
        maintain = 'maintain'

    coefficients =
      'maintain': 60
      'lose': 55
      'gain': 56
    return parseFloat(((coefficients[maintain] * calories)/100)/4).toFixed(0)

  getFatRecommendation:(calories) ->
    maintain = app.me.get("patientPreferences").maintain

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        maintain = 'maintain'
      if app.me.get('breastfeeding') == "Yes"
        maintain = 'maintain'

    coefficients =
      'maintain': 20
      'lose': 25
      'gain': 22
    return parseFloat(((coefficients[maintain] * calories)/100)/9).toFixed(0)

  getVitaminARecommendation:() ->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      if years>=18 && years<=30
        return 900
      else if years>30 && years<=50
        return 900
      else if years>50 && years<=70
        return 900
      else if years>70
        return 900
    else
      if app.me.get("pregnant") == 'Yes'
        return 770
      if app.me.get("breastfeeding") == 'Yes'
        return 1300
      if years>=18 && years<=30
        return 700
      else if years>30 && years<=50
        return 700
      else if years>50 && years<=70
        return 700
      else if years>70
        return 700

  getVitaminCRecommendation:() ->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      #9–13 y 14–18 y 19–30 y 31–50 y 51–70 y > 70 y
      if years>=18 && years<=30
        return 90
      else if years>30 && years<=50
        return 90
      else if years>50 && years<=70
        return 90
      else if years>70
        return 90
    else
      #9–13 y 14–18 y 19–30 y 31–50 y 51–70 y > 70 y
      if app.me.get("pregnant") == 'Yes'
        return 75
      if app.me.get("breastfeeding") == 'Yes'
        return 120
      if years>=18 && years<=30
        return 75
      else if years>30 && years<=50
        return 75
      else if years>50 && years<=70
        return 75
      else if years>70
        return 75

  getIronRecommendation:()->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      #9–13 y 14–18 y 19–30 y 31–50 y 51–70 y > 70 y
      if years>=18 && years<=30
        return 8
      else if years>30 && years<=50
        return 8
      else if years>50 && years<=70
        return 8
      else if years>70
        return 8
    else
      if app.me.get("pregnant") == 'Yes'
        return 27
      if app.me.get("breastfeeding") == 'Yes'
        return 9
      if years>=18 && years<=30
        return 8
      else if years>30 && years<=50
        return 8
      else if years>50 && years<=70
        return 8
      else if years>70
        return 8

  getCalciumRecommendation:()->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      #9–13 y 14–18 y 19–30 y 31–50 y 51–70 y > 70 y
      if years>=18 && years<=30
        return 1000
      else if years>30 && years<=50
        return 1000
      else if years>50 && years<=70
        return 1000
      else if years>70
        return 1200
    else
      if app.me.get("pregnant") == 'Yes'
        return 1000
      if app.me.get("breastfeeding") == 'Yes'
        return 1000
      if years>=18 && years<=30
        return 1000
      else if years>30 && years<=50
        return 1000
      else if years>50 && years<=70
        return 1200
      else if years>70
        return 1200


  getPotassiumRecommendation:()->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      #9–13 y 14–18 y 19–30 y 31–50 y 51–70 y > 70 y
      if years>=18 && years<=30
        return 4700
      else if years>30 && years<=50
        return 4700
      else if years>50 && years<=70
        return 4700
      else if years>70
        return 4700
    else
      if app.me.get("pregnant") == 'Yes'
        return 4700
      if app.me.get("breastfeeding") == 'Yes'
        return 5100
      if years>=18 && years<=30
        return 4700
      else if years>30 && years<=50
        return 4700
      else if years>50 && years<=70
        return 4700
      else if years>70
        return 4700

  getSodiumRecommendation:()->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      #9–13 y 14–18 y 19–30 y 31–50 y 51–70 y > 70 y
      if years>=18 && years<=30
        return 1500
      else if years>30 && years<=50
        return 1500
      else if years>50 && years<=70
        return 1300
      else if years>70
        return 1200
    else
      if app.me.get("pregnant") == 'Yes'
        return 1500
      if app.me.get("breastfeeding") == 'Yes'
        return 1500
      if years>=18 && years<=30
        return 1500
      else if years>30 && years<=50
        return 1500
      else if years>50 && years<=70
        return 1300
      else if years>70
        return 1200

  getSugarRecommendation:()->
    if app.me.get("gender") == "M"
      return 36
    else
      return 25

  getFiberRecommendation:()->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      if years>50 && years<=70
        return 30
      else if years>70
        return 30
      else
        return 38
    else
      if app.me.get("pregnant") == 'Yes'
        return 28
      if app.me.get("breastfeeding") == 'Yes'
        return 29
      if years>50 && years<=70
        return 21
      else if years>70
        return 21
      else
        return 25

  getCholesterolRecommendation:()->
    years = moment().diff(moment(app.me.get("dob")), 'years')
    if app.me.get("gender") == "M"
      if years>50 && years<=70
        return 300
      else if years>70
        return 300
      else
        return 300
    else
      if app.me.get("pregnant") == 'Yes'
        return 300
      if app.me.get("breastfeeding") == 'Yes'
        return 300
      if years>50 && years<=70
        return 300
      else if years>70
        return 300
      else
        return 300

  getSaturatedRecommendation:(calories) ->
    maintain = app.me.get("patientPreferences").maintain

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        maintain = 'maintain'
      if app.me.get('breastfeeding') == "Yes"
        maintain = 'maintain'

    coefficients =
      'maintain': 6
      'lose': 8
      'gain': 8
    return parseFloat(((coefficients[maintain] * calories)/100)/9).toFixed(0)

  getPolyunsaturatedRecommendation:(calories) ->
    maintain = app.me.get("patientPreferences").maintain

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        maintain = 'maintain'
      if app.me.get('breastfeeding') == "Yes"
        maintain = 'maintain'

    coefficients =
      'maintain': 8
      'lose': 9
      'gain': 7
    return parseFloat(((coefficients[maintain] * calories)/100)/9).toFixed(0)

  getMonounsaturatedRecommendation:(calories) ->
    maintain = app.me.get("patientPreferences").maintain

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        maintain = 'maintain'
      if app.me.get('breastfeeding') == "Yes"
        maintain = 'maintain'

    coefficients =
      'maintain': 5
      'lose': 7
      'gain': 6
    return parseFloat(((coefficients[maintain] * calories)/100)/9).toFixed(0)

  getTransRecommendation:(calories) ->
    maintain = app.me.get("patientPreferences").maintain

    if app.me.get('gender') == 'F'
      if app.me.get('pregnant') == "Yes"
        maintain = 'maintain'
      if app.me.get('breastfeeding') == "Yes"
        maintain = 'maintain'

    coefficients =
      'maintain': 1
      'lose': 1
      'gain': 1
    return parseFloat(((coefficients[maintain] * calories)/100)/9).toFixed(0)

  getAppointmentID: (appointment) ->
    return appointment.id.substr(0,11)

  getAppointmentReason: (appointment) ->
    messages = appointment.get('replies')
    return messages[0].message
}

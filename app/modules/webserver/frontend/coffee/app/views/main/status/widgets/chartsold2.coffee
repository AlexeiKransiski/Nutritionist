class App.Views.Main.Status.Widgets.Charts22 extends Null.Views.Base 
  template: JST['app/main/status/widgets/charts2.html']

  @progressTracker
  @nutritionTracker
  @exerciseTracker
  @nutcompareTracker
  @progress_tracker_data
  @nutrition_tracker_data
  @exercise_tracker_data
  @ctx
  @ctx2
  @options

  events:
    'click .progress_tracker_stat': 'reloadChart'
    'click .nutrition_tracker_stat': 'reloadNutritionChart'
    'change #selectFilter': 'searchByFilter'
    'change #selectFilterLeft': 'searchByFilterLeft'
    'change #selectFilterMeassure': 'searchByFilter'
    
    

  initialize: ->
    super
    #@exercisePreference = app.me.get("exercise_preference") 
    
    @progress_tracker_datasets = {
        datasets: []
    }; 

    @progressCollection = new App.Collections.Progress()
    @searchBodyYear()

    @foodLog = new App.Collections.FoodLog()

    @foodCompareLog = new App.Collections.FoodLog()

    @exerciseLog = new App.Collections.ExerciseLog()
    @searchExerciseCompare()

    @listenTo @progressCollection, 'reset', @renderProgressChart
    @listenTo @foodLog, 'reset', @renderNutritionChart
    @listenTo @foodCompareLog, 'reset', @renderCompareNutritionChart
    @listenTo @exerciseLog, 'reset', @renderCompareExerciseChart
          

  searchByFilterLeft: ->
    selectFilterLeft = $("#selectFilterLeft").val()
    if selectFilterLeft == "1"
      @searchExerciseCompare()
    else      
      @searchNutritionCompare() 



  searchByFilter: ->
    console.log "Filtro de combos"
    selectOption = $("#selectFilter").val()
    selectMeassureOption = $("#selectFilterMeassure").val()
    
    #Compare charts.
    searchByFilterLeft = $("#searchByFilterLeft").val()

    if searchByFilterLeft == "1"
      @searchExerciseCompare()
    else
      @searchNutritionCompare()
        
    #Progress chart.
    if selectOption == "year"

      if selectMeassureOption == "1"
        $("#body").show()
        $("#nutrition").hide() 
        @searchBodyYear()
      else
        $("#body").hide()
        $("#nutrition").show() 
        @searchNutritionYear()
    
    else

      if selectMeassureOption == "1"
        $("#body").show()
        $("#nutrition").hide()
        @searchBodyMonth()
      else
        $("#body").hide()
        $("#nutrition").show()
        @searchNutritionMonth() 


  searchNutritionCompare:()->
    @foodCompareLog.fetch  
      data:
        created: 
          $gte: moment(parseInt(moment().year() - 1) + "-01-01","YYYY-MM-DD").toISOString(),
          $lt: moment(moment().year() + "-12-31", "YYYY-MM-DD").toISOString()

        user: app.me.id 
      reset: true           


  searchExerciseCompare:()->
    @exerciseLog.fetch 
      data:
        exercise_date: 
          $gte: moment(parseInt(moment().year() - 1) + "-01-01","YYYY-MM-DD").toISOString(),
          $lt: moment(moment().year() + "-12-31", "YYYY-MM-DD").toISOString()

        user: app.me.id 
      reset: true           

  searchBodyYear:()->
    @progressCollection.fetch 
      data:
        created: 
          $gte: moment(moment().year() + "-01-01","YYYY-MM-DD").toISOString(),
          $lt: moment(moment().year() + "-12-31", "YYYY-MM-DD").toISOString()

        user: app.me.id 
      reset: true
  
  searchBodyMonth:()->
    month = moment().format('M')
    day = moment().endOf('month').format('D')
    @progressCollection.fetch
      data: 
        created: 
          $gte: moment(moment().year() + "-" + month + "-01 00:00","YYYY-MM-DD").toISOString(),
          $lt: moment(moment().year() + "-" + month + "-" + day ,"YYYY-MM-DD").toISOString()

        user: app.me.id 
      reset: true    

  searchNutritionYear:()->
    @foodLog.fetch
      data:
        created: 
          $gte: moment(moment().year() + "-01-01","YYYY-MM-DD").toISOString(),
          $lt: moment(moment().year() + "-12-31", "YYYY-MM-DD").toISOString()

          #$gte: moment(moment().year() + "-01-01 00:00","YYYY-MM-DD HH:mm").toISOString(),
          #$lt: moment(moment().year() + "-12-31 23:59", "YYYY-MM-DD HH:mm").toISOString()

        user: app.me.id 
      reset: true
  
  searchNutritionMonth:()->
    month = moment().format('M')
    day = moment().endOf('month').format('D')
    @foodLog.fetch
      data: 
        created: 
          $gte: moment(moment().year() + "-" + month + "-01 00:00","YYYY-MM-DD").toISOString(),
          $lt: moment(moment().year() + "-" + month + "-" + day ,"YYYY-MM-DD").toISOString()

        user: app.me.id 
      reset: true    

  render: ->
    super
    @


  reloadNutritionChart:(event)->
    @nutrition_tracker_data.datasets = [];
    console.log("Inspeccionara aqui")
    
    if $('#formChecks2').find('input:checked').length > 0

      $('#formChecks2').find('input:checked').each (index, element) =>
        if @nutrition_tracker_datasets.datasets[element.value] != undefined
          @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[element.value]);
    
    else
      console.log "event.currentTarget"
      console.log event.currentTarget
      event.target.checked=true


    if @nutrition_tracker_data.datasets.length
      @ctx.clearRect(0, 0, @ctx.width, @ctx.height);
      @nutritionTracker = new Chart(@ctx).Line(@nutrition_tracker_data, @options);
  
  reloadChart: (event)->
    @progress_tracker_data.datasets = [];
    console.log("Inspeccionara aqui")
    
    if $('#formChecks').find('input:checked').length > 0

      $('#formChecks').find('input:checked').each (index, element) =>
        if @progress_tracker_datasets.datasets[element.value] != undefined
          @progress_tracker_data.datasets.push(@progress_tracker_datasets.datasets[element.value]);
    
    else
      console.log "event.currentTarget"
      console.log event.currentTarget
      event.target.checked=true


    if @progress_tracker_data.datasets.length 
      @ctx.clearRect(0, 0, @ctx.width, @ctx.height);
      @progressTracker = new Chart(@ctx).Line(@progress_tracker_data, @options);
    

  getMonthByIndex:(index) ->
      if index + 1 == 1
        return "JAN"
      if index + 1 == 2
        return "FEB"
      if index + 1 == 3
        return "MAR"          
      if index + 1 == 4
        return "APR" 
      if index + 1 == 5
        return "MAY"            
      if index + 1 == 6
        return "JUN"
      if index + 1 == 7
        return "JUL"   
      if index + 1 == 8
        return "AUG"                
      if index + 1 == 9
        return "SEP"  
      if index + 1 == 10
        return "AUG"   
      if index + 1 == 11
        return "NOV"    
      if index + 1 == 12
        return "DEC"                          

  renderCompareNutritionChart:()->
    @options = {
      scaleShowGridLines : true,
      scaleGridLineColor : "rgba(0,0,0,.05)",
      scaleGridLineWidth : 1,
      scaleShowHorizontalLines: true,
      scaleShowVerticalLines: true,
      bezierCurve : true,
      bezierCurveTension : 0.4,
      pointDot : true,
      pointDotRadius : 4,
      pointDotStrokeWidth : 1,
      pointHitDetectionRadius : 20,
      datasetStroke : true,
      datasetStrokeWidth : 2,
      datasetFill : true,
      animation : false,
      scaleStepWidth:300
    };


    Chart.defaults.global.responsive = true;
    Chart.defaults.global.scaleOverride = true;
    Chart.defaults.global.scaleSteps = 3;
    #Chart.defaults.global.scaleStepWidth = 50;
    Chart.defaults.global.scaleStartValue = 0;
    Chart.defaults.global.scaleShowLabels = true;
    Chart.defaults.global.scaleFontSize = 10;

    @nutcompare_tracker_datasets = {
      datasets: []
    }
 
    @nutcompare_tracker_data = {
      labels: [],
      datasets: []
    };

    currentYearSerie = 
      label: "2015",
      fillColor: "rgba(78,145,217,0.4)",
      strokeColor: "rgba(115,164,216,1)",
      pointColor: "rgba(115,164,216,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(115,164,216,1)",
      pointHighlightStroke: "#fff",
      data: []  

    lastYearSerie = 
      label: "2014",
      fillColor: "rgba(166,207,251,0.4)",
      strokeColor: "rgba(217,226,236,1)",
      pointColor: "rgba(183,200,219,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(183,200,219,1)",
      pointHighlightStroke: "#fff",
      data: []    

    currentMonthSerie = 
      label: "2015",
      fillColor: "rgba(78,145,217,0.4)",
      strokeColor: "rgba(115,164,216,1)",
      pointColor: "rgba(115,164,216,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(115,164,216,1)",
      pointHighlightStroke: "#fff",
      data: []  

    lastMonthSerie = 
      label: "2014",
      fillColor: "rgba(166,207,251,0.4)",
      strokeColor: "rgba(217,226,236,1)",
      pointColor: "rgba(183,200,219,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(183,200,219,1)",
      pointHighlightStroke: "#fff",
      data: []      

    selectOption = $("#selectFilter").val()
    if selectOption == "year"
        monthCurrentYearValues = []
        monthCurrentYearValues[0] = []
        monthCurrentYearValues[1] = []
        monthCurrentYearValues[2] = []
        monthCurrentYearValues[3] = []            
        monthCurrentYearValues[4] = []      
        monthCurrentYearValues[5] = []
        monthCurrentYearValues[6] = []
        monthCurrentYearValues[7] = []
        monthCurrentYearValues[8] = []
        monthCurrentYearValues[9] = []
        monthCurrentYearValues[10] = []
        monthCurrentYearValues[11] = []

        monthLastYearValues = []
        monthLastYearValues[0] = []
        monthLastYearValues[1] = []
        monthLastYearValues[2] = []
        monthLastYearValues[3] = []            
        monthLastYearValues[4] = []      
        monthLastYearValues[5] = []
        monthLastYearValues[6] = []
        monthLastYearValues[7] = []
        monthLastYearValues[8] = []
        monthLastYearValues[9] = []
        monthLastYearValues[10] = []
        monthLastYearValues[11] = []

        currentYear = moment().year()
        console.log "@foodCompareLog"
        console.log @foodCompareLog
        @foodCompareLog.each (model)->  
          if parseInt(moment(model.get("created"),"YYYY-MM-DD").format('YYYY')) == currentYear

            month = moment(model.get("created"),"YYYY-MM-DD").format('M')
            data =
              day:moment(model.get("created"),"YYYY-MM-DD").format('D')
              food:model
            
            monthCurrentYearValues[month-1].push(data)
              
          else
            
            month = moment(model.get("created"),"YYYY-MM-DD").format('M')
            data =
              day:moment(model.get("created"),"YYYY-MM-DD").format('D')
              food:model
            
            monthLastYearValues[month-1].push(data)

        console.log "monthCurrentYearValues"
        console.log monthCurrentYearValues
        console.log "monthLastYearValues"
        console.log monthLastYearValues

        console.log "monthCurrentYearValues"
        for monthData,index in monthCurrentYearValues
           console.log monthData
           caloriesConsumed = 0
           for foods,index2 in monthData
              caloriesConsumed = parseInt(caloriesConsumed) + parseInt(foods.food.get("calories"))
           
           currentYearSerie.data.push(caloriesConsumed)
           @nutcompare_tracker_data.labels.push(@getMonthByIndex(index))

        @nutcompare_tracker_datasets.datasets.push(currentYearSerie)


        console.log "monthLastYearValues"
        for monthData,index in monthLastYearValues
           console.log monthData
           caloriesConsumed = 0
           for foods,index2 in monthData
              caloriesConsumed = parseInt(caloriesConsumed) + parseInt(foods.food.get("calories"))
           
           lastYearSerie.data.push(caloriesConsumed)

        @nutcompare_tracker_datasets.datasets.push(lastYearSerie)


        @nutcompare_tracker_data.datasets=[
          @nutcompare_tracker_datasets.datasets[0],
          @nutcompare_tracker_datasets.datasets[1]
        ] 

    else
      that = @  
      count = 0;
      currentMonth = parseInt(moment().month() + 1)
      currentYear = moment().year()

      daysMonthCurrentYear = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonthCurrentYear
        daysMonthCurrentYear[i] = []


      daysMonthLastYear = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonthLastYear
        daysMonthLastYear[i] = []


      @foodCompareLog.each (model,index)-> 
        console.log "Dias"
        console.log model
        if parseInt(moment(model.get("created"),"YYYY-MM-DD").format('YYYY')) == currentYear
          if parseInt(moment(model.get("created"),"YYYY-MM-DD").format('M')) == currentMonth
            day = moment(model.get("created"),"YYYY-MM-DD").format('D')
            daysMonthCurrentYear[day-1].push(model)
          if parseInt(moment(model.get("created"),"YYYY-MM-DD").format('M')) == parseInt(currentMonth - 1)
            day = moment(model.get("created"),"YYYY-MM-DD").format('D')
            daysMonthLastYear[day-1].push(model)

      console.log "daysMonthCurrentYear"
      console.log daysMonthCurrentYear
      console.log "daysMonthLastYear"
      console.log daysMonthLastYear

      #Here we split the array in 4.
      weekOne = []
      weekTwo = []
      weekThree = []
      weekFour = []

      for dayMonthGroup,index in daysMonthCurrentYear
        if index < 7
          weekOne.push(dayMonthGroup)
        if index > 7 && index < 14
          weekTwo.push(dayMonthGroup)
        if index > 14 && index < 21
          weekThree.push(dayMonthGroup)
        if index > 21 && index < 31
          weekFour.push(dayMonthGroup)

      caloriesConsumedDay = 0
      for one,index in weekOne
        for dayModel in one
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
      
      currentMonthSerie.data.push(caloriesConsumedDay)

      caloriesConsumedDay = 0
      for two,index in weekTwo
        for dayModel in two
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
      
      currentMonthSerie.data.push(caloriesConsumedDay)
      
      caloriesConsumedDay = 0
      for three,index in weekThree
        for dayModel in three
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
      
      currentMonthSerie.data.push(caloriesConsumedDay)

      caloriesConsumedDay = 0
      for four,index in weekFour
        for dayModel in four
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
      
      currentMonthSerie.data.push(caloriesConsumedDay)  


      @nutcompare_tracker_datasets.datasets.push(currentMonthSerie)

      weekLastYearOne = []
      weekLastYearTwo = []
      weekLastYearThree = []
      weekLastYearFour = []

      for dayMonthGroup,index in daysMonthLastYear
        if index < 7
          weekLastYearOne.push(dayMonthGroup)
        if index > 7 && index < 14
          weekLastYearTwo.push(dayMonthGroup)
        if index > 14 && index < 21
          weekLastYearThree.push(dayMonthGroup)
        if index > 21 && index < 31
          weekLastYearFour.push(dayMonthGroup)

      caloriesConsumedDay = 0
      for one,index in weekLastYearOne
        
        for dayModel in one
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
      
      lastMonthSerie.data.push(caloriesConsumedDay)

      caloriesConsumedDay = 0
      for two,index in weekLastYearTwo
        for dayModel in two
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
      
      lastMonthSerie.data.push(caloriesConsumedDay)

      caloriesConsumedDay = 0
      for three,index in weekLastYearThree
        for dayModel in three
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
      
      lastMonthSerie.data.push(caloriesConsumedDay)

      caloriesConsumedDay = 0
      for four,index in weekLastYearFour
        for dayModel in four
          caloriesConsumedDay = parseInt(caloriesConsumedDay) + parseInt(dayModel.get("calories"))
        
      lastMonthSerie.data.push(caloriesConsumedDay)  


      @nutcompare_tracker_datasets.datasets.push(lastMonthSerie)

      @nutcompare_tracker_data.labels = ["Week 1","Week 2","Week 3","Week 4"]
      @nutcompare_tracker_data.datasets=[
        @nutcompare_tracker_datasets.datasets[0],
        @nutcompare_tracker_datasets.datasets[1]
      ]   


    $("#compareStatus").empty()
    $("#compareStatus").append('<canvas id="statusByYear" width="280" height="200"></canvas>')
    @ctx2 = $("#statusByYear").get(0).getContext("2d");  
    @ctx2.clearRect(0, 0, @ctx2.width, @ctx2.height);
    @nutcompareTracker = new Chart(@ctx2).Line(@nutcompare_tracker_data, @options);       

  renderCompareExerciseChart:()->

    @options = {
      scaleShowGridLines : true,
      scaleGridLineColor : "rgba(0,0,0,.05)",
      scaleGridLineWidth : 1,
      scaleShowHorizontalLines: true,
      scaleShowVerticalLines: true,
      bezierCurve : true,
      bezierCurveTension : 0.4,
      pointDot : true,
      pointDotRadius : 4,
      pointDotStrokeWidth : 1,
      pointHitDetectionRadius : 20,
      datasetStroke : true,
      datasetStrokeWidth : 2,
      datasetFill : true,
      animation : false,
      scaleStepWidth:300
    };


    Chart.defaults.global.responsive = true;
    Chart.defaults.global.scaleOverride = true;
    Chart.defaults.global.scaleSteps = 3;
    #Chart.defaults.global.scaleStepWidth = 50;
    Chart.defaults.global.scaleStartValue = 0;
    Chart.defaults.global.scaleShowLabels = true;
    Chart.defaults.global.scaleFontSize = 10;

    @exercise_tracker_datasets = {
      datasets: []
    }
 
    @exercise_tracker_data = {
      labels: [],
      datasets: []
    };

    currentYearSerie = 
      label: "2015",
      fillColor: "rgba(78,145,217,0.4)",
      strokeColor: "rgba(115,164,216,1)",
      pointColor: "rgba(115,164,216,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(115,164,216,1)",
      pointHighlightStroke: "#fff",
      data: []  

    lastYearSerie = 
      label: "2014",
      fillColor: "rgba(166,207,251,0.4)",
      strokeColor: "rgba(217,226,236,1)",
      pointColor: "rgba(183,200,219,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(183,200,219,1)",
      pointHighlightStroke: "#fff",
      data: []    


    currentMonthSerie = 
      label: "2015",
      fillColor: "rgba(78,145,217,0.4)",
      strokeColor: "rgba(115,164,216,1)",
      pointColor: "rgba(115,164,216,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(115,164,216,1)",
      pointHighlightStroke: "#fff",
      data: []  

    lastMonthSerie = 
      label: "2014",
      fillColor: "rgba(166,207,251,0.4)",
      strokeColor: "rgba(217,226,236,1)",
      pointColor: "rgba(183,200,219,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(183,200,219,1)",
      pointHighlightStroke: "#fff",
      data: []    


    selectOption = $("#selectFilter").val()
    if selectOption == "year"

        monthCurrentYearValues = []
        monthCurrentYearValues[0] = []
        monthCurrentYearValues[1] = []
        monthCurrentYearValues[2] = []
        monthCurrentYearValues[3] = []            
        monthCurrentYearValues[4] = []      
        monthCurrentYearValues[5] = []
        monthCurrentYearValues[6] = []
        monthCurrentYearValues[7] = []
        monthCurrentYearValues[8] = []
        monthCurrentYearValues[9] = []
        monthCurrentYearValues[10] = []
        monthCurrentYearValues[11] = []

        monthLastYearValues = []
        monthLastYearValues[0] = []
        monthLastYearValues[1] = []
        monthLastYearValues[2] = []
        monthLastYearValues[3] = []            
        monthLastYearValues[4] = []      
        monthLastYearValues[5] = []
        monthLastYearValues[6] = []
        monthLastYearValues[7] = []
        monthLastYearValues[8] = []
        monthLastYearValues[9] = []
        monthLastYearValues[10] = []
        monthLastYearValues[11] = []

        currentYear = moment().year()
        @exerciseLog.each (model)->  
          if parseInt(moment(model.get("exercise_date"),"YYYY-MM-DD").format('YYYY')) == currentYear

            month = moment(model.get("exercise_date"),"YYYY-MM-DD").format('M')
            data =
              day:moment(model.get("exercise_date"),"YYYY-MM-DD").format('D')
              exercise:model
            
            monthCurrentYearValues[month-1].push(data)
              
          else
            
            month = moment(model.get("exercise_date"),"YYYY-MM-DD").format('M')
            data =
              day:moment(model.get("exercise_date"),"YYYY-MM-DD").format('D')
              exercise:model
            
            monthLastYearValues[month-1].push(data)

        console.log "monthCurrentYearValues"
        for monthData,index in monthCurrentYearValues
           console.log monthData
           caloriesBurned = 0
           for exercise,index2 in monthData
              caloriesBurned = parseInt(caloriesBurned) + parseInt(exercise.exercise.get("calories_burned"))
           
           currentYearSerie.data.push(caloriesBurned)
           @exercise_tracker_data.labels.push(@getMonthByIndex(index))

        @exercise_tracker_datasets.datasets.push(currentYearSerie)


         

        console.log "monthLastYearValues"
        for monthData,index in monthLastYearValues
           console.log monthData
           caloriesBurned = 0
           for exercise,index2 in monthData
              caloriesBurned = parseInt(caloriesBurned) + parseInt(exercise.exercise.get("calories_burned"))
           
           lastYearSerie.data.push(caloriesBurned)

        @exercise_tracker_datasets.datasets.push(lastYearSerie)

        @exercise_tracker_data.datasets=[
          @exercise_tracker_datasets.datasets[0],
          @exercise_tracker_datasets.datasets[1]
        ] 
      
    else

      that = @  
      count = 0;
      currentMonth = parseInt(moment().month() + 1)
      currentYear = moment().year()

      daysMonthCurrentYear = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonthCurrentYear
        daysMonthCurrentYear[i] = []


      daysMonthLastYear = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonthLastYear
        daysMonthLastYear[i] = []

      @exerciseLog.each (model,index)-> 
        console.log "Dias"
        console.log model
        if parseInt(moment(model.get("exercise_date"),"YYYY-MM-DD").format('YYYY')) == currentYear
          if parseInt(moment(model.get("exercise_date"),"YYYY-MM-DD").format('M')) == currentMonth
            day = moment(model.get("exercise_date"),"YYYY-MM-DD").format('D')
            daysMonthCurrentYear[day-1].push(model)
          if parseInt(moment(model.get("exercise_date"),"YYYY-MM-DD").format('M')) == parseInt(currentMonth - 1)
            day = moment(model.get("exercise_date"),"YYYY-MM-DD").format('D')
            daysMonthLastYear[day-1].push(model)

      console.log "daysMonthCurrentYear"
      console.log daysMonthCurrentYear
      console.log "daysMonthLastYear"
      console.log daysMonthLastYear

      #Here we split the array in 4.
      weekOne = []
      weekTwo = []
      weekThree = []
      weekFour = []

      for dayMonthGroup,index in daysMonthCurrentYear
        if index < 7
          weekOne.push(dayMonthGroup)
        if index > 7 && index < 14
          weekTwo.push(dayMonthGroup)
        if index > 14 && index < 21
          weekThree.push(dayMonthGroup)
        if index > 21 && index < 31
          weekFour.push(dayMonthGroup)

      caloriesBurnedDay = 0
      for one,index in weekOne
        for dayModel in one
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      currentMonthSerie.data.push(caloriesBurnedDay)

      caloriesBurnedDay = 0
      for two,index in weekTwo
        for dayModel in two
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      currentMonthSerie.data.push(caloriesBurnedDay)
      
      caloriesBurnedDay = 0
      for three,index in weekThree
        for dayModel in three
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      currentMonthSerie.data.push(caloriesBurnedDay)

      caloriesBurnedDay = 0
      for four,index in weekFour
        for dayModel in four
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      currentMonthSerie.data.push(caloriesBurnedDay)  


      @exercise_tracker_datasets.datasets.push(currentMonthSerie)


      weekLastYearOne = []
      weekLastYearTwo = []
      weekLastYearThree = []
      weekLastYearFour = []

      for dayMonthGroup,index in daysMonthLastYear
        if index < 7
          weekLastYearOne.push(dayMonthGroup)
        if index > 7 && index < 14
          weekLastYearTwo.push(dayMonthGroup)
        if index > 14 && index < 21
          weekLastYearThree.push(dayMonthGroup)
        if index > 21 && index < 31
          weekLastYearFour.push(dayMonthGroup)

      caloriesBurnedDay = 0
      for one,index in weekLastYearOne
        
        for dayModel in one
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      lastMonthSerie.data.push(caloriesBurnedDay)

      caloriesBurnedDay = 0
      for two,index in weekLastYearTwo
        for dayModel in two
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      lastMonthSerie.data.push(caloriesBurnedDay)

      caloriesBurnedDay = 0
      for three,index in weekLastYearThree
        for dayModel in three
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      lastMonthSerie.data.push(caloriesBurnedDay)

      caloriesBurnedDay = 0
      for four,index in weekLastYearFour
        for dayModel in four
          caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
        
      lastMonthSerie.data.push(caloriesBurnedDay)  


      @exercise_tracker_datasets.datasets.push(lastMonthSerie)

      @exercise_tracker_data.labels = ["Week 1","Week 2","Week 3","Week 4"]
      @exercise_tracker_data.datasets=[
        @exercise_tracker_datasets.datasets[0],
        @exercise_tracker_datasets.datasets[1]
      ]   

      #for dayMonthGroup,index in daysMonthCurrentYear
      #  caloriesBurnedDay = 0
      #  for dayModel in dayMonthGroup
      #    caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      #  currentMonthSerie.data.push(caloriesBurnedDay)
      #  #@exercise_tracker_data.labels.push("Day " + parseInt(index + 1)) 
     
      #for dayMonthGroup,index in daysMonthLastYear
      #  caloriesBurnedDay = 0
      #  for dayModel in dayMonthGroup
      #    caloriesBurnedDay = parseInt(caloriesBurnedDay) + parseInt(dayModel.get("calories_burned"))
      
      #  lastMonthSerie.data.push(caloriesBurnedDay)
      #  #@exercise_tracker_data.labels.push("Day " + parseInt(index + 1))

      #@exercise_tracker_datasets.datasets.push(currentMonthSerie)
      #@exercise_tracker_datasets.datasets.push(lastMonthSerie)

      #@exercise_tracker_data.labels = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
      #@exercise_tracker_data.datasets=[
      #  @exercise_tracker_datasets.datasets[0],
      #  @exercise_tracker_datasets.datasets[1]
      #]   


    $("#compareStatus").empty()
    $("#compareStatus").append('<canvas id="statusByYear" width="280" height="200"></canvas>')
    @ctx2 = $("#statusByYear").get(0).getContext("2d");  
    @ctx2.clearRect(0, 0, @ctx2.width, @ctx2.height);
    @exerciseTracker = new Chart(@ctx2).Line(@exercise_tracker_data, @options); 

  renderNutritionChart: ->
    console.log "renderNutritionChart"
    @options = {
      scaleShowGridLines : true,
      scaleGridLineColor : "rgba(0,0,0,.05)",
      scaleGridLineWidth : 1,
      scaleShowHorizontalLines: true,
      scaleShowVerticalLines: true,
      bezierCurve : true,
      bezierCurveTension : 0.4,
      pointDot : true,
      pointDotRadius : 4,
      pointDotStrokeWidth : 1,
      pointHitDetectionRadius : 20,
      datasetStroke : true,
      datasetStrokeWidth : 2,
      datasetFill : true,
      animation : false,
    };


    Chart.defaults.global.responsive = false;
    Chart.defaults.global.scaleOverride = true;
    Chart.defaults.global.scaleSteps = 3;
    Chart.defaults.global.scaleStepWidth = 50;
    Chart.defaults.global.scaleStartValue = 0;
    Chart.defaults.global.scaleShowLabels = true;
    Chart.defaults.global.scaleFontSize = 10;

    @nutrition_tracker_datasets = {
      datasets: []
    }
 

    @nutrition_tracker_data = {
      labels: [],
      datasets: []
    };

    #Neck #FFA700
    carbSerie = 
      label: "Carb",
      fillColor: "rgba(255,167,0,0.4)",
      strokeColor: "rgba(255,167,0,1)",
      pointColor: "rgba(255,167,0,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(255,167,0,1)",
      pointHighlightStroke: "#fff",
      data: []  

    #34f580
    fatSerie =
      label: "Fat",
      fillColor: "rgba(52,245,128,0.4)",
      strokeColor: "rgba(52,245,128,1)",
      pointColor: "rgba(52,245,128,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(52,245,128,1)",
      pointHighlightStroke: "#fff",
      data: []    

    #42d54a  
    cholSerie =
      label: "Chol",
      fillColor: "rgba(66,213,74,0.4)",
      strokeColor: "rgba(66,213,74,1)",
      pointColor: "rgba(66,213,74,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(66,213,74,1)",
      pointHighlightStroke: "#fff",
      data: []       

    #00a559  
    sodSerie =
      label: "Sod",
      fillColor: "rgba(0,165,89,0.4)",
      strokeColor: "rgba(0,165,89,1)",
      pointColor: "rgba(0,165,89,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(0,165,89,1)",
      pointHighlightStroke: "#fff",
      data: []

    #4cc3d6
    potSerie =
      label: "Pot",
      fillColor: "rgba(76,195,214,0.4)",
      strokeColor: "rgba(76,195,214,1)",
      pointColor: "rgba(76,195,214,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(76,195,214,1)",
      pointHighlightStroke: "#fff",
      data: []           

    #3e96ef  
    calSerie =
      label: "Cal",
      fillColor: "rgba(62,150,239,0.4)",
      strokeColor: "rgba(62,150,239,1)",
      pointColor: "rgba(62,150,239,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(62,150,239,1)",
      pointHighlightStroke: "#fff",
      data: []

    selectOption = $("#selectFilter").val()
    if selectOption == "year"
      
      carb=0
      fat=0
      chol=0
      sod=0
      pot=0
      cal=0

      monthValues = []
      monthValues[0] = []
      monthValues[1] = []
      monthValues[2] = []
      monthValues[3] = []            
      monthValues[4] = []      
      monthValues[5] = []
      monthValues[6] = []
      monthValues[7] = []
      monthValues[8] = []
      monthValues[9] = []
      monthValues[10] = []
      monthValues[11] = []

      console.log "Collection foodlog"
      console.log @foodLog
      @foodLog.each (model)->  
        month = moment(model.get("created"),"YYYY-MM-DD").format('M')
        data =
          day:moment(model.get("created"),"YYYY-MM-DD").format('D')
          nutrition:model

        monthValues[month-1].push(data)


      console.log "Meses agrupados"
      console.log monthValues

      for monthData,index in monthValues
        if monthData.length > 0

          #nutArray = monthData.nutrition
          for nut in monthData
            carb=parseInt(carb) + (if nut.nutrition.get("carbs")==null then parseInt(0) else parseInt(nut.nutrition.get("carbs")))
            fat=parseInt(fat) + (if nut.nutrition.get("fat")==null then parseInt(0) else parseInt(nut.nutrition.get("fat")))
            chol=parseInt(chol) + (if nut.nutrition.get("cholesterol")==null then parseInt(0) else parseInt(nut.nutrition.get("cholesterol")))
            sod=parseInt(sod) + (if nut.nutrition.get("sodium")==null then parseInt(0) else parseInt(nut.nutrition.get("sodium")))
            pot=parseInt(pot) + (if nut.nutrition.get("potassium")==null then parseInt(0) else parseInt(nut.nutrition.get("potassium")))
            cal=parseInt(cal) + (if nut.nutrition.get("calcium")==null then parseInt(0) else parseInt(nut.nutrition.get("calcium")))

          carbSerie.data.push(carb)
          fatSerie.data.push(fat)
          cholSerie.data.push(chol)
          sodSerie.data.push(sod)
          potSerie.data.push(pot)
          calSerie.data.push(cal)
          @nutrition_tracker_data.labels.push(@getMonthByIndex(index))

        else
          carbSerie.data.push(parseInt(0))
          fatSerie.data.push(parseInt(0))
          cholSerie.data.push(parseInt(0))
          sodSerie.data.push(parseInt(0))
          potSerie.data.push(parseInt(0))
          calSerie.data.push(parseInt(0))
          @nutrition_tracker_data.labels.push(@getMonthByIndex(index))

      @nutrition_tracker_datasets.datasets.push(carbSerie)
      @nutrition_tracker_datasets.datasets.push(fatSerie)
      @nutrition_tracker_datasets.datasets.push(cholSerie)
      @nutrition_tracker_datasets.datasets.push(sodSerie)
      @nutrition_tracker_datasets.datasets.push(potSerie)
      @nutrition_tracker_datasets.datasets.push(calSerie)

      @nutrition_tracker_data.datasets=[
        @nutrition_tracker_datasets.datasets[0],
        @nutrition_tracker_datasets.datasets[1],
        @nutrition_tracker_datasets.datasets[2],
        @nutrition_tracker_datasets.datasets[3],
        @nutrition_tracker_datasets.datasets[4],
        @nutrition_tracker_datasets.datasets[5]
      ]   

    else

      that = @  
      count = 0;
      
      #sorted = @foodLog.sortBy (m) -> 
      # return m.get('created').getTime()

      @foodLog.each (model,index)-> 
      #for model,index in sorted
        console.log "Semana"
        console.log model
        carbSerie.data.push(if model.get("carbs")==null then parseInt(0) else parseInt(model.get("carbs")))
        fatSerie.data.push(if model.get("fat")==null then parseInt(0) else parseInt(model.get("fat")))
        cholSerie.data.push(if model.get("cholesterol")==null then parseInt(0) else parseInt(model.get("cholesterol")))
        sodSerie.data.push(if model.get("sodium")==null then parseInt(0) else parseInt(model.get("sodium")))
        potSerie.data.push(if model.get("potassium")==null then parseInt(0) else parseInt(model.get("potassium")))
        calSerie.data.push(if model.get("calcium")==null then parseInt(0) else parseInt(model.get("calcium")))
        that.nutrition_tracker_data.labels.push("Semana " + parseInt(index + 1))
        count = parseInt(index + 1) 

      if count < 4
        for scale in [(count + 1)..4]
          carbSerie.data.push(parseInt(0))
          fatSerie.data.push(parseInt(0))
          cholSerie.data.push(parseInt(0))
          sodSerie.data.push(parseInt(0))
          potSerie.data.push(parseInt(0))
          calSerie.data.push(parseInt(0))
          @nutrition_tracker_data.labels.push("Semana" + scale)

      @nutrition_tracker_datasets.datasets.push(carbSerie)
      @nutrition_tracker_datasets.datasets.push(fatSerie)
      @nutrition_tracker_datasets.datasets.push(cholSerie)
      @nutrition_tracker_datasets.datasets.push(sodSerie)
      @nutrition_tracker_datasets.datasets.push(potSerie)
      @nutrition_tracker_datasets.datasets.push(calSerie)

      @nutrition_tracker_data.datasets=[
        @nutrition_tracker_datasets.datasets[0],
        @nutrition_tracker_datasets.datasets[1],
        @nutrition_tracker_datasets.datasets[2],
        @nutrition_tracker_datasets.datasets[3],
        @nutrition_tracker_datasets.datasets[4],
        @nutrition_tracker_datasets.datasets[5]
      ]   

    $("#rightNutritionChartContainer").empty()
    $("#rightNutritionChartContainer").append('<canvas id="nutritionTracker" width="450" height="270"></canvas>')
    @ctx = $("#nutritionTracker").get(0).getContext("2d");  
    @ctx.clearRect(0, 0, @ctx.width, @ctx.height);
    @nutritionTracker = new Chart(@ctx).Line(@nutrition_tracker_data, @options);  

  renderProgressChart: ->

    @options = {
      scaleShowGridLines : true,
      scaleGridLineColor : "rgba(0,0,0,.05)",
      scaleGridLineWidth : 1,
      scaleShowHorizontalLines: true,
      scaleShowVerticalLines: true,
      bezierCurve : true,
      bezierCurveTension : 0.4,
      pointDot : true,
      pointDotRadius : 4,
      pointDotStrokeWidth : 1,
      pointHitDetectionRadius : 20,
      datasetStroke : true,
      datasetStrokeWidth : 2,
      datasetFill : true,
      animation : false,
    };


    Chart.defaults.global.responsive = false;
    Chart.defaults.global.scaleOverride = true;
    Chart.defaults.global.scaleSteps = 3;
    Chart.defaults.global.scaleStepWidth = 50;
    Chart.defaults.global.scaleStartValue = 0;
    Chart.defaults.global.scaleShowLabels = true;
    Chart.defaults.global.scaleFontSize = 10;

    @progress_tracker_datasets = {
      datasets: []
    }
 

    @progress_tracker_data = {
      labels: [],
      datasets: []
    };


    #Neck #FFA700
    neckSerie = 
      label: "Neck",
      fillColor: "rgba(255,167,0,0.4)",
      strokeColor: "rgba(255,167,0,1)",
      pointColor: "rgba(255,167,0,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(255,167,0,1)",
      pointHighlightStroke: "#fff",
      data: []  

    #34f580
    upperSerie =
      label: "Upper Left Arm",
      fillColor: "rgba(52,245,128,0.4)",
      strokeColor: "rgba(52,245,128,1)",
      pointColor: "rgba(52,245,128,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(52,245,128,1)",
      pointHighlightStroke: "#fff",
      data: []    

    #42d54a  
    waistSerie =
      label: "Waist",
      fillColor: "rgba(66,213,74,0.4)",
      strokeColor: "rgba(66,213,74,1)",
      pointColor: "rgba(66,213,74,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(66,213,74,1)",
      pointHighlightStroke: "#fff",
      data: []       

    #00a559  
    forearmLeftSerie =
      label: "Formarm Left",
      fillColor: "rgba(0,165,89,0.4)",
      strokeColor: "rgba(0,165,89,1)",
      pointColor: "rgba(0,165,89,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(0,165,89,1)",
      pointHighlightStroke: "#fff",
      data: []

    #4cc3d6
    thighLeftSerie =
      label: "Thigh Left",
      fillColor: "rgba(76,195,214,0.4)",
      strokeColor: "rgba(76,195,214,1)",
      pointColor: "rgba(76,195,214,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(76,195,214,1)",
      pointHighlightStroke: "#fff",
      data: []           

    #3e96ef  
    calfLeftSerie =
      label: "Calf Left",
      fillColor: "rgba(62,150,239,0.4)",
      strokeColor: "rgba(62,150,239,1)",
      pointColor: "rgba(62,150,239,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(62,150,239,1)",
      pointHighlightStroke: "#fff",
      data: []

    #5b3dfb  
    chestSerie =
      label: "Chest Left",
      fillColor: "rgba(91,61,251,0.4)",
      strokeColor: "rgba(91,61,251,1)",
      pointColor: "rgba(91,61,251,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(91,61,251,1)",
      pointHighlightStroke: "#fff",
      data: []  

    #793eef  
    upperArmRightSerie =
      label: "Upper Arm Right",
      fillColor: "rgba(121,62,239,0.4)",
      strokeColor: "rgba(121,62,239,1)",
      pointColor: "rgba(121,62,239,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(121,62,239,1)",
      pointHighlightStroke: "#fff",
      data: []

    #ff1ba8  
    hipsSerie =
      label: "Hips",
      fillColor: "rgba(255,27,168,0.4)",
      strokeColor: "rgba(255,27,168,1)",
      pointColor: "rgba(255,27,168,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(255,27,168,1)",
      pointHighlightStroke: "#fff",
      data: []    

    #ff0040  
    forearmRightSerie =
      label: "Forearm Right",
      fillColor: "rgba(255,0,64,0.4)",
      strokeColor: "rgba(255,0,64,1)",
      pointColor: "rgba(255,0,64,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(255,0,64,1)",
      pointHighlightStroke: "#fff",
      data: []    

    #df0101  
    thighRightSerie =
      label: "Thigh Right",
      fillColor: "rgba(223,1,1,0.4)",
      strokeColor: "rgba(223,1,1,1)",
      pointColor: "rgba(223,1,1,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(223,1,1,1)",
      pointHighlightStroke: "#fff",
      data: []         

    #efff00  
    calfRightSerie =
      label: "Calf Right",
      fillColor: "rgba(239,255,0,0.4)",
      strokeColor: "rgba(239,255,0,1)",
      pointColor: "rgba(239,255,0,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(239,255,0,1)",
      pointHighlightStroke: "#fff",
      data: []           



    #Get values to show depending of the filter year or month.
    selectOption = $("#selectFilter").val()
    if selectOption == "year"
      monthValues = []
      monthValues[0] = []
      monthValues[1] = []
      monthValues[2] = []
      monthValues[3] = []            
      monthValues[4] = []      
      monthValues[5] = []
      monthValues[6] = []
      monthValues[7] = []
      monthValues[8] = []
      monthValues[9] = []
      monthValues[10] = []
      monthValues[11] = []
                                    
      @progressCollection.each (model)->  
        month = moment(model.get("created"),"YYYY-MM-DD").format('M')
        data =
          day:moment(model.get("created"),"YYYY-MM-DD").format('D')
          progress:model

        monthValues[month-1].push(data)


      console.log "Meses agrupados"
      console.log monthValues

      for monthData,index in monthValues
        #neckSerie.data.push(parseInt(model.get("neck")))
        if monthData.length > 0
          console.log "monthData[0].progress.get(neck)"
          console.log monthData[0].progress.get("neck")
          progressMonth = monthData[0].progress;
          neckSerie.data.push(parseInt(progressMonth.get("neck")))
          upperSerie.data.push(parseInt(progressMonth.get("upperArmLeft")))
          waistSerie.data.push(parseInt(progressMonth.get("waist")))
          forearmLeftSerie.data.push(parseInt(progressMonth.get("forearmLeft")))
          thighLeftSerie.data.push(parseInt(progressMonth.get("thighLeft")))
          calfLeftSerie.data.push(parseInt(progressMonth.get("calfLeft")))
          chestSerie.data.push(parseInt(progressMonth.get("chest")))
          upperArmRightSerie.data.push(parseInt(progressMonth.get("upperArmRight")))
          hipsSerie.data.push(parseInt(progressMonth.get("hips")))
          forearmRightSerie.data.push(parseInt(progressMonth.get("forearmRight")))
          thighRightSerie.data.push(parseInt(progressMonth.get("thighRight")))
          calfRightSerie.data.push(parseInt(progressMonth.get("calfRight")))
          @progress_tracker_data.labels.push(@getMonthByIndex(index))
        else
          neckSerie.data.push(parseInt(0))
          upperSerie.data.push(parseInt(0))
          waistSerie.data.push(parseInt(0))
          forearmLeftSerie.data.push(parseInt(0))
          thighLeftSerie.data.push(parseInt(0))
          calfLeftSerie.data.push(parseInt(0))
          chestSerie.data.push(parseInt(0))
          upperArmRightSerie.data.push(parseInt(0))
          hipsSerie.data.push(parseInt(0))
          forearmRightSerie.data.push(parseInt(0))
          thighRightSerie.data.push(parseInt(0))
          calfRightSerie.data.push(parseInt(0))
          @progress_tracker_data.labels.push(@getMonthByIndex(index))


          
      @progress_tracker_datasets.datasets.push(neckSerie)
      @progress_tracker_datasets.datasets.push(upperSerie)
      @progress_tracker_datasets.datasets.push(waistSerie)
      @progress_tracker_datasets.datasets.push(forearmLeftSerie)
      @progress_tracker_datasets.datasets.push(thighLeftSerie)
      @progress_tracker_datasets.datasets.push(calfLeftSerie)
      @progress_tracker_datasets.datasets.push(chestSerie)
      @progress_tracker_datasets.datasets.push(upperArmRightSerie)
      @progress_tracker_datasets.datasets.push(hipsSerie)
      @progress_tracker_datasets.datasets.push(forearmRightSerie)
      @progress_tracker_datasets.datasets.push(thighRightSerie)
      @progress_tracker_datasets.datasets.push(calfRightSerie) 


      @progress_tracker_data.datasets=[
        @progress_tracker_datasets.datasets[0],
        @progress_tracker_datasets.datasets[1],
        @progress_tracker_datasets.datasets[2],
        @progress_tracker_datasets.datasets[3],
        @progress_tracker_datasets.datasets[4],
        @progress_tracker_datasets.datasets[5],
        @progress_tracker_datasets.datasets[6],
        @progress_tracker_datasets.datasets[7],
        @progress_tracker_datasets.datasets[8],
        @progress_tracker_datasets.datasets[9],
        @progress_tracker_datasets.datasets[10],
        @progress_tracker_datasets.datasets[11]
      ]   
      #@progress_tracker_data.labels = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "NOV", "DEC"]
    
    else

      that = @  
      count = 0;
      
      sorted = @progressCollection.sortBy (m) -> 
       return m.get('date').getTime()

      #sorted.each (model,index)-> 
      for model,index in sorted
        console.log "Semana"
        console.log model
        neckSerie.data.push(parseInt(model.get("neck")))
        upperSerie.data.push(parseInt(model.get("upperArmLeft")))
        waistSerie.data.push(parseInt(model.get("waist")))
        forearmLeftSerie.data.push(parseInt(model.get("forearmLeft")))
        thighLeftSerie.data.push(parseInt(model.get("thighLeft")))
        calfLeftSerie.data.push(parseInt(model.get("calfLeft")))
        chestSerie.data.push(parseInt(model.get("chest")))
        upperArmRightSerie.data.push(parseInt(model.get("upperArmRight")))
        hipsSerie.data.push(parseInt(model.get("hips")))
        forearmRightSerie.data.push(parseInt(model.get("forearmRight")))
        thighRightSerie.data.push(parseInt(model.get("thighRight")))
        calfRightSerie.data.push(parseInt(model.get("calfRight")))
        @progress_tracker_data.labels.push("Semana " + parseInt(index + 1))
        count = parseInt(index + 1) 

      if count < 4
        for scale in [(count + 1)..4]
          neckSerie.data.push(parseInt(0))
          upperSerie.data.push(parseInt(0))
          waistSerie.data.push(parseInt(0))
          forearmLeftSerie.data.push(parseInt(0))
          thighLeftSerie.data.push(parseInt(0))
          calfLeftSerie.data.push(parseInt(0))
          chestSerie.data.push(parseInt(0))
          upperArmRightSerie.data.push(parseInt(0))
          hipsSerie.data.push(parseInt(0))
          forearmRightSerie.data.push(parseInt(0))
          thighRightSerie.data.push(parseInt(0))
          calfRightSerie.data.push(parseInt(0))
          @progress_tracker_data.labels.push("Semana" + scale)

      @progress_tracker_datasets.datasets.push(neckSerie)
      @progress_tracker_datasets.datasets.push(upperSerie)
      @progress_tracker_datasets.datasets.push(waistSerie)
      @progress_tracker_datasets.datasets.push(forearmLeftSerie)
      @progress_tracker_datasets.datasets.push(thighLeftSerie)
      @progress_tracker_datasets.datasets.push(calfLeftSerie)
      @progress_tracker_datasets.datasets.push(chestSerie)
      @progress_tracker_datasets.datasets.push(upperArmRightSerie)
      @progress_tracker_datasets.datasets.push(hipsSerie)
      @progress_tracker_datasets.datasets.push(forearmRightSerie)
      @progress_tracker_datasets.datasets.push(thighRightSerie)
      @progress_tracker_datasets.datasets.push(calfRightSerie)



      @progress_tracker_data.datasets=[
        @progress_tracker_datasets.datasets[0],
        @progress_tracker_datasets.datasets[1],
        @progress_tracker_datasets.datasets[2],
        @progress_tracker_datasets.datasets[3],
        @progress_tracker_datasets.datasets[4],
        @progress_tracker_datasets.datasets[5],
        @progress_tracker_datasets.datasets[6],
        @progress_tracker_datasets.datasets[7],
        @progress_tracker_datasets.datasets[8],
        @progress_tracker_datasets.datasets[9],
        @progress_tracker_datasets.datasets[10],
        @progress_tracker_datasets.datasets[11]
      ]

      #@progress_tracker_data.labels = ["Semana 1","Semana 2","Semana 3","Semana 4"]



    $("#rightChartContainer").empty()
    $("#rightChartContainer").append('<canvas id="progressTracker" width="450" height="270"></canvas>')
    @ctx = $("#progressTracker").get(0).getContext("2d");  
    @ctx.clearRect(0, 0, @ctx.width, @ctx.height);
    @progressTracker = new Chart(@ctx).Line(@progress_tracker_data, @options);






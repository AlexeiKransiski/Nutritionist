class App.Views.Main.Status.Widgets.Charts extends Null.Views.Base 
  template: JST['app/main/status/widgets/charts.html']

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
    'click .box_left #custom_prev':'compareStatusLeft'
    'click .box_left #custom_next':'compareStatusRight'
    
    'click .box_right #custom_prev':'progressChartLeft'
    'click .box_right #custom_next':'progressChartRight'

    'ifChecked .progress_tracker_stat': 'reloadChart'
    'ifUnchecked .progress_tracker_stat': 'reloadChart'
    'ifChecked .nutrition_tracker_stat': 'reloadNutritionChart'
    'ifUnchecked .nutrition_tracker_stat': 'reloadNutritionChart'
    #'click .progress_tracker_stat': 'reloadChart'
    #'click .nutrition_tracker_stat': 'reloadNutritionChart'
    'change #selectFilter': 'searchByFilter'
    'change #selectFilterLeft': 'searchByFilterLeft'
    'change #selectFilterMeassure': 'searchByFilter'
    

  progressChartLeft:()->
    text = $('#page-status .box_right .foot p').html();
    if text != 'BODY MEASSUREMENTS'
      $('#page-status .box_right .foot p').html('BODY MEASSUREMENTS')
      $("#formChecks").show()
      $("#formChecks2").hide() 
      $("#bodySlide").empty();
      $("#nutritionSlide").empty();
      $("#nutritionSlide").append("empty");
      $("#bodySlide").append('<div id="rightChartContainer"></div>');
      selectOption = $("#selectFilter").val()
      if selectOption == "year"
        @searchBodyYear()
      else if selectOption == "month"
        @searchBodyMonth()
      else if selectOption == "week"
        @searchBodyWeek()

    else
      $('#page-status .box_right .foot p').html('NUTRITIONAL FACTS')
      $("#formChecks").hide()
      $("#formChecks2").show()
      $("#bodySlide").empty();
      $("#nutritionSlide").empty();
      $("#nutritionSlide").append('<div id="rightNutritionChartContainer"></div>');
      selectOption = $("#selectFilter").val()
      if selectOption == "year"
        @searchNutritionYear()
      else if selectOption == "month"
        @searchNutritionMonth() 
      else if selectOption == "week"
        @searchNutritionWeek()

    return false;

  progressChartRight:()->
    text = $('#page-status .box_right .foot p').html();
    if text != 'NUTRITIONAL FACTS'
      $('#page-status .box_right .foot p').html('NUTRITIONAL FACTS')
      $("#formChecks").hide()
      $("#formChecks2").show()
      $("#bodySlide").empty();
      $("#bodySlide").append("empty");
      $("#nutritionSlide").empty();
      $("#nutritionSlide").append('<div id="rightNutritionChartContainer"></div>');
      selectOption = $("#selectFilter").val()
      if selectOption == "year"
        @searchNutritionYear()
      else if selectOption == "month"
        @searchNutritionMonth() 
      else if selectOption == "week"
        @searchNutritionWeek()
    else
      $('#page-status .box_right .foot p').html('BODY MEASSUREMENTS')
      $("#preferences").show()  
      $("#formChecks2").hide() 
      $("#bodySlide").empty();
      $("#nutritionSlide").empty();
      $("#nutritionSlide").append("empty");
      $("#bodySlide").append('<div id="rightChartContainer"></div>');
      selectOption = $("#selectFilter").val()
      if selectOption == "year"
        @searchBodyYear()
      else if selectOption == "month"
        @searchBodyMonth()
      else if selectOption == "week"
        @searchBodyWeek()

    return false;
    
  compareStatusLeft:->
    console.log "compareStatusLeft"
    text = $('#page-status .box_left .foot p').html();
    if text != 'EXERCISE'
      $('#page-status .box_left .foot p').html('EXERCISE')
      $("#exerciseCompareSlide").empty()
      $("#nutritionCompareSlide").empty()
      $("#nutritionCompareSlide").append("empty")
      $("#exerciseCompareSlide").append('<div id="compareStatus"></div>')
      @searchExerciseCompare()
    else
      $('#page-status .box_left .foot p').html('NUTRITION');
      $("#exerciseCompareSlide").empty()
      $("#nutritionCompareSlide").empty()
      $("#exerciseCompareSlide").append("empty")
      $("#nutritionCompareSlide").append('<div id="compareStatus"></div>')
      @searchNutritionCompare()

    return false;

  compareStatusRight:->
    text = $('#page-status .box_left .foot p').html();
    if text != 'NUTRITION'
      $('#page-status .box_left .foot p').html('NUTRITION') 
      $("#exerciseCompareSlide").empty()
      $("#nutritionCompareSlide").empty()
      $("#exerciseCompareSlide").append("empty")
      $("#nutritionCompareSlide").append('<div id="compareStatus"></div>')
      @searchNutritionCompare() 
    else
      $('#page-status .box_left .foot p').html('EXERCISE')
      $("#exerciseCompareSlide").empty()
      $("#nutritionCompareSlide").empty()
      $("#nutritionCompareSlide").append("empty")
      $("#exerciseCompareSlide").append('<div id="compareStatus"></div>')
      @searchExerciseCompare()
    return false;

  getCompareSelection:()->
    return $('#page-status .box_left .foot p').html();

  getProgressSelection:()->
    return $('#page-status .box_right .foot p').html();

  initialize: ->
    super
    
    @progress_tracker_datasets = {
        datasets: []
    }; 

    @progressCollection = new App.Collections.Progress()
    
    id = null 
    if app.me.get('patientPreferences') instanceof Object  
      id = app.me.get('patientPreferences')._id
    else
      id = app.me.get('patientPreferences')


    @patientPreferences = new App.Models.PatientPreferences({_id: id })    
    @patientPreferences.fetch()

    @foodLog = new App.Collections.FoodLog()

    @foodCompareLog = new App.Collections.FoodLog()

    @exerciseLog = new App.Collections.ExerciseLog()
    #@searchExerciseCompare()

    @listenTo @progressCollection, 'reset', @renderProgressChart
    @listenTo @foodLog, 'reset', @renderNutritionChart


    @listenTo @foodCompareLog, 'reset', @renderCompareNutritionChart
    @listenTo @exerciseLog, 'reset', @renderCompareExerciseChart
          
    @listenToOnce @patientPreferences, "sync", @render       

  searchByFilterLeft: ->
    selectFilterLeft = $("#selectFilterLeft").val()
    if selectFilterLeft == "1"
      @searchExerciseCompare()
    else      
      @searchNutritionCompare() 



  searchByFilter: ->
    #alert @getCompareSelection()
    #alert @getProgressSelection()
    panelCompare = @getCompareSelection()
    panelProgress = @getProgressSelection()
    
    console.log "Filtro de combos"
    selectOption = $("#selectFilter").val()
    selectMeassureOption = $("#selectFilterMeassure").val()
    
    #Compare charts.
    searchByFilterLeft = $("#searchByFilterLeft").val()

    if panelCompare == "EXERCISE"
      @searchExerciseCompare()
    else
      @searchNutritionCompare()
        





    #Progress chart.
    if selectOption == "year"

      if panelProgress == "body meassurements" || panelProgress == "BODY MEASSUREMENTS" 
        $('#page-status .box_right .foot p').html('BODY MEASSUREMENTS')
        $("#formChecks").show()
        $("#formChecks2").hide() 
        $("#bodySlide").empty();
        $("#nutritionSlide").empty();
        $("#nutritionSlide").append("empty");
        $("#bodySlide").append('<div id="rightChartContainer"></div>');
        @searchBodyYear()
      else
        $('#page-status .box_right .foot p').html('NUTRITIONAL FACTS')
        $("#formChecks").hide()
        $("#formChecks2").show()
        $("#bodySlide").empty();
        $("#bodySlide").append("empty");
        $("#nutritionSlide").empty();
        $("#nutritionSlide").append('<div id="rightNutritionChartContainer"></div>');
        @searchNutritionYear()
    
    else if selectOption == "month"

      if panelProgress == "body meassurements" || panelProgress == "BODY MEASSUREMENTS" 
        $('#page-status .box_right .foot p').html('BODY MEASSUREMENTS')
        $("#formChecks").show()
        $("#formChecks2").hide() 
        $("#bodySlide").empty();
        $("#nutritionSlide").empty();
        $("#nutritionSlide").append("empty");
        $("#bodySlide").append('<div id="rightChartContainer"></div>');
        @searchBodyMonth()
      else
        $('#page-status .box_right .foot p').html('NUTRITIONAL FACTS')
        $("#formChecks").hide()
        $("#formChecks2").show()
        $("#bodySlide").empty();
        $("#bodySlide").append("empty");
        $("#nutritionSlide").empty();
        $("#nutritionSlide").append('<div id="rightNutritionChartContainer"></div>');
        @searchNutritionMonth() 

    else if selectOption == "week"
      if panelProgress == "body meassurements" || panelProgress == "BODY MEASSUREMENTS" 
        $('#page-status .box_right .foot p').html('BODY MEASSUREMENTS')
        $("#formChecks").show()
        $("#formChecks2").hide() 
        $("#bodySlide").empty();
        $("#nutritionSlide").empty();
        $("#nutritionSlide").append("empty");
        $("#bodySlide").append('<div id="rightChartContainer"></div>');
        @searchBodyWeek()
      else
        $('#page-status .box_right .foot p').html('NUTRITIONAL FACTS')
        $("#formChecks").hide()
        $("#formChecks2").show()
        $("#bodySlide").empty();
        $("#bodySlide").append("empty");
        $("#nutritionSlide").empty();
        $("#nutritionSlide").append('<div id="rightNutritionChartContainer"></div>');
        @searchNutritionWeek()

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

  searchBodyWeek:()->
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

  searchNutritionWeek:()->
    month = moment().format('M')
    day = moment().endOf('month').format('D')
    @foodLog.fetch
      data: 
        created: 
          $gte: moment(moment().year() + "-" + month + "-01 00:00","YYYY-MM-DD").toISOString(),
          $lt: moment(moment().year() + "-" + month + "-" + day ,"YYYY-MM-DD").toISOString()

        user: app.me.id 
      reset: true        

  getContext:()->
    return{
        patientPreferences:@patientPreferences
      }  

  render: ->
    super

    if @$('.box_right .col-xs-3').length > 0
      @$('.box_right .col-xs-3').mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true, autoScrollOnFocus: false

    months = parseInt(moment().diff(app.me.get("created"), 'months', true))      
    if months == 0
      @searchBodyWeek()
    else if months>0 && months<12
      @searchBodyMonth()
    else 
      @searchBodyYear()

    #$("#exerciseCompareSlide").empty() 
    $("#nutritionCompareSlide").empty()
    $("#nutritionCompareSlide").append("empty")
    #$("#nutritionCompareSlide").append("empty")
    $("#exerciseCompareSlide").append('<div id="compareStatus"></div>')
    $("#compareStatus").empty()
    #$("#compareStatus").append('<canvas id="statusByYear" width="280" height="200"></canvas>')
    @searchExerciseCompare()
    
    @


  reloadNutritionChart:(event)->
    @nutrition_tracker_data.datasets = [];
    console.log("Inspeccionara aqui")
    
    #if @nutrition_tracker_data.datasets.length
    @ctx.clearRect(0, 0, @ctx.width, @ctx.height);
    console.log "@getNutrientElementsToShow()"
    console.log @getNutrientElementsToShow()
    @nutritionTracker = new Chart(@ctx).Line(@getNutrientElementsToShow(), @options);

    #if $('#formChecks2').find('input:checked').length > 0

    #  #$('#formChecks2').find('input:checked').each (index, element) =>
    #  #  if @nutrition_tracker_datasets.datasets[element.value] != undefined
    #  #    @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[element.value]);
    
    #  @nutrition_tracker_data=@getNutrientElementsToShow()

    #else
    #  console.log "event.currentTarget"
    #  console.log event.currentTarget
    #  event.target.checked=true



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
        return "Jan"
      if index + 1 == 2
        return "Feb"
      if index + 1 == 3
        return "Mar"          
      if index + 1 == 4
        return "Apr" 
      if index + 1 == 5
        return "May"            
      if index + 1 == 6
        return "Jun"
      if index + 1 == 7
        return "Jul"   
      if index + 1 == 8
        return "Aug"                
      if index + 1 == 9
        return "Sep"  
      if index + 1 == 10
        return "Oct"   
      if index + 1 == 11
        return "Nov"    
      if index + 1 == 12
        return "Dec"                          

  getScaleCharts:(values)->
    console.log "Revisando valores"
    max = 0
    for value in values
      if value > max
        max = value
    return parseInt((max + 30)/3)

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

    currentWeekSerie = 
      label: "2015",
      fillColor: "rgba(78,145,217,0.4)",
      strokeColor: "rgba(115,164,216,1)",
      pointColor: "rgba(115,164,216,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(115,164,216,1)",
      pointHighlightStroke: "#fff",
      data: []  

    lastWeekSerie = 
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


        currentWeekSerie.label="Current Week"
        lastWeekSerie.label="Last Week"

        $("#currentLabel").empty()
        $("#lastLabel").empty()
        $("#currentLabel").append('<span class="indicator indicator_2015"></span> ' + moment().format('YYYY'))
        $("#lastLabel").append('<span class="indicator indicator_2014"></span> ' + parseInt(moment().format('YYYY')-1))



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

        #Get chart scale.
        valuesRange = []
        for value in currentYearSerie
          valuesRange.push(value)
        for value in lastYearSerie
          valuesRange.push(value)

        @options.scaleStepWidth = @getScaleCharts(valuesRange)


        @nutcompare_tracker_data.datasets=[
          @nutcompare_tracker_datasets.datasets[0],
          @nutcompare_tracker_datasets.datasets[1]
        ] 

    else if selectOption == "month"
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


      currentWeekSerie.label="Current Week"
      lastWeekSerie.label="Last Week"

      $("#currentLabel").empty()
      $("#lastLabel").empty()
      $("#currentLabel").append('<span class="indicator indicator_2015"></span> ' + moment().format('MMMM'))
      $("#lastLabel").append('<span class="indicator indicator_2014"></span> ' + @getMonthByIndex(moment().format('M')-2))


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

      #Get chart scale.
      valuesRange = []
      for value in currentMonthSerie
        valuesRange.push(value)
      for value in lastMonthSerie
        valuesRange.push(value)

      @options.scaleStepWidth = @getScaleCharts(valuesRange)  


      @nutcompare_tracker_datasets.datasets.push(lastMonthSerie)

      @nutcompare_tracker_data.labels = ["Week 1","Week 2","Week 3","Week 4"]
      @nutcompare_tracker_data.datasets=[
        @nutcompare_tracker_datasets.datasets[0],
        @nutcompare_tracker_datasets.datasets[1]
      ]   

    else if selectOption == "week"

      console.log "@foodCompareLog"
      console.log @foodCompareLog
      daysMonth = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonth
        daysMonth[i] = []

      #for value,index in sorted
      @foodCompareLog.each (value) -> 
        console.log(value) 
        daysMonth[moment(value.get("created")).format('D')-1].push(value)

      console.log "daysMonth per Week"
      console.log daysMonth  
      valuesConverted=[]
      for value,index in daysMonth
        if value.length == 0
          dd = index + 1
          mm = moment().format('M')
          yy = moment().format('YYYY')
          foodLogTemp = new App.Models.FoodLog()
          foodLogTemp.set "created",moment(dd + "/" + mm + "/" + yy,"DD/MM/YYYY").hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()
          foodLogTemp.set "calories", parseInt(0)
          valuesConverted.push(foodLogTemp)
        else
          valuesConverted.push(value[0])

      console.log "valuesConverted" 
      console.log valuesConverted   
      
      weekOne = []
      weekTwo = []
      weekThree = []
      weekFour = [] 
    
      for exercise,index in valuesConverted
        if index <= 7
          weekOne.push(exercise)
        if index > 7 && index <= 15
          weekTwo.push(exercise)
        if index > 15 && index <= 23
          weekThree.push(exercise)
        if index > 23 && index <= 31
          weekFour.push(exercise)

      day = moment().format('D')
      console.log "weeks"
      console.log weekOne
      console.log weekTwo
      console.log weekThree
      console.log weekFour

      console.log "longitudes"
      console.log weekOne.length
      console.log weekTwo.length
      console.log weekThree.length
      console.log weekFour.length

      weekToShow = null
      if day <= 7
        weekToShow = weekOne
      if day > 7 && day <= 15
        weekToShow = weekTwo
      if day > 15 && day <= 23
        weekToShow = weekThree
      if day > 23 && day <= 31
        weekToShow = weekFour

      console.log "weekToShow"
      console.log weekToShow

      lastWeek = null
      #Define last week
      if day <= 7
        lastWeek = []
        for i in [0..6]
          dd = index + 1
          mm = moment().format('M')
          yy = moment().format('YYYY')
          foodLogTemp = new App.Models.FoodLog()
          foodLogTemp.set "created",moment(dd + "/" + mm + "/" + yy,"DD/MM/YYYY").hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()
          foodLogTemp.set "calories", parseInt(0)
          lastWeek.push(foodLogTemp)
      if day > 7 && day <= 15
        lastWeek = weekOne
      if day > 15 && day <= 23
        lastWeek = weekTwo
      if day > 23 && day <= 31
        lastWeek = weekThree

      arrays = @balanceWeeksToCompare(lastWeek,weekToShow)

      console.log "balanced weeks"
      console.log "currentWeekSerie"
      console.log arrays[1]
      console.log "lastWeek"
      console.log arrays[0]

      weekCurrent = arrays[1]
      weekLast = arrays[0]


      caloriesBurnedDay = 0
      for one,index in weekLast
        lastWeekSerie.data.push(parseInt(one.get("calories")))

      console.log "currentWeekSerie"
      console.log weekCurrent
      console.log "lastWeek"
      console.log weekLast


      caloriesBurnedDay = 0
      for one,index in weekCurrent
        currentWeekSerie.data.push(parseInt(one.get("calories")))


      currentWeekSerie.label="Current Week"
      lastWeekSerie.label="Last Week"

      $("#currentLabel").empty()
      $("#lastLabel").empty()
      $("#currentLabel").append('<span class="indicator indicator_2015"></span> Current Week')
      $("#lastLabel").append('<span class="indicator indicator_2014"></span> Last Week')



      @nutcompare_tracker_datasets.datasets.push(currentWeekSerie)
      @nutcompare_tracker_datasets.datasets.push(lastWeekSerie)

      #Get chart scale.
      valuesRange = []
      for value in currentWeekSerie
        valuesRange.push(value)
      for value in lastWeekSerie
        valuesRange.push(value)

      @options.scaleStepWidth = @getScaleCharts(valuesRange)  
      
      console.log(@createCompareWeekNutritionLabels(weekLast,weekCurrent))
      @nutcompare_tracker_data.labels = @createCompareWeekNutritionLabels(weekLast,weekCurrent)

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


    currentWeekSerie = 
      label: "2015",
      fillColor: "rgba(78,145,217,0.4)",
      strokeColor: "rgba(115,164,216,1)",
      pointColor: "rgba(115,164,216,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(115,164,216,1)",
      pointHighlightStroke: "#fff",
      data: []  

    lastWeekSerie = 
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

        #Get chart scale.
        valuesRange = []
        for value in currentYearSerie
          valuesRange.push(value)
        for value in lastYearSerie
          valuesRange.push(value)

        @options.scaleStepWidth = @getScaleCharts(valuesRange)

        @exercise_tracker_data.datasets=[
          @exercise_tracker_datasets.datasets[0],
          @exercise_tracker_datasets.datasets[1]
        ] 
      
    else if selectOption == "month"

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

      #Get chart scale.
      valuesRange = []
      for value in currentMonthSerie
        valuesRange.push(value)
      for value in lastMonthSerie
        valuesRange.push(value)

      @options.scaleStepWidth = @getScaleCharts(valuesRange)

      @exercise_tracker_datasets.datasets.push(lastMonthSerie)

      @exercise_tracker_data.labels = ["Week 1","Week 2","Week 3","Week 4"]
      @exercise_tracker_data.datasets=[
        @exercise_tracker_datasets.datasets[0],
        @exercise_tracker_datasets.datasets[1]
      ]   
      
    else if selectOption == "week"

      console.log "Sacar grafica de weeks con la siguiente lista"
      console.log @exerciseLog

      daysMonth = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonth
        daysMonth[i] = []

      #for value,index in sorted
      @exerciseLog.each (value) -> 
        console.log(value) 
        daysMonth[moment(value.get("exercise_date")).format('D')-1].push(value)

      console.log "daysMonth per Week"
      console.log daysMonth  
      valuesConverted=[]
      for value,index in daysMonth
        if value.length == 0
          dd = index + 1
          mm = moment().format('M')
          yy = moment().format('YYYY')
          exerciseLogTemp = new App.Models.ExerciseLog()
          exerciseLogTemp.set "exercise_date",moment(dd + "/" + mm + "/" + yy,"DD/MM/YYYY").hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()
          exerciseLogTemp.set "calories_burned", parseInt(0)
          valuesConverted.push(exerciseLogTemp)
        else
          valuesConverted.push(value[0])

      console.log "valuesConverted" 
      console.log valuesConverted   

      weekOne = []
      weekTwo = []
      weekThree = []
      weekFour = [] 
    
      for exercise,index in valuesConverted
        if index <= 7
          weekOne.push(exercise)
        if index > 7 && index <= 15
          weekTwo.push(exercise)
        if index > 15 && index <= 23
          weekThree.push(exercise)
        if index > 23 && index <= 31
          weekFour.push(exercise)


      day = moment().format('D')
      console.log "weeks"
      console.log weekOne
      console.log weekTwo
      console.log weekThree
      console.log weekFour

      console.log "longitudes"
      console.log weekOne.length
      console.log weekTwo.length
      console.log weekThree.length
      console.log weekFour.length

      weekToShow = null
      if day <= 7
        weekToShow = weekOne
      if day > 7 && day <= 15
        weekToShow = weekTwo
      if day > 15 && day <= 23
        weekToShow = weekThree
      if day > 23 && day <= 31
        weekToShow = weekFour

      console.log "weekToShow"
      console.log weekToShow






      lastWeek = null
      #Define last week
      if day <= 7
        lastWeek = []
        for i in [0..6]
          dd = index + 1
          mm = moment().format('M')
          yy = moment().format('YYYY')
          exerciseLogTemp = new App.Models.ExerciseLog()
          exerciseLogTemp.set "exercise_date",moment(dd + "/" + mm + "/" + yy,"DD/MM/YYYY").hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()
          exerciseLogTemp.set "calories_burned", parseInt(0)
          lastWeek.push(exerciseLogTemp)
      if day > 7 && day <= 15
        lastWeek = weekOne
      if day > 15 && day <= 23
        lastWeek = weekTwo
      if day > 23 && day <= 31
        lastWeek = weekThree

      currentWeekSerie.label="Current Week"
      lastWeekSerie.label="Last Week"

      $("#currentLabel").empty()
      $("#lastLabel").empty()
      $("#currentLabel").append('<span class="indicator indicator_2015"></span> Current Week')
      $("#lastLabel").append('<span class="indicator indicator_2014"></span> Last Week')


      arrays = @balanceWeeksToCompare(lastWeek,weekToShow)

      console.log "balanced weeks"
      console.log "currentWeekSerie"
      console.log arrays[1]
      console.log "lastWeek"
      console.log arrays[0]

      weekCurrent = arrays[1]
      weekLast = arrays[0]


      caloriesBurnedDay = 0
      for one,index in weekLast
        lastWeekSerie.data.push(parseInt(one.get("calories_burned")))

      console.log "currentWeekSerie"
      console.log weekCurrent
      console.log "lastWeek"
      console.log weekLast


      caloriesBurnedDay = 0
      for one,index in weekCurrent
        currentWeekSerie.data.push(parseInt(one.get("calories_burned")))

      #Get chart scale.
      valuesRange = []
      for value in currentWeekSerie
        valuesRange.push(value)
      for value in lastWeekSerie
        valuesRange.push(value)

      @options.scaleStepWidth = @getScaleCharts(valuesRange)
      

      @exercise_tracker_datasets.datasets.push(currentWeekSerie)
      @exercise_tracker_datasets.datasets.push(lastWeekSerie)

      console.log(@createCompareWeekLabels(weekLast,weekCurrent))
      @exercise_tracker_data.labels = @createCompareWeekLabels(weekLast,weekCurrent)

      @exercise_tracker_data.datasets=[
        @exercise_tracker_datasets.datasets[0],
        @exercise_tracker_datasets.datasets[1]
      ]   

    console.log "Breakpoint aqui"
    $("#compareStatus").empty()
    $("#compareStatus").append('<canvas id="exerciseCompare" width="310" height="221" style="width: 310px; height: 221px;"></canvas>')
    @ctx2 = $("#exerciseCompare").get(0).getContext("2d");  
    console.log "@ctx2.canvas.width " + @ctx2.width
    console.log "@ctx2.canvas.height " + @ctx2.height
    console.log @ctx2
    #@ctx2.clearRect(0, 0, $("#exerciseCompare").get(0).width, $("#exerciseCompare").get(0).height);
    #@ctx2.clearRect(0, 0, 310, 221);
    @exerciseTracker = new Chart(@ctx2).Line(@exercise_tracker_data, @options); 
    #$("#exerciseCompare").attr("height",221)
    #$("#exerciseCompare").attr("width",310)
    
    #$("#rightChartContainer").empty()
    #$("#rightChartContainer").append('<canvas id="progressTracker" width="429" height="270"></canvas>')
    #@ctx = $("#progressTracker").get(0).getContext("2d");  
    #@ctx.clearRect(0, 0, @ctx.width, @ctx.height);
    #@progressTracker = new Chart(@ctx).Line(@progress_tracker_data, @options);




  createCompareWeekLabels:(last,current)->
    labels=[]
    for e,i in last
      add=true
      day = moment(e.get("exercise_date")).format('ddd')
      for l in labels
        if l == day
          add=false
      if add
        labels.push(moment(e.get("exercise_date")).format('ddd'))
    return labels  

  createCompareWeekNutritionLabels:(last,current)->
    labels=[]
    for e,i in last
      add=true
      day = moment(e.get("created")).format('ddd')
      for l in labels
        if l == day
          add=false
      if add
        labels.push(moment(e.get("created")).format('ddd'))
    return labels    

  balanceWeeksToCompare:(last,current)->
    ret = []
    if last.length == current.length
      ret.push(last)
      ret.push(current)
      return ret
    else if last.length > current.length
      diff = last.length - current.length
      if diff == 1
        newLast = []
        for i in [1..last.length-1]
          console.log i
          newLast.push(last[i])

        ret.push(newLast)
        ret.push(current)
        return ret
      else
        diff = last.length - current.length
        newLast = []
        for e,i in last
          if i == parseInt(last.length-diff)
            current.push(e)
          else
            newLast.push(e)  

        ret.push(newLast)
        ret.push(current)
        return ret

    else if current.length > last.length 

       diff = current.length - last.length
       if diff == 1
        
        newCurrent = []
        for i in [1..current.length-1]
          console.log i
          newCurrent.push(current[i])

        ret.push(newCurrent)
        ret.push(last)
        return ret

       else 

        diff = current.length - last.length
        newCurrent = []
        for e,i in current
          if i == parseInt(current.length-diff)
            last.push(e)
          else
            newCurrent.push(e)  

        ret.push(newCurrent)
        ret.push(last)
        return ret


#########################



  getNutrientElementsToShow:()->
    console.log "Nutrients to show"
    if $('#formChecks2').find('input:checked').length > 0

      $('#formChecks2').find('input:checked').each (index, element) =>
        if element.value == "carbs"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[0]);
        else if element.value == "vitamin_a"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[7]);
        else if element.value == "cholesterol"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[2]);
        else if element.value == "protein"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[5]);
        else if element.value == "sodium"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[3]);     
        else if element.value == "potassium"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[4]);      
        else if element.value == "fat"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[1]);        
        else if element.value == "calories"
           @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[6]);          
          
        #if @nutrition_tracker_datasets.datasets[element.value] != undefined
        #  @nutrition_tracker_data.datasets.push(@nutrition_tracker_datasets.datasets[element.value]);


    return @nutrition_tracker_data


  #Implementar widget settings
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
    Chart.defaults.global.scaleStepWidth = 800;
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

    protSerie =
      label: "Prot",
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

    vitaSerie =
      label: "Vit A",
      fillColor: "rgba(66,213,74,0.4)",
      strokeColor: "rgba(66,213,74,1)",
      pointColor: "rgba(66,213,74,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "rgba(66,213,74,1)",
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
      prot=0
      vita=0

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
            prot=parseInt(prot) + (if nut.nutrition.get("protain")==null then parseInt(0) else parseInt(nut.nutrition.get("protain")))
            cal=parseInt(cal) + (if nut.nutrition.get("calcium")==null then parseInt(0) else parseInt(nut.nutrition.get("calcium")))
            vita=parseInt(vita) + (if nut.nutrition.get("vitamin_a")==null then parseInt(0) else parseInt(nut.nutrition.get("vitamin_a")))

          carbSerie.data.push(carb)
          fatSerie.data.push(fat)
          cholSerie.data.push(chol)
          sodSerie.data.push(sod)
          potSerie.data.push(pot)
          protSerie.data.push(prot)
          calSerie.data.push(cal)
          vitaSerie.data.push(vita)
          @nutrition_tracker_data.labels.push(@getMonthByIndex(index))

        else
          carbSerie.data.push(parseInt(0))
          fatSerie.data.push(parseInt(0))
          cholSerie.data.push(parseInt(0))
          sodSerie.data.push(parseInt(0))
          potSerie.data.push(parseInt(0))
          protSerie.data.push(parseInt(0))
          calSerie.data.push(parseInt(0))
          vitaSerie.data.push(parseInt(0))
          @nutrition_tracker_data.labels.push(@getMonthByIndex(index))

      #Get chart scale.
      valuesRange = []
      for value in carbSerie.data
        valuesRange.push(value)
      for value in fatSerie.data
        valuesRange.push(value)
      for value in cholSerie.data
        valuesRange.push(value)
      for value in sodSerie.data
        valuesRange.push(value)    
      for value in potSerie.data
        valuesRange.push(value)    
      for value in calSerie.data
        valuesRange.push(value)    
      for value in protSerie.data
        valuesRange.push(value)    
      for value in vitaSerie.data
        valuesRange.push(value)    


      @options.scaleStepWidth = @getScaleCharts(valuesRange)

      @nutrition_tracker_datasets.datasets.push(carbSerie)
      @nutrition_tracker_datasets.datasets.push(fatSerie)
      @nutrition_tracker_datasets.datasets.push(cholSerie)
      @nutrition_tracker_datasets.datasets.push(sodSerie)
      @nutrition_tracker_datasets.datasets.push(potSerie)
      @nutrition_tracker_datasets.datasets.push(protSerie)
      @nutrition_tracker_datasets.datasets.push(calSerie)
      @nutrition_tracker_datasets.datasets.push(vitaSerie)

      #@nutrition_tracker_data.datasets=[
      #  @nutrition_tracker_datasets.datasets[0],
      #  @nutrition_tracker_datasets.datasets[1],
      #  @nutrition_tracker_datasets.datasets[2],
      #  @nutrition_tracker_datasets.datasets[3],
      #  @nutrition_tracker_datasets.datasets[4],
      #  @nutrition_tracker_datasets.datasets[5],
      #  @nutrition_tracker_datasets.datasets[6],
      #  @nutrition_tracker_datasets.datasets[7]
      #]   

    else if selectOption == "month"

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
        protSerie.data.push(if model.get("protein")==null then parseInt(0) else parseInt(model.get("protein")))
        vitaSerie.data.push(if model.get("vitamin_a")==null then parseInt(0) else parseInt(model.get("vitamin_a")))
                
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
          protSerie.data.push(parseInt(0))
          vitaSerie.data.push(parseInt(0))
          @nutrition_tracker_data.labels.push("Semana" + scale)

      #Get chart scale.
      valuesRange = []
      for value in carbSerie.data
        valuesRange.push(value)
      for value in fatSerie.data
        valuesRange.push(value)
      for value in cholSerie.data
        valuesRange.push(value)
      for value in sodSerie.data
        valuesRange.push(value)    
      for value in potSerie.data
        valuesRange.push(value)    
      for value in calSerie.data
        valuesRange.push(value)    
      for value in protSerie.data
        valuesRange.push(value)    
      for value in vitaSerie.data
        valuesRange.push(value)    


      @options.scaleStepWidth = @getScaleCharts(valuesRange)

      @nutrition_tracker_datasets.datasets.push(carbSerie)
      @nutrition_tracker_datasets.datasets.push(fatSerie)
      @nutrition_tracker_datasets.datasets.push(cholSerie)
      @nutrition_tracker_datasets.datasets.push(sodSerie)
      @nutrition_tracker_datasets.datasets.push(potSerie)
      @nutrition_tracker_datasets.datasets.push(protSerie)
      @nutrition_tracker_datasets.datasets.push(calSerie)
      @nutrition_tracker_datasets.datasets.push(vitaSerie)

      #@nutrition_tracker_data.datasets=[
      #  @nutrition_tracker_datasets.datasets[0],
      #  @nutrition_tracker_datasets.datasets[1],
      #  @nutrition_tracker_datasets.datasets[2],
      #  @nutrition_tracker_datasets.datasets[3],
      #  @nutrition_tracker_datasets.datasets[4],
      #  @nutrition_tracker_datasets.datasets[5]
      #]   
    else if selectOption == "week"
      console.log "@foodLog"
      console.log @foodLog

      daysMonth = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonth
        daysMonth[i] = []

      #sorted = @foodLog.sortBy (m) -> 
      # console.log m
      # return m.get('created').getTime()
       
      #for value,index in sorted
      @foodLog.each (value) -> 
        console.log(value) 
        daysMonth[moment(value.get("created")).format('D')-1].push(value)

      console.log "daysMonth per Week"
      console.log daysMonth  
      valuesConverted=[]
      for value,index in daysMonth
        if value.length == 0
          dd = index + 1
          mm = moment().format('M')
          yy = moment().format('YYYY')
          foodLogTemp = new App.Models.FoodLog()
          foodLogTemp.set "created",moment(dd + "/" + mm + "/" + yy,"DD/MM/YYYY").hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()
          foodLogTemp.set "carbs", parseInt(0)
          foodLogTemp.set "fat", parseInt(0)
          foodLogTemp.set "cholesterol", parseInt(0)
          foodLogTemp.set "sodium", parseInt(0)
          foodLogTemp.set "potassium", parseInt(0)
          foodLogTemp.set "calcium", parseInt(0)
          foodLogTemp.set "protein", parseInt(0)
          foodLogTemp.set "vitamin_a", parseInt(0)          
          valuesConverted.push(foodLogTemp)

        else
          valuesConverted.push(value[0])


      weekOne = []
      weekTwo = []
      weekThree = []
      weekFour = [] 
    
      for nutrition,index in valuesConverted
        if index <= 7
          weekOne.push(nutrition)
        if index > 7 && index <= 14
          weekTwo.push(nutrition)
        if index > 14 && index <= 21
          weekThree.push(nutrition)
        if index > 21 && index <= 31
          weekFour.push(nutrition)


      day = moment().format('D')
      console.log "weeks"
      console.log weekOne
      console.log weekTwo
      console.log weekThree
      console.log weekFour

      weekToShow = null
      if day <= 7
        weekToShow = weekOne
      if day > 7 && day <= 14
        weekToShow = weekTwo
      if day > 14 && day <= 21
        weekToShow = weekThree
      if day > 21 && day <= 31
        weekToShow = weekFour

      console.log "weekToShow"
      console.log weekToShow

      for model,i in weekToShow
        console.log "model"
        console.log model
        carbSerie.data.push(if model.get("carbs")==null then parseInt(0) else parseInt(model.get("carbs")))
        fatSerie.data.push(if model.get("fat")==null then parseInt(0) else parseInt(model.get("fat")))
        cholSerie.data.push(if model.get("cholesterol")==null then parseInt(0) else parseInt(model.get("cholesterol")))
        sodSerie.data.push(if model.get("sodium")==null then parseInt(0) else parseInt(model.get("sodium")))
        potSerie.data.push(if model.get("potassium")==null then parseInt(0) else parseInt(model.get("potassium")))
        calSerie.data.push(if model.get("calcium")==null then parseInt(0) else parseInt(model.get("calcium")))
        protSerie.data.push(if model.get("calcium")==null then parseInt(0) else parseInt(model.get("calcium")))
        vitaSerie.data.push(if model.get("calcium")==null then parseInt(0) else parseInt(model.get("calcium")))
        @nutrition_tracker_data.labels.push(moment(model.get("created")).format('ddd'))

      #Get chart scale.
      valuesRange = []
      for value in carbSerie.data
        valuesRange.push(value)
      for value in fatSerie.data
        valuesRange.push(value)
      for value in cholSerie.data
        valuesRange.push(value)
      for value in sodSerie.data
        valuesRange.push(value)    
      for value in potSerie.data
        valuesRange.push(value)    
      for value in calSerie.data
        valuesRange.push(value)    
      for value in protSerie.data
        valuesRange.push(value)    
      for value in vitaSerie.data
        valuesRange.push(value)    


      @options.scaleStepWidth = @getScaleCharts(valuesRange)

      @nutrition_tracker_datasets.datasets.push(carbSerie)
      @nutrition_tracker_datasets.datasets.push(fatSerie)
      @nutrition_tracker_datasets.datasets.push(cholSerie)
      @nutrition_tracker_datasets.datasets.push(sodSerie)
      @nutrition_tracker_datasets.datasets.push(potSerie)
      @nutrition_tracker_datasets.datasets.push(protSerie)
      @nutrition_tracker_datasets.datasets.push(calSerie)
      @nutrition_tracker_datasets.datasets.push(vitaSerie)



      #@nutrition_tracker_data.datasets=[
      #  @nutrition_tracker_datasets.datasets[0],
      #  @nutrition_tracker_datasets.datasets[1],
      #  @nutrition_tracker_datasets.datasets[2],
      #  @nutrition_tracker_datasets.datasets[3],
      #  @nutrition_tracker_datasets.datasets[4],
      #  @nutrition_tracker_datasets.datasets[5]
      #]   


    $("#rightNutritionChartContainer").empty()
    $("#rightNutritionChartContainer").append('<canvas id="nutritionTracker" width="429" height="270"></canvas>')
    @ctx = $("#nutritionTracker").get(0).getContext("2d");  
    @ctx.clearRect(0, 0, @ctx.width, @ctx.height);
    @nutritionTracker = new Chart(@ctx).Line(@getNutrientElementsToShow(), @options);  

  convertDataPerDateOnNutrition:(sorted)->


  convertDataPerDateOnProgress:(sorted)->

      daysMonth = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      for day,i in daysMonth
        daysMonth[i] = []

      for value,index in sorted
        console.log(value) 
        daysMonth[moment(value.get("created")).format('D')-1].push(value)

      valuesMonth = []  
      #get proms
      for value,index in daysMonth
         if value.length == 0
            dd = index + 1
            mm = moment().format('M')
            yy = moment().format('YYYY')
            data = 
              bmi: 0
              calfLeft: 0
              calfRight: 0
              chest: 0
              created: moment(dd + "/" + mm + "/" + yy,"DD/MM/YYYY").hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()
              date: moment(dd + "/" + mm + "/" + yy,"DD/MM/YYYY").hours(0).minutes(0).seconds(0).milliseconds(0).toISOString()
              forearmLeft: 0
              forearmRight: 0
              height: 0
              hips: 0
              neck: 0
              observations: 0
              photo: 0
              thighLeft: 0
              thighRight: 0
              title: 0
              upperArmLeft: 0
              upperArmRight: 0
              waist: 0
              weight: 0

            valuesMonth.push(data)

         else if value.length==1
            data = 
              bmi: value[0].get("bmi")
              calfLeft: value[0].get("calfLeft")
              calfRight: value[0].get("calfRight")
              chest: value[0].get("chest")
              created: value[0].get("created")
              date: value[0].get("date")
              forearmLeft: value[0].get("forearmLeft")
              forearmRight: value[0].get("forearmRight")
              height: value[0].get("height")
              hips: value[0].get("hips")
              neck: value[0].get("neck")
              observations: value[0].get("observations")
              photo: value[0].get("photo")
              thighLeft: value[0].get("thighLeft")
              thighRight: value[0].get("thighRight")
              title: value[0].get("title")
              upperArmLeft: value[0].get("upperArmLeft")
              upperArmRight: value[0].get("upperArmRight")
              waist: value[0].get("waist")
              weight: value[0].get("weight")

            valuesMonth.push(data)

         else 
            bmi=0
            calfRight=0 
            chest=0
            created=0
            date=0
            forearmLeft=0
            forearmRight=0
            height=0
            hips=0
            neck=0
            photo=0
            thighLeft=0
            thighRight=0
            upperArmLeft=0
            upperArmRight=0
            waist=0
            weight=0
            for valprom,index in value
                bmi = bmi + valprom.get("bmi")
                calfLeft = calfLeft + valprom.get("calfLeft")
                calfRight = calfRight + valprom.get("calfRight")
                chest = chest + valprom.get("chest")
                created = valprom.get("created")
                date = valprom.get("date")
                forearmLeft = forearmLeft + valprom.get("forearmLeft")
                forearmRight = forearmRight + value[0].get("forearmRight")
                height = height + value[0].get("height")
                hips = hips + value[0].get("hips")
                neck = neck + value[0].get("neck")
                thighLeft = thighLeft + value[0].get("thighLeft")
                thighRight = thighRight + value[0].get("thighRight")
                upperArmLeft = upperArmLeft + value[0].get("upperArmLeft")
                upperArmRight = upperArmRight + value[0].get("upperArmRight")
                waist = waist + value[0].get("waist")
                weight = weight + value[0].get("weight")

            ln = value.length  
            data= 
              bmi: bmi/ln
              calfLeft: calfLeft/ln
              calfRight: calfRight/ln
              chest: chest/ln
              created: created
              date: date
              forearmLeft: forearmLeft/ln
              forearmRight: forearmRight/ln
              height: height
              hips: hips/ln
              neck: neck/ln
              thighLeft: thighLeft/ln
              thighRight: thighRight/ln
              upperArmLeft: upperArmLeft/ln
              upperArmRight: upperArmRight/ln
              waist: waist/ln
              weight: weight/ln

            #console.log "data"
            #console.log data 
            valuesMonth.push(data)

           


      #console.log "valuesMonth lleno"
      #console.log valuesMonth
      return valuesMonth

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

      #Get chart scale.
      valuesRange = []
      for value in neckSerie.data
        valuesRange.push(value)
      for value in upperSerie.data
        valuesRange.push(value)
      for value in waistSerie.data
        valuesRange.push(value)
      for value in forearmLeftSerie.data
        valuesRange.push(value)    
      for value in thighLeftSerie.data
        valuesRange.push(value)    
      for value in calfLeftSerie.data
        valuesRange.push(value)    
      for value in chestSerie.data
        valuesRange.push(value)    
      for value in upperArmRightSerie.data
        valuesRange.push(value)    
      for value in upperArmRightSerie.data
        valuesRange.push(value)    
      for value in hipsSerie.data
        valuesRange.push(value)    
      for value in forearmRightSerie.data
        valuesRange.push(value)    
      for value in thighRightSerie.data
        valuesRange.push(value)
      for value in calfRightSerie.data
        valuesRange.push(value)
              
      @options.scaleStepWidth = @getScaleCharts(valuesRange)
          
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
    
    else if selectOption == "month"

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


      #Get chart scale.
      valuesRange = []
      for value in neckSerie.data
        valuesRange.push(value)
      for value in upperSerie.data
        valuesRange.push(value)
      for value in waistSerie.data
        valuesRange.push(value)
      for value in forearmLeftSerie.data
        valuesRange.push(value)    
      for value in thighLeftSerie.data
        valuesRange.push(value)    
      for value in calfLeftSerie.data
        valuesRange.push(value)    
      for value in chestSerie.data
        valuesRange.push(value)    
      for value in upperArmRightSerie.data
        valuesRange.push(value)    
      for value in upperArmRightSerie.data
        valuesRange.push(value)    
      for value in hipsSerie.data
        valuesRange.push(value)    
      for value in forearmRightSerie.data
        valuesRange.push(value)    
      for value in thighRightSerie.data
        valuesRange.push(value)
      for value in calfRightSerie.data
        valuesRange.push(value)
              
      @options.scaleStepWidth = @getScaleCharts(valuesRange)

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

    else 
     
      that = @  
      count = 0;
      
      sorted = @progressCollection.sortBy (m) -> 
       return m.get('date').getTime()


      monthData = @convertDataPerDateOnProgress(sorted)
      console.log monthData.length
      #console.log sorted
      #daysMonth = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
      #for day,i in daysMonth
      # daysMonth[i] = []

      #for progress,index in sorted
      # if parseInt(moment(model.get("created"),"YYYY-MM-DD").format('D')) == parseInt(currentMonth - 1)
        
      #Here we split the array in 4.
      weekOne = []
      weekTwo = []
      weekThree = []
      weekFour = [] 
    
      for progress,index in monthData
       if index <= 7
         weekOne.push(progress)
       if index > 7 && index <= 14
         weekTwo.push(progress)
       if index > 14 && index <= 21
         weekThree.push(progress)
       if index > 21 && index <= 31
         weekFour.push(progress)


      day = moment().format('D')
      console.log "weeks"
      console.log weekOne
      console.log weekTwo
      console.log weekThree
      console.log weekFour

      weekToShow = null
      if day <= 7
        weekToShow = weekOne
      if day > 7 && day <= 14
        weekToShow = weekTwo
      if day > 14 && day <= 21
        weekToShow = weekThree
      if day > 21 && day <= 31
        weekToShow = weekFour

      console.log weekToShow
      for pday,i in weekToShow
        neckSerie.data.push(parseInt(pday.neck))
        upperSerie.data.push(parseInt(pday.upperArmLeft))
        waistSerie.data.push(parseInt(pday.waist))
        forearmLeftSerie.data.push(parseInt(pday.forearmLeft))
        thighLeftSerie.data.push(parseInt(pday.thighLeft))
        calfLeftSerie.data.push(parseInt(pday.calfLeft))
        chestSerie.data.push(parseInt(pday.chest))
        upperArmRightSerie.data.push(parseInt(pday.upperArmRight))
        hipsSerie.data.push(parseInt(pday.hips))
        forearmRightSerie.data.push(parseInt(pday.forearmRight))
        thighRightSerie.data.push(parseInt(pday.thighRight))
        calfRightSerie.data.push(parseInt(pday.calfRight))
        @progress_tracker_data.labels.push(moment(pday.created).format('ddd'))

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

    #Get chart scale.
    valuesRange = []
    for value in neckSerie.data
      valuesRange.push(value)
    for value in upperSerie.data
      valuesRange.push(value)
    for value in waistSerie.data
      valuesRange.push(value)
    for value in forearmLeftSerie.data
      valuesRange.push(value)    
    for value in thighLeftSerie.data
      valuesRange.push(value)    
    for value in calfLeftSerie.data
      valuesRange.push(value)    
    for value in chestSerie.data
      valuesRange.push(value)    
    for value in upperArmRightSerie.data
      valuesRange.push(value)    
    for value in upperArmRightSerie.data
      valuesRange.push(value)    
    for value in hipsSerie.data
      valuesRange.push(value)    
    for value in forearmRightSerie.data
      valuesRange.push(value)    
    for value in thighRightSerie.data
      valuesRange.push(value)
    for value in calfRightSerie.data
      valuesRange.push(value)
            
    @options.scaleStepWidth = @getScaleCharts(valuesRange)
    
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

    
    $("#rightChartContainer").empty()
    $("#rightChartContainer").append('<canvas id="progressTracker" width="429" height="270"></canvas>')
    @ctx = $("#progressTracker").get(0).getContext("2d");  
    @ctx.clearRect(0, 0, @ctx.width, @ctx.height);
    @progressTracker = new Chart(@ctx).Line(@progress_tracker_data, @options);






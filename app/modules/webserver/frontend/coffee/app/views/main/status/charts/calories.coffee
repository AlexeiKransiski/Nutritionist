class App.Views.Main.Status.Charts.Calories extends Null.Views.Base
  template: JST['app/main/status/charts/calories.html']
  

  initialize: (options) =>
    super
    @charts = []
    @granularity = 'week'
    @user_id = options?.user_id || app.me.id

    unless options?.exercise_metrics
      @exercises_metrics = new App.Collections.Metrics()
    else
      @exercises_metrics = options.exercise_metrics

    unless options?.nutricional_metrics
      @nutricional_metrics = new App.Collections.Metrics()
    else
      @nutricional_metrics = options.nutricional_metrics

    @listenTo @exercises_metrics, 'sync', @refreshExerciseChart
    @listenTo @nutricional_metrics, 'sync', @refreshNutricionalChart

    return this

  render: =>
    super

    $('.flexslider', @$el).flexslider({
        animation: "slide",
        animationLoop: false,
        slideshow: false,
        controlNav: false,
        customDirectionNav: $(".custom-navigation a", @$el)
        after: @onSliderChange
        start: @onSliderChange
    })
    @refresh()
    return this


  # TODO: change the plugin to do the slide for the charts
  onSliderChange: (event) =>
    $slide = $('.flex-active-slide', @$el)
    $('[data-role="chart-caption"]', @$el).html($slide.data('caption'))
    $('[data-role="chart-legend"]', @$el).html($slide.data('legend'))
    return false;

  onGranularityChange: (event) =>
    @granularity = event.granularity
    @refresh()
    return

  refresh: () =>
    @exercises_metrics.fetch
      data: @getFilters('exercise')

    @nutricional_metrics.fetch
      data: @getFilters('food')
    return

  refreshExerciseChart: () =>
    @clearChart(@exercise_chart)
    @loadExerciseChart(@granularity)
    return

  refreshNutricionalChart: () =>
    @clearChart(@nutricional_chart)
    @loadNutricionChart(@granularity)
    return

  getFilters: (metric_type) =>
    switch @granularity
      when 'week'
        return @_getWeekFilters(metric_type)
      when 'month'
        return @_getMonthFilters(metric_type)
      when 'year'
        return @_getYearFilters(metric_type)
      else
        return false

  _getWeekFilters: (metric_type) =>
    filter =
      user: @user_id
      context: metric_type

    current = moment().day(0)
    last = moment().day(0).subtract(1, 'week')

    if current.month() == last.month()
      filter.year = current.year()
      filter.month = current.format('MM')
    else if current.year() == last.year()
      filter.year = current.year()
      filter.month =
        '$in': [last.format('MM'), current.format('MM')]
    else
      filter['$or'] = [
        {
          year: last.year()
          month: last.format('MM')
        },
        {
          year: current.year()
          month: current.format('MM')
        }
      ]

    return filter


  _getMonthFilters: (metric_type) =>
    filter =
      user: @user_id
      context: metric_type

    current = moment().date(1)
    last = moment().date(1).subtract(1, 'month')

    if last.year() == current.year()
      filter.year = current.year()
      filter.month =
        '$in': [last.format('MM'), current.format('MM')]
    else
      filter['$or'] = [
        {
          year: last.year()
          month: last.format('MM')
        },
        {
          year: current.year()
          month: current.format('MM')
        }
      ]

    return filter


  _getYearFilters: (metric_type) =>
    filter =
      context: metric_type

    current = moment()
    last = moment().subtract(1, 'year')

    filter.year =
      '$in': [last.year(), current.year()]

    return filter


  loadCharts: () =>
    # TODO: find a way to destroy and avoid the change of  width and height using Chart.destroy method
    @loadExerciseChart(@granularity)
    @loadNutricionChart(@granularity)

  getLabel: (granularity) =>
    labels =
      'week': @_getWeekLabels
      'month': @_getMonthLabels
      'year': @_getYearLabels

    return labels[granularity]()

  _getWeekLabels: () =>
    @setChartLegent moment().subtract(1, 'week').format('[Week] Wo'), moment().format('[Week] Wo')
    return (moment().day(number).format('dd') for number in [0..7])

  _getMonthLabels: () =>
    # (moment().date(number).format('D') for number in [1..31])
    month_start = moment().date(1)
    month_end = moment().endOf("month")
    weeks = month_end.diff month_start, 'weeks'

    @setChartLegent moment().subtract(1, 'month').format('MMM'), moment().format('MMM')
    return ( "week #{number}" for number in [1..weeks])

  _getYearLabels: () =>
    @setChartLegent moment().subtract(1, 'year').format('YYYY'), moment().format('YYYY')
    return (moment().month(number).format('MMM') for number in [0..11])

  setChartLegent: (last, current) =>
    $('[data-role=legend-last]', @$el).html(last)
    $('[data-role=legend-current]', @$el).html(current)

  loadExerciseChart: (granularity) =>
    @exercise_canvas = $('canvas[data-role=exercise-chart]', @$el)
    if @exercise_w and @exercise_h
      @exercise_chart.chart.canvas.width = @exercise_w
      @exercise_chart.chart.canvas.height = @exercise_h

    ctx = @exercise_canvas.get(0).getContext("2d")
    data = @getExerciseData(granularity)

    @exercise_chart = @loadLineChart(ctx, data)
    @exercise_w = @exercise_canvas.width() unless @exercise_w
    @exercise_h = @exercise_canvas.height() unless @exercise_h
    return

  loadNutricionChart: (granularity) =>
    @nutricional_canvas = $('canvas[data-role=nutricional-chart]', @$el)
    if @nutricional_w and @nutricional_h
      @nutricional_chart.chart.canvas.width = @nutricional_w
      @nutricional_chart.chart.canvas.height = @nutricional_h

    ctx = @nutricional_canvas.get(0).getContext("2d")
    data = @getNutricionalData(granularity)

    @nutricional_chart = @loadLineChart(ctx, data)
    @nutricional_w = @nutricional_canvas.width() unless @nutricional_w
    @nutricional_h = @nutricional_canvas.height() unless @nutricional_h

    return

  loadLineChart: (ctx, data) =>
    options =
      scaleShowGridLines: true
      scaleGridLineColor: 'rgba(0,0,0,.05)'
      scaleGridLineWidth: 1
      scaleShowHorizontalLines: true
      scaleShowVerticalLines: true
      bezierCurve: true
      bezierCurveTension: 0.4
      pointDot: true
      pointDotRadius: 4
      pointDotStrokeWidth: 1
      pointHitDetectionRadius: 20
      datasetStroke: true
      datasetStrokeWidth: 2
      datasetFill: true
      showTooltips: true,
      customTooltips: true
      multiTooltipTemplate: "<%= datasetLabel %>: <%= value %>"
      # tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= value %>"
      # legendTemplate: '<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<datasets.length; i++){%><li><span style="background-color:<%=datasets[i].strokeColor%>"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>'

    new_chart = new Chart(ctx).Line(data, options)
    return new_chart

  clearChart: (chart) =>
    chart.clear() if chart?
    chart.destroy() if chart?
    return

  getExerciseData: () =>
    switch @granularity
      when 'week'
        return @_getWeekData(@exercises_metrics, 'calories_burned')
      when 'month'
        return @_getMonthData(@exercises_metrics, 'calories_burned')
      when 'year'
        return @_getYearData(@exercises_metrics, 'calories_burned')
      else
        return false

  getNutricionalData: () =>
    switch @granularity
      when 'week'
        return @_getWeekData(@nutricional_metrics, 'calories')
      when 'month'
        return @_getMonthData(@nutricional_metrics, 'calories')
      when 'year'
        return @_getYearData(@nutricional_metrics, 'calories')
      else
        return false

  _getWeekData: (collection, key) =>
    current = collection.getWeekData(key, moment())
    last = collection.getWeekData(key, moment().subtract(1, 'week'))
    return @_setupDataSet(last, current)

  _getMonthData: (collection, key) =>
    current = collection.getMonthData(key, moment())
    last = collection.getMonthData(key, moment().subtract(1, 'month'))
    return @_setupDataSet(last, current)

  _getYearData: (collection, key) =>
    current = collection.getYearData(key, moment())
    last = collection.getYearData(key, moment().subtract(1, 'year'))
    return @_setupDataSet(last, current)

  _setupDataSet: (last, current) =>
    datasets = {
      labels: @getLabel(@granularity)
      datasets: [
        {
          label: "Last"
          fillColor: "rgba(220,220,220,0.2)",
          strokeColor: "rgba(220,220,220,1)",
          pointColor: "rgba(220,220,220,1)",
          pointStrokeColor: "#fff",
          pointHighlightFill: "#fff",
          pointHighlightStroke: "rgba(220,220,220,1)",
          data: last
        }
        {
          label: "Current",
          fillColor: "rgba(151,187,205,0.2)",
          strokeColor: "rgba(151,187,205,1)",
          pointColor: "rgba(151,187,205,1)",
          pointStrokeColor: "#fff",
          pointHighlightFill: "#fff",
          pointHighlightStroke: "rgba(151,187,205,1)",
          data: current
        }
      ]
    }
    return datasets

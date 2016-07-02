class App.Views.Main.Status.Charts.Details.Food extends Null.Views.Base
  template: JST['app/main/status/charts/details/food.html']

  initialize: (options) ->
    super
    @charts = []
    @granularity = 'week'
    @user_id = options?.user_id || app.me.id

    @metric_items_labels = {
      "vitamin_c": "Vitamin C",
      "vitamin_a": "Vitamin A"
      "trans": "Trans",
      "sugars": "Sugars",
      "sodium": "Sodium",
      "satured": "Satured",
      "protein": "Protein",
      "potassium": "Potassium",
      "polyunsaturated": "Polyunsaturated",
      "monounsaturated": "Monounsaturated",
      "iron": "Iron",
      "fat": "Fat",
      "dietary_fiber": "Dietary fiber",
      "cholesterol": "Cholesterol",
      "carbs": "Carbs",
      "calcium": "Calcium",
    }

    @metric_items = {
      "vitamin_c": 1
      "vitamin_a": 1
      "trans": 1
      "sugars": 1
      "sodium": 1
      "satured": 1
      "protein": 1
      "potassium": 1
      "polyunsaturated": 1
      "monounsaturated": 1
      "iron": 1
      "fat": 1
      "dietary_fiber": 1
      "cholesterol": 1
      "carbs": 1
      "calcium": 1
    }
    unless options?.nutricional_metrics
      @nutricional_metrics = new App.Collections.Metrics()
    else
      @nutricional_metrics = options.nutricional_metrics

    @listenTo @nutricional_metrics, 'sync', @refreshNutricionalChart

    @on 'item:checked', @onItemChecked
    @on 'item:unchecked', @onItemUnchecked
    return this

  render: =>
    super

    # $('form[data-role="chart-legend-items"]', @$el).mCustomScrollbar
    $('div.legends', @$el).mCustomScrollbar
      autoHideScrollbar: true
      advanced:
        updateOnContentResize: true,
        autoScrollOnFocus: false

    @loadLegend()
    @refresh()
    return this

  loadLegend: () =>
    _.each _.keys(@metric_items), @addLegend

  addLegend: (name) =>
    legend_item = new App.Views.Main.Status.Charts.Details.LegendItem({name: @metric_items_labels[name]})
    @appendView legend_item.render(), '[data-role="chart-legend-items"]'


  onGranularityChange: (event) =>
    @granularity = event.granularity
    @refresh()
    return

  refresh: () =>
    @nutricional_metrics.fetch
      data: @getFilters('food')
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

  loadNutricionChart: (granularity) =>
    @nutricional_canvas = $('canvas[data-role=nutricional-tracker-chart]', @$el)
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
      tooltipTitleFontSize: 12,
      tooltipFontSize: 11,
      multiTooltipTemplate: "<%if (datasetLabel){%><%=datasetLabel.toUpperCase() %>: <%}%><%= value %> (<%=  Config.units.nutritional[datasetLabel.toLowerCase()]  %>)"

    new_chart = new Chart(ctx).Line(data, options)
    return new_chart

  clearChart: (chart) =>
    chart.clear() if chart?
    chart.destroy() if chart?
    return

  getNutricionalData: () =>
    switch @granularity
      when 'week'
        return @_getWeekData(@nutricional_metrics)
      when 'month'
        return @_getMonthData(@nutricional_metrics)
      when 'year'
        return @_getYearData(@nutricional_metrics)
      else
        return false

  _getWeekData: (collection) =>
    current = {}
    for item, value of @metric_items
      current[item] = collection.getWeekData(item, moment()) if value

    return @_setupDataSet(current)

  _getMonthData: (collection) =>
    current = {}
    for item, value of @metric_items
      current[item] = collection.getMonthData(item, moment()) if value
    return @_setupDataSet(current)

  _getYearData: (collection) =>
    current = {}
    for item, value of @metric_items
      current[item] = collection.getYearData(item, moment()) if value

    return @_setupDataSet(current)

  _setupDataSet: (current) =>
    datasets = {
      labels: @getLabel(@granularity)
      datasets: []
    }
    if _.keys(current).length == 0
      data = (0 for num in [1..@getLabel(@granularity).length])
      name = "none"
      datasets.datasets.push @_setupLine(name, data)
    else
      for key, value of current
        datasets.datasets.push @_setupLine(key, value)

    return datasets

  _setupLine: (name, data) =>
    color = Helpers.colorful_language(name)
    line =
      label: name.toProperCase()
      fillColor: "hsla(#{color.hue},#{color.saturation}, #{color.lightness}, 0.3)",
      strokeColor: "hsla(#{color.hue},#{color.saturation}, #{color.lightness}, 1)",
      pointColor: "hsla(#{color.hue},#{color.saturation}, #{color.lightness}, 1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "hsla(#{color.hue},#{color.saturation}, #{color.lightness}, 1)",
      data: data

    return line


  onItemChecked: (event) =>
    @metric_items[event.view.name] = 1
    @refreshNutricionalChart()
    return

  onItemUnchecked: (event) =>
    @metric_items[event.view.name] = 0
    @refreshNutricionalChart()
    return

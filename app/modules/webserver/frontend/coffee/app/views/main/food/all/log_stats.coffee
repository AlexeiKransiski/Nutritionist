class App.Views.Main.Food.All.LogStats extends Null.Views.Base
  template: JST['app/main/food/all/log_stats.html']

  initialize: (options) =>
    super
    @dateSearch = options.dateSearch

    @model = new App.Models.FoodLogStat()
    @listenTo @model, 'change', @render

    @model.fetch
      data:
        current: 1

  events:
    'click .add-log': 'addFoodLog'

  render: () =>
    super
    $('#todayListDatesGlobal', @$el).datepicker({
      dateFormat: "M d, yy",
      showOn: "button",
      buttonImage: "img/new-big_calendar.png",
      numberOfMonths: 1,
      dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S','S'],
      maxDate: +0

    });

    $('#todayListDatesGlobal', @$el).datepicker('setDate', @dateSearch.toDate());

    return this

  getContext: =>
    return { model: @model}

  addFoodLog: (event) =>
    $button = $(event.target)
    meal_type = $button.data('role')
    @fire('add:food-log', meal_type)

  setKcals:(table,kcals)->
    $("[data-role=#{table}-kcal-logs]", @$el).html("#{kcals.toFixed(1)} kcals")

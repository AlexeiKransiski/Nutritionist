class App.Views.Main.Food.All.WaterTracker extends Null.Views.Base
  template: JST['app/main/food/all/water_tracker.html']

  that = @

  initialize: (options) =>
    super

    @dateSearch = options.dateSearch

    @model = new App.Models.WaterLog()
    @listenTo @model, 'change', @render

    @model.fetch
      data:
        current:1
        dateSelected: @dateSearch.toISOString()


  events:
    'click .more': 'onMore'
    'click .less': 'onLess'
    'change #todayListDatesGlobal': 'onChangeDate'

  render: () =>
    super
    $('.progress-bar', @$el).progressbar()
    $('[data-role=water-tracker]', @$el).html(Helpers.generateWaterTracker(app.me.get('water_recomended')))
    #$('#waterTrackerDate').datepicker({
    #  format: 'mm/dd/yyyy'
    #});

    #if @dateChanged == null
    #  dateSearch = moment().hour(0).minute(0).second(0)
    #  $('#waterTrackerDate').val(dateSearch.format("MM/DD/YYYY"));
    #else
    #  $('#waterTrackerDate').val(@dateChanged);


    @

  getContext: =>
    return { model: @model}

  onMore: (event) =>
    event.preventDefault()
    current_glasses = @model.get('glasses')
    return if Helpers.waterPercent(app.me.get('water_recomended'), @model.get('glasses')) >= 100
    @model.set('glasses', current_glasses + 1)
    @model.set('dateSelected',moment($("#todayListDatesGlobal",@el).val(),"MM/DD/YYYY").startOf('day'))
    @model.save()

  onLess: (event) =>
    event.preventDefault()
    current_glasses = @model.get('glasses')
    return if current_glasses == 0
    @model.set('glasses', current_glasses - 1)
    @model.set('dateSelected',moment($("#todayListDatesGlobal",@el).val(),"MM/DD/YYYY").startOf('day'))
    @model.save()

  onChangeDate:()->
    window.changeDate = true;
    @dateChanged = moment($("#todayListDatesGlobal",@el).val()).startOf('day').format("MM/DD/YYYY")
    @model.clear()
    @model.fetch
      data:
        dateSelected: @dateSearch.toISOString()
      #success:(data)->
      #  #console.log data
      #  if(data.id == undefined)
      #    that.model.set('glasses',0);

  getWaterLog:(dateStr)->
    @model.clear()
    @model.fetch
      data:
        dateSelected: @dateSearch.toISOString()

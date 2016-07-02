class App.Views.Main.Progress.Compare.Index extends Null.Views.Base
  template: JST['app/main/progress/compare/index.html']

  initialize: (options) =>
    super
    @beforeImage = null
    @afterImage = null

    @fetched = false
    @listenTo @collection, 'sync', @refresh
    @listenTo @collection, 'sort', @refresh

    return this

  events:
    'change #before': 'onBeforeDateChange'
    'change #current': 'onCurrentDateChange'
    'click [data-role="new-entry"]': 'onClickNewEntry'

  setupSubviews: () =>
    @images = new App.Views.Main.Progress.Compare.Images
      beforeImage: @beforeImage
      afterImage: @afterImage

    @images_data = new App.Views.Main.Progress.Compare.ImagesData
      beforeImage: @beforeImage
      afterImage: @afterImage

    @addView @images.render(), '[data-role=images]'
    @addView @images_data.render(), '[data-role=images-data]'

  render: () =>
    return this unless @fetched
    super
    return this

  getContext: () =>
    return {
      oldImage: @beforeImage
      actualImage: @afterImage
    }

  refresh: () =>
    @fetched = true
    if @collection.length > 1
      @beforeImage = @collection.at(1)
      @afterImage = @collection.at(0)
      @listenToOnce @beforeImage, 'change', @refresh
      @listenToOnce @afterImage, 'change', @refresh
    else if @collection.length == 1
      @beforeImage = @collection.at(0)
      @afterImage = null
      @listenToOnce @beforeImage, 'change', @refresh

    else
      @beforeImage = null
      @afterImage = null

    @render()
    @delegateEvents()
    @setupSubviews()

    $( "#before, #current", @$el).datepicker
        showOn: "button",
        buttonImage: "img/new-big_calendar.png",
        firstDay: 1,
        changeMonth: false,
        numberOfMonths: 1,
        dateFormat: 'dd/mm/yy',
        dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S','S'],
        beforeShowDay: (date) =>
          if @collection.findProgresForDate(date).length > 0
            return [true, '']
          else
            return [false, '']

        onSelect: (date, inst) =>
          if inst.id == "before"
            before_date =  moment(date, 'DD/MM/YYYY').toDate()
            $("#current", @$el).datepicker('option', 'minDate', before_date)
            @onBeforeDateChange(before_date)
          else
            current_date = moment(date, 'DD/MM/YYYY').toDate()
            $("#before", @$el).datepicker('option', 'maxDate', current_date)
            @onCurrentDateChange(current_date)

  onBeforeDateChange: (date) =>
    beforeImage = @collection.findProgresForDate(date)
    if beforeImage.length > 0
      @beforeImage = beforeImage[0]
      @images.beforeImage = @beforeImage
      @images_data.beforeImage = @beforeImage
      @subviewCall('render')

  onCurrentDateChange: (date) =>
    afterImage = @collection.findProgresForDate(date)
    if afterImage.length > 0
      @afterImage = afterImage[0]
      @images.afterImage = @afterImage
      @images_data.afterImage = @afterImage
      @subviewCall('render')

  onClickNewEntry: (event) =>
    event.preventDefault()
    @fire 'new:entry'

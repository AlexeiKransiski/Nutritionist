class App.Views.Main.Appointment.Timeline.Index extends Null.Views.Base
  template: JST['app/main/appointment/timeline/index.html']

  initialize: (options) =>
    super
    @collection = new App.Collections.Comments()

    @on 'new:question', @onAddQuestion
    @on 'show:rate', @onShowRate
    @on 'action:cancel', @addFooter
    @on 'rated', @addFooter
    return this

  render: () =>
    super
    @collection.reset(@model.get('replies'))
    @listenTo @collection, 'add', @addAll
    @addAll()

    return this

  addAll: () =>
    $('[data-role="messages"]', @$el).empty()
    @collection.each @addOne
    @addFooter()

  addOne: (item) =>
    item_view = new App.Views.Main.Appointment.Timeline.Comment({model: item})
    @appendView item_view.render(), '[data-role="messages"]'

  addFooter: () =>
    if @model.get('status') != 'completed' and @model.get('replies').length == 4
      @onShowRate()
      return
    footer = new App.Views.Main.Appointment.Timeline.Alert({model: @model})
    @addView footer.render(), '[data-role="footer"]'

  onAddQuestion: (event) =>
    footer = new App.Views.Main.Appointment.Timeline.Add({model: @model, collection: @collection})
    @addView footer.render(), '[data-role="footer"]'

  onShowRate: (event) =>
    footer = new App.Views.Main.Appointment.Timeline.Rate({model: @model, collection: @collection})
    @addView footer.render(), '[data-role="footer"]'

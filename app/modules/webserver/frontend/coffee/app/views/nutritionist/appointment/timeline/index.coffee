class App.Views.Nutritionist.Appointment.Timeline.Index extends Null.Views.Base
  template: JST['app/nutritionist/appointment/timeline/index.html']

  initialize: (options) =>
    super
    @collection = new App.Collections.Comments()
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
    item_view = new App.Views.Nutritionist.Appointment.Timeline.Comment({model: item})
    @appendView item_view.render(), '[data-role="messages"]'

  addFooter: () =>
    last = @collection.last()
    switch last.get('sender')
      when app.me.id
        footer = new App.Views.Nutritionist.Appointment.Timeline.Alert({model: @model})
      else
        footer = new App.Views.Nutritionist.Appointment.Timeline.Add({model: @model, collection: @collection})

    @appendView footer.render(), '[data-role="messages"]'

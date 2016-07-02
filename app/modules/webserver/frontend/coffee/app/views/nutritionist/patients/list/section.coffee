class App.Views.Nutritionist.Patients.List.Section extends Null.Views.Base
  template: JST['app/nutritionist/patients/list/section.html']
  tagName: 'div'

  initialize: (options) =>
    super
    @name = options.name
    @filter = options.filter
    @listenTo @collection, 'sync', @addAll
    return this

  render: () =>
    super
    return this

  getContext: () =>
    return {name: @name, total: @collection.length}

  addAll: () =>
    @subviewCall('removeAll')
    @collection.each @addOne

  addOne: (item) =>
    item_view = new App.Views.Nutritionist.Patients.List.Item({model: item})
    @appendView item_view.render(), @$el

  refresh: (search) =>
    _.extend @filter, search if search?

    @collection.fetch({data: @filter})

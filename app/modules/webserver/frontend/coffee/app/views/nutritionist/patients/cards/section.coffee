class App.Views.Nutritionist.Patients.Cards.Section extends Null.Views.Base
  template: JST['app/nutritionist/patients/cards/section.html']
  tagName: 'div'
  className: 'col-md-12'

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
    $('[data-role="total"]', @$el).html(@collection.length)

  addOne: (item) =>
    item_view = new App.Views.Nutritionist.Patients.Cards.Item({model: item})
    @appendView item_view.render(), '[data-role=results]'

  refresh: (search) =>
    _.extend @filter, search if search?

    @collection.fetch({data: @filter})

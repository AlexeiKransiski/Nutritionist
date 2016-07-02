class App.Views.Nutritionist.ClinicHistory.List extends Null.Views.Base
  template: JST['app/nutritionist/clinic_history/list.html']

  initialize: (options) =>
    super
    @listenTo @collection, 'sync', @addAll
    return this

  render: () =>
    super
    @$('.progress-bar', @el).progressbar()
    @addAll()
    return this

  addAll: () =>
    @collection.each @addOne

  addOne: (item) =>
    item_view = new App.Views.Nutritionist.ClinicHistory.Row({model: item})
    @appendView item_view.render(), '[data-role=results]'

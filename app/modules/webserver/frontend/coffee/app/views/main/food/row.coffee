class App.Views.Main.Food.Row extends Null.Views.Base
  template: JST['app/main/food/row.html']
  tagName: 'tr'

  @patientPreferences=null
  initialize: (options) =>
    super
    @patientPreferences = options.patientPreferences
    # @listenToOnce @patientPreferences, 'sync', @render
    @listenToOnce @model, "destroy", @onDestroy
    @render()
    return this

  events:
    'click .delete': 'deleteItem'

  render: () =>
    super
    @

  getContext: () =>
    return {
      model: @model,
      patientPreferences: @patientPreferences,
    }

  deleteItem: (event) =>
    event.preventDefault()
    @model.destroy()
    @fire 'cardio:calculate_calories'

  onDestroy: () =>
    @removeAll()
    #alert('item deleted')

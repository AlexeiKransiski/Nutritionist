class App.Views.Main.Exercises.AddExercise.Cart.Item extends Null.Views.Base
  template: JST['app/main/exercises/add_exercise/cart/item.html']
  tagName: 'li'

  initialize: (options) =>
    super
    console.log "Initialize  App.Views.Main.Exercises.AddExercise.Cart.Item"
    console.log @model
    @listenTo @model, 'remove', @onRemove

  events:
    'click [data-role=remove]': 'onRemoveBtn'

  render: () =>
    super

  getContext: =>
    return { model: @model }


  onRemoveBtn: (event) =>
    event.preventDefault() if event?.preventDefault?
    @fire 'list:calculate_total_calories_remove_list'
    @model.destroy()

  onRemove: (event) =>
    event.preventDefault() if event?.preventDefault?
    @removeAll()

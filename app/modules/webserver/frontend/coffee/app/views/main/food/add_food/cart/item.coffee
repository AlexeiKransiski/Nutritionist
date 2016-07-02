class App.Views.Main.Food.AddFood.Cart.Item extends Null.Views.Base
  template: JST['app/main/food/add_food/cart/item.html']
  tagName: 'li'

  initialize: (options) =>
    super

    @listenTo @model, 'remove', @onRemove

  events:
    'click [data-role=remove]': 'onRemove'

  render: () =>
    super

  getContext: =>
    return { model: @model }

  onRemove: (event) =>
    event.preventDefault() if event?.preventDefault?
    @model.destroy()
    @removeAll()

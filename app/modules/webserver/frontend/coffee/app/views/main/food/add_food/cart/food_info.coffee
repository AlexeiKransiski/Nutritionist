class App.Views.Main.Food.AddFood.Cart.FoodInfo extends Null.Views.Base
  template: JST['app/main/food/add_food/cart/food_info.html']

  initialize: (options) =>
    super

    @render()

  render: () =>
    super
    $('.progress-bar', @$el).progressbar()

    @

  getContext: =>
    return { model: @model}

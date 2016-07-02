class App.Views.Main.Food.AddFood.Search.RecipeItem extends Null.Views.Base
  template: JST['app/main/food/add_food/search/recipe_item.html']
  tagName: 'li'
  className: 'space'

  initialize: (options) =>
    super

  render: () =>
    super

  getContext: =>
    return { model: @model }

  onViewListItems: (event) =>
    event.preventDefault()
    @fire 'servings:add'

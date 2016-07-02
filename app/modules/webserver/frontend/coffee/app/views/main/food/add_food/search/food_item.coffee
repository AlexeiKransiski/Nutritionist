class App.Views.Main.Food.AddFood.Search.FoodItem extends Null.Views.Base
  template: JST['app/main/food/add_food/search/food_item.html']
  tagName: 'li'

  initialize: (options) =>
    super

  events:
    'click [data-role=add-servings]': 'onAddServings'
    'ifChecked .ratings input': 'onChecked'
    'ifUnchecked .ratings input': 'onUnhecked'

  render: () =>
    super

  onChecked: ->
    favorite = new App.Models.Favorite(type: 'food', object: @model.id)
    @options.favorites.create favorite, wait: true

  onUnhecked: ->
    list = @options.favorites.where object: @model.id
    that = this
    list.forEach (object) ->
      object.destroy
        success: ->
          that.options.favorites.remove(object)

  getContext: =>
    return { model: @model, recent: @options.recent, favorites: @options.favorites.pluck 'object' }

  onAddServings: (event) =>
    event.preventDefault()
    @fire 'servings:add'

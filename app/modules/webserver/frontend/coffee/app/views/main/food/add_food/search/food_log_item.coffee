class App.Views.Main.Food.AddFood.Search.FoodLogItem extends Null.Views.Base
  template: JST['app/main/food/add_food/search/food_log_item.html']
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
    favorite = new App.Models.Favorite(type: 'food', object: @model.get('food'))
    @options.favorites.create favorite, wait: true

  onUnhecked: ->
    list = @options.favorites.where object: @model.get('food')
    that = this
    list.forEach (object) ->
      object.destroy(
        success: ->
          that.options.favorites.remove(object)
      )

  getContext: =>
    return { model: @model, favorites: @options.favorites.pluck 'object' }

  onAddServings: (event) =>
    # no need to show servings bc using the same of last time
    event.preventDefault()
    data = @model.toJSON()
    delete data._id
    delete data.created
    food_log = new App.Models.FoodLog(data)
    @fire 'cart:add', food_log

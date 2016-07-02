class App.Views.Main.Food.AddFood.TodayFood.Index extends Null.Views.Base
  template: JST['app/main/food/add_food/today_food/index.html']

  @favsTodayList= null

  initialize: (options) =>
    super

    @favoriteType = 'food'

    @myFavorites = new App.Collections.Favorites()

    @myFavorites.fetch
      data:
        type: @favoriteType

    @foodLog = new App.Collections.FoodLog()
    @foodLog.fetch({data:{"user":app.me.id,"created":new Date().toJSON().slice(0,10)}})

    @listenTo @foodLog, "sync", @getFoods


  render: () =>
    super


  getFoods: ()=>
    that = @
    @myFavorites.fetch
      data:
        type: @favoriteType
      success:(favs)->
        that.favsTodayList= favs
        that.foodLog.each that.clasifyFood

    

class App.Views.Main.Food.AddFood.Search.Index extends Null.Views.Base
  template: JST['app/main/food/add_food/search/index.html']
  className: 'box_search'

  options:
    meal_type: ''
    tab: 'search'

  initialize: (options) =>
    super

    @favoriteType = 'food'
    limit = 2
    offset = 0
    @filters =
      search:
        limit: limit
        offset: offset
        '$or': [
          {
            type: 'generic'
          },
          {
            type: 'user'
            user: app.me.id
          }
        ]
      #  name: ''

      #search:
      #  user: app.me.id

      recent:
        limit: limit
        offset: offset
        user: app.me.id
        distinct: 1

      favorites:
        limit: limit
        offset: offset
        _id:
          '$in': [app.me.id]
        #name: ''

      list:
        limit: limit
        offset: offset
        user: app.me.id
        #name: ''

      # Recipes search is implemented at inicial state but
      # have to done for phase 2
      recipes:
        user: app.me.id
        name: ''

    @food_search = new App.Collections.Food()
    @recent = new App.Collections.FoodLog()
    @favorites = new App.Collections.Food()
    @my_lists = new App.Collections.FoodLists()
    @my_recipes = new App.Collections.FoodRecipes()
    @myFavorites = new App.Collections.Favorites()

    @tabs =
      search:
        collection: @food_search
        item_class: App.Views.Main.Food.AddFood.Search.FoodItem
        element: '[data-role=search-results]'
        mode: 'search'
      recent:
        collection: @recent
        item_class: App.Views.Main.Food.AddFood.Search.FoodLogItem
        element: '[data-role=recent-results]'
        recent:true
        mode: 'search'
      favorites:
        collection: @favorites
        item_class: App.Views.Main.Food.AddFood.Search.FoodItem
        element: '[data-role=favorites-results]'
        isFavorites: true
        mode: 'search'
      list:
        collection: @my_lists
        item_class: App.Views.Main.Food.AddFood.Search.ListItem
        element: '[data-role=list-results]'
        mode: 'search'
      recipes:
        collection: @my_recipes
        item_class: App.Views.Main.Food.AddFood.Search.RecipeItem
        element: '[data-role=recipes-results]'
        mode: 'search'

    @listenTo @food_search, 'sync', @addAll
    @listenTo @recent, 'sync', @addAll
    @listenTo @favorites, 'sync', @addAll
    @listenTo @my_lists, 'sync', @addAll
    @listenTo @my_recipes, 'sync', @addAll
    @listenTo @myFavorites, 'sync', @addAll
    # @listenTo @myFavorites, 'remove', @updateAll

    @on 'servings:add', @onAddServings
    @on 'cart:add', @onAddToCart
    @on 'list:confirm_delete', @onConfirmDelete
    @on 'list:delete_current_list', @onDeleteCurrentList
    @on 'food:add', @onAddFood

    #@tabs['search'].collection.fetch
    #  data:
    #    @filters.search

    @myFavorites.fetch
      data:
        type: @favoriteType
        owner: app.me.id
    @

  events:
    'shown.bs.tab [data-toggle=tab]': 'onTabChange'
    # 'keyup #optsearch': 'onSearchKeyUp'
    'click #search':'onSearchClick'
    'click #searchRecently':'onSearchClick'
    'click #searchFavorites':'onSearchClick'
    'click #searchList':'onSearchClick'
    'submit [ data-role=search-form]': 'preventSubmit'
    'click [data-role=recent]': 'onRecentTab'
    'click [data-role=new-food]': 'onNewFood'
    'click [data-role="load-more-search"]': 'onLoadMore'
    'click [data-role="load-more-recent"]': 'onLoadMore'
    'click [data-role="load-more-favorites"]': 'onLoadMore'
    'click [data-role="load-more-list"]': 'onLoadMore'

  render: () =>
    super
    $(".result", @$el).mCustomScrollbar(
      autoHideScrollbar:true,
      live: true
      advanced:
        updateOnContentResize: true
        autoScrollOnFocus: false
    )
    @

  updateAll: ->
    # if is favorite just request favorite food, not all
    @delay_search = setTimeout(() =>
      if @options.tab == 'search'
        return
      @tabs[@options.tab].collection.reset()
      if @tabs[@options.tab].isFavorites
        favs = _this.myFavorites.pluck('object')
        if favs.length > 0
          @tabs[@options.tab].collection.fetch
            data:
              _id:
                $in: favs
        else
          @tabs[@options.tab].collection.trigger 'sync'
      else
        @tabs[@options.tab].collection.fetch()
    , 200)

  reloadFoodSearch: ()=>
    console.log @options.tab
    if @options.tab == 'recent'
      $(@tabs[@options.tab].element, @$el).parents('.result').block()
      @tabs[@options.tab].collection.fetch
        data:
          @filters[@options.tab]

  addAll: () =>
    $(@tabs[@options.tab].element, @$el).parents('.result').unblock()

    if @tabs[@options.tab].mode == 'search'
      $(@tabs[@options.tab].element, @$el).html('')

    if @tabs[@options.tab].collection.length
      $(".empty.#{@options.tab}", @$el).addClass('hide')
      $(".list-unstyled.#{@options.tab}", @$el).removeClass('hide')
    else if @tabs[@options.tab].mode == 'search'
      $(".empty.#{@options.tab}", @$el).removeClass('hide')
      $(".list-unstyled.#{@options.tab}", @$el).addClass('hide')
      return

    if @tabs[@options.tab].collection.length < @filters[@options.tab].limit
      $('.load-more', $(@tabs[@options.tab].element).parent()).hide()
    else
      $('.load-more', $(@tabs[@options.tab].element).parent()).show()

    @tabs[@options.tab].collection.each @addOne

    # render the start icon instead of checkbox
    $('.ratings input', @$el).iCheck({
      checkboxClass: 'icheckbox_futurico'
    })

  addOne: (item) =>
    item_view = null
    if @tabs[@options.tab].recent==true
      item_view = new @tabs[@options.tab].item_class({model: item, recent:true, favorites: @myFavorites})
    else
      item_view = new @tabs[@options.tab].item_class({model: item, recent:false, favorites: @myFavorites})

    @appendView item_view.render(), @tabs[@options.tab].element

  onLoadMore: (event) =>
    event.preventDefault()
    $btn = $(event.target)
    input = $btn.parents('form').find('#optsearch')[0]
    query = $(input).val()

    @tabs[@options.tab].mode = 'load_more'
    @filters[@options.tab].offset += @filters[@options.tab].limit
    @loadResult(query)

    return

  # events
  onSearchClick: (event) =>
    event.preventDefault()
    $btn = $(event.target)
    input = $btn.parents('form').find('#optsearch')[0]
    query = $(input).val()
    if query == ''
      return

    @tabs[@options.tab].mode = 'search'
    @filters[@options.tab].offset = 0

    @loadResult(query)
    return
      
  loadResult: (query) =>
    clearTimeout(@delay_search)
    
    filter = @filters[@options.tab]
    if query != ''
      filter.name = query

    $(@tabs[@options.tab].element, @$el).parents('.result').block()

    @delay_search = setTimeout(() =>
      @tabs[@options.tab].collection.reset()
      
      if @tabs[@options.tab].isFavorites
        favs = _this.myFavorites.pluck('object')
        if favs.length > 0
          filter._id['$in'] = favs
          @tabs[@options.tab].collection.fetch
            data:
              filter
        else
          @tabs[@options.tab].collection.trigger 'sync'
      else
        @tabs[@options.tab].collection.fetch
          data:
            filter


    , 200)

  onTabChange: (event) =>
    $a = $(event.target)
    @options.tab = $a.data('role')
    if $a.data('role') == 'list'
      $('.newList').show()
    else
      $('.newList').hide()

    if $a.data('role') != 'search'
      $(@tabs[@options.tab].element, @$el).parents('.result').block()
      @tabs[@options.tab].mode = 'search'
      @filters[@options.tab].offset = 0

    filter = @filters[@options.tab]

    if $a.data('role') == 'favorites'
      @delay_search = setTimeout(() =>
        favs = _this.myFavorites.pluck('object')
        if favs.length > 0
          filter._id['$in'] = favs
          @tabs[@options.tab].collection.fetch
            data:
              filter
        else
          @tabs[@options.tab].collection.trigger 'sync'
      , 200)

    if $a.data('role') in ['recent', 'list']
      @tabs[@options.tab].collection.fetch
          data:
            filter


  # fired by an item element
  onAddServings: (event) =>
    @add_serving.removeAll() if @add_serving?
    @add_serving = new App.Views.Main.Food.AddFood.Search.AddServings({model: event.view.model,recent:event.view.options.recent})
    @appendAfterView @add_serving.render(), event.view.$el

  onAddToCart: (event, food_log) =>
    food_log.set "meal_type", @options.meal_type
    @collection.add food_log

  onConfirmDelete: (event) =>
    modal = new App.Views.Common.DeleteConfirmation(model: event.view.model)
    @appendView modal.render(), $("[data-role=modal-container]")

    return

  onNewFood: (event) =>
    event.preventDefault()
    @fire 'food:new'

  onDeleteCurrentList: (event,current) =>
     @fire 'list:delete_current_list2', current

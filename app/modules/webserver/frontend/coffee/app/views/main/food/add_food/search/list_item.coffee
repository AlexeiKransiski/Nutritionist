class App.Views.Main.Food.AddFood.Search.ListItem extends Null.Views.Base
  template: JST['app/main/food/add_food/search/list_item.html']
  tagName: 'li'
  className: 'space'

  initialize: (options) =>
    super
    @listenToOnce @model, "destroy", @onDestroy

    @

  events:
    'click [data-role=view-list]': 'onViewListItems'
    'click [data-role=remove]': 'onRemoveList'

  render: () =>
    super

  getContext: =>
    return { model: @model }

  onViewListItems: (event) =>
    event.preventDefault()
    @fire 'list:view'

  onRemoveList: (event) =>
    event.preventDefault()
    @fire 'list:confirm_delete'

  onDestroy: () =>
    @$el.fadeOut 'slow', () =>
      @removeAll()

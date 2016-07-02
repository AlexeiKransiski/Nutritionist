class App.Views.Main.Exercises.Widgets.ExerciseListItem extends Null.Views.Base 
  template: JST['app/main/exercises/widgets/search/list.html']
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
    @fire 'list:calculate_total_calories'

  onRemoveList: (event) =>
    event.preventDefault()
    @fire 'list:confirm_delete'

  onDestroy: () =>
    @$el.slideUp 'slow', () =>
      @removeAll()
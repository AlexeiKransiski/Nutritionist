class Null.Views.BasePage extends Null.Views.Base
  template: null

  render: () =>
    ###
    its not intended to be a view
    just have a container of views to be load
    ###
    return @


  removeAll: () =>
    @remove()

  remove: () =>
    @stopListening()
    @undelegateEvents()
    @unbind()
    @__appendedViews.call('remove')

  #
  addView: (view, destination = '') =>
    $destination = @__detectDestination destination
    @__appendedViews.add view
    view._parent = @
    view.$el = $destination
    view.render()

    if $('body').find($destination).length
      view.trigger 'ready', view
      view.rendered = yes
    else
      @on 'ready', =>
        view.trigger 'ready', view
        view.rendered = yes

    view.on 'remove', =>
      index =  _.indexOf @__appendedViews, view
      if index > -1
        @__appendedViews.splice index, 1
    @

  __detectDestination: (destination) =>
    destination or= ''
    if destination instanceof jQuery
      $destination = destination
    else
      $destination = if destination and $(destination).length > 0 then $(destination) else $('body')
    $destination

class Null.Routers.Base extends Backbone.Router
  # page_class is view class containing the left, tob bar items
  # that are not parte of the "main" but needed on that router
  @page_class: null

  initialize: (options) =>
    @bind "all", @_change, @
    app.setupPage @page_class if @page_class

  execute: (cb, args) =>
    app.current_view.remove() if app.current_view?
    cb(args)

  deselectNav: () =>
    $("*[data-href]").removeClass('opened')
    $("*[data-href]").removeClass('active')

  selectNav: (href) =>
    @deselectNav()
    $("*[data-href='#{href}']").addClass('active')

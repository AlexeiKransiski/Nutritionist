class App.Views.Main.LeftBar extends Null.Views.Base
  template: JST['app/main/left_bar.html']

  initialize: (opt) =>
    super
    # load admin menu

    # @users_item = new App.Views.Common.Helpers.LeftBar.Item
    #   icon: 'icon-users'
    #   text: 'Users'
    #   a_type: 'route'
    #   a_href: '/'
    #   route: ''

    @

  render: () =>
    super
    # app.authorization.isAuthorized("User:read", app.me.toJSON(), {}, (result) =>
    #   console.log "autho resul: ", result
    #   if result and result?.result
    #     @prependView @customers_item.render(), '[data-role=menu]'
    # )
    #@appendView @users_item.render(), '[data-role=menu]'
    # @appendView @devices_item.render(), '[data-role=menu]'

    @

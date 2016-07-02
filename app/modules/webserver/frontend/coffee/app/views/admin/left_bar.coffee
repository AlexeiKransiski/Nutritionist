class App.Views.Admin.LeftBar extends Null.Views.Base
  template: JST['app/admin/left_bar.html']

  initialize: (opt) =>
    super
    # load admin menu
    @customers_item = new App.Views.Common.Helpers.LeftBar.Item
      icon: 'fa fa-hospital-o'
      text: 'Customers'
      a_type: 'route'
      a_href: '/customers'
      route: 'customers'

    @users_item = new App.Views.Common.Helpers.LeftBar.Item
      icon: 'icon-users'
      text: 'Users'
      a_type: 'route'
      a_href: '/'
      route: ''

    @devices_item = new App.Views.Common.Helpers.LeftBar.Item
      icon: 'icon-eyeglasses'
      text: 'Devices'
      a_type: 'route'
      a_href: '/devices'
      route: 'devices'

    @

  render: () =>
    super
    # app.authorization.isAuthorized("User:create", app.me.toJSON(), {}, (result) =>
    #   console.log "autho resul: ", result
    #   if result and result?.result
    #     @prependView @customers_item.render(), '[data-role=menu]'
    # )
    @appendView @users_item.render(), '[data-role=menu]'
    @appendView @devices_item.render(), '[data-role=menu]'

    @

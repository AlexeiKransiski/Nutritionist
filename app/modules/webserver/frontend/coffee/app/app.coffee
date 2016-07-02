class App.Initialize
  debug: 0 # debug levels
  environment: 'development' # development | production

  constructor: (options) ->
    @routes = []
    _.extend @, options
    _.extend @, Backbone.Events

  init: =>
    unless $.cookies.get('user_id')? and $.cookies.get('auth_token')?
      window.location = "/logout"

    # Initialize main models
    @user = new App.Models.User()

    @users = new App.Collections.Users
    @users.push @user
    @user.fetch({
      success: (model) =>
        @onLoad()
      error: (model,err ) =>
        alert('Error loading user infomation. Login again please')
        window.location = "/logout"
    })

  onLoad: =>
    # load authorization
    @authorization = new Null.Authorization.Index()
    @authorization.use(new Null.Authorization.Adapters.JSONAdapter(authorization_object))
    # load meModel
    user = @user.toJSON()
    mock_user = {}
    _.extend user, mock_user

    @me = new App.Models.Me(user)

    @authorization.loadSubjectPermissions(app.me.toJSON(), (res) =>
      @me.set {
        permissions: res.permissions
        permissions_compiled: res.compiled
      }
    )

    @me_info = new App.Views.Common.Me.Info({el: '[data-role="me-info"]',model: @me})

    # Setup routers
    @routers = []
    @routers.push new App.Routers.Common

    # we will force to fill the profile before any action
    unless @me.get('is_nutritionist')
      if @me.get('profileFilled')
        switch window.rootBase
          when "/test-api"
            @routers.push new App.Routers.TestApi()
          when "/admin"
            @routers.push new App.Routers.Admin()
          else
            @routers.push new App.Routers.Main()
      else
        @routers.push new App.Routers.Signup()
    else
      console.log "ITS NTRUTIONISTS"
      @routers.push new App.Routers.Nutritionist()

    # evetns
    @events = new App.Events.Events()

    @onLoaded()

  onLoaded: =>
    Backbone.history.start({pushState: false, root: window.rootBase})

    # update navigation
    $('#nav-user').text(@me.get('full_name'))


  loadXMPP: () =>
    # replace toke 123 for the aut_token when the prosody allowto auth with bearer token
    token = (if $.cookies.get('auth_token') then "#{$.cookies.get('auth_token')}" else "123")
    @xmpp = new App.XMPP.Client()

  loadPage: (view_class, options) =>
    app.current_view.remove() if app.current_view?
    app.current_view = new view_class options
    app.current_view.render()

  setupPage: (view_class, options) =>
    app.current_page.remove() if app.current_page
    app.current_page = new view_class options
    app.current_page.render()

$(document).ready ->
  window.app = new App.Initialize
    debug: 3
    environment: 'development'

  app.init()

  $('.menu-mobile li a').click (event) =>
    $('#bs-example-navbar-collapse-1').removeClass('in')
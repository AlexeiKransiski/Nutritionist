class App.Routers.Common extends Null.Routers.Base
  routes:
    'logout': 'logout',

  logout: =>
    console.log "LOGOUT"
    $.ajax({
      url: '/api/v1/logout'
      type: 'get'
      contentType: 'json'
      success: (data) ->
        $.cookies.del 'auth_token'
        $.cookies.del 'user'
        window.location = "/"

      error: (xhr, error) ->
        if xhr.status == 200
          $.cookies.del 'auth_token'
          $.cookies.del 'user'

          window.location = "/"
          return
        console.log "Logoute error: ", xhr, error
        alert('Error on logout')
    })

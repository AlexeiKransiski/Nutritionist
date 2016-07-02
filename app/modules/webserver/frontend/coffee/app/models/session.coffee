class App.Models.Session extends Null.Models.Base
  urlRoot: '/api/v1/auth/local'
  parse: (data) =>
    $.cookies.set('auth_token', data.token)

class App.Models.Favorite extends Null.Models.Base
  urlRoot: '/api/v1/favorite'

  parse: (response, options) ->
    response.createdAt = new Date(response.createdAt)
    return response

class App.Models.Progress extends Null.Models.Base
  urlRoot: '/api/v1/progress'
  defaults:
    weight: 0
  parse: (response, options) ->
    response.date = new Date(response.date)
    return response

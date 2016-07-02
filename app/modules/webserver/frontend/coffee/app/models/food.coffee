class App.Models.Food extends Null.Models.Base
  urlRoot: '/api/v1/food'

  totalFat: ->
    total = Number(@get('satured')) + Number(@get('polyunsaturated')) + Number(@get('monounsaturated')) + Number(@get('trans'))
    return if isNaN(total) then 0 else total

  totalCarbs: ->
    total = Number(@get('dietary_fiber')) + Number(@get('sugars'))
    return if isNaN(total) then 0 else total

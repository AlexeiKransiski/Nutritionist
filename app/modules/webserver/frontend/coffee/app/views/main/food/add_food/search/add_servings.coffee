class App.Views.Main.Food.AddFood.Search.AddServings extends Null.Views.Base
  template: JST['app/main/food/add_food/search/add_servings.html']
  tagName: 'li'
  className: 'active'

  initialize: (options) =>
    super

  events:
    'click [data-role=add-cart]': 'onAddCart'
    'click [data-role=cancel]': 'onCancel'

  render: () =>
    super
    #$('.bfh-selectbox', @$el).bfhselectbox('toggle')

    $('.bfh-selectbox', @$el).bfhselectbox({
      value: @model.get('serving_types')[0].factor
    })

    @

  getContext: =>
    return { model: @model, recent: @options.recent}

  getGrsPerServing:(servings,servingsType,nutrient)=>
   gr = parseFloat(servings) * parseFloat(servingsType) * parseFloat(nutrient)
   return parseFloat(gr).toFixed(1)

  onAddCart: (event) =>
    event.preventDefault()
    console.log "ADD To CART"
    servings = $('#servings', @$el).val()
    servingsType = $('#servingsType', @$el).val()
    servings = 1 if servings == ""

    data =
      food: @model.id
      food_detail: @model.toJSON()
      name: @model.get('name')

      carbs: @getGrsPerServing(servings,servingsType,@model.get('carbs')),
      fat: @getGrsPerServing(servings,servingsType,@model.get('fat')),
      protein: @getGrsPerServing(servings,servingsType,@model.get('protein')),
      cholesterol: @getGrsPerServing(servings,servingsType,@model.get('cholesterol')),
      sodium: @getGrsPerServing(servings,servingsType,@model.get('sodium')),
      potassium: @getGrsPerServing(servings,servingsType,@model.get('potassium')),
      calories: @getGrsPerServing(servings,servingsType,@model.get('calories')),
      satured: @getGrsPerServing(servings,servingsType,@model.get('satured')),
      polyunsaturated: @getGrsPerServing(servings,servingsType,@model.get('polyunsaturated')),
      dietary_fiber: @getGrsPerServing(servings,servingsType,@model.get('dietary_fiber')),
      monounsaturated: @getGrsPerServing(servings,servingsType,@model.get('monounsaturated')),
      sugars: @getGrsPerServing(servings,servingsType,@model.get('sugars')),
      trans: @getGrsPerServing(servings,servingsType,@model.get('trans')),
      vitamin_a: @getGrsPerServing(servings,servingsType,@model.get('vitamin_a')),
      vitamin_c: @getGrsPerServing(servings,servingsType,@model.get('vitamin_c')),
      calcium: @getGrsPerServing(servings,servingsType,@model.get('calcium')),
      iron: @getGrsPerServing(servings,servingsType,@model.get('iron')),

      servings: servings
      serving_type: _.find(@model.get('serving_types'), (item) => return parseInt(item.factor) == parseInt(servingsType)).name
      serving_factor: servingsType

    food_log = new App.Models.FoodLog(data)
    @fire 'cart:add', food_log
    @removeAll()

  onCancel: (event) =>
    event.preventDefault()
    @fire 'servings:cancel'
    @removeAll()

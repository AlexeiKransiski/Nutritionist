class App.Views.TestApi.Food.Form extends Null.Views.Base
  template: JST['app/test_api/food/form.html']

  form: '.food-form'

  permission: 'Food:create'
  initialize: (options) =>
    super

  events:
    'submit .food-form': 'saveModel'

  render: () =>
    super
    @

  saveModel: (e) ->
    e.preventDefault()

    data = @getFormInputs $(@form)

    item =
      "name": data.name,

    console.log "Item data: ", item
    @collection.create item, {
      success: (model, response) =>
        console.log "Created", model, response
      error: (model, response) =>
        console.log "ERror", model, response
      wait: true

    }

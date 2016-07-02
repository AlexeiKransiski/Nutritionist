class App.Views.Main.Settings.Fitness extends App.Views.Base
  template: JST['app/main/settings/goals/fitness.html']
  className: 'rest_boxes advances'

  options:
    active: false

  that=null

  initialize: (options) =>
    super
    that=@

    @listenToOnce @model, "sync", @render
    @listenTo @model, "change", @render

    @

  events:
    'click #editFitness2': 'onEditFitness2'
    'click #saveFitness': 'onSaveFitness2'
    'change .fatval':'onChangeFatValues'
    'change .carbsval':'onChangeCarbValues'

  getContext: =>
    return {
      model: @model
    }

  render: () =>
    super
    # $("#fitness").empty()

    @

  onChangeFatValues:()=>
    satured=parseFloat($("#saturated").val()).toFixed(1)
    polyunsaturated=parseFloat($("#polyunsaturated").val()).toFixed(1)
    monounsaturated=parseFloat($("#monounsaturated").val()).toFixed(1)
    trans=parseFloat($("#trans").val()).toFixed(1)
    $("#total_fat").val(parseFloat(parseFloat(satured) + parseFloat(polyunsaturated) + parseFloat(monounsaturated) + parseFloat(trans)))

  onChangeCarbValues:()=>
    dietary_fiber=parseFloat($("#dietary_fiber").val()).toFixed(1)
    sugars=parseFloat($("#sugars").val()).toFixed(1)
    $("#total_carbs").val(parseFloat(parseFloat(dietary_fiber) + parseFloat(sugars)))

  onEditFitness2:() =>
    event.preventDefault()
    $('.saved_fitness' , @$el).fadeOut 'slow', =>
      $('.edit_fitness' , @$el).fadeIn 'slow'
      $('#editFitness2', @$el).fadeOut 'slow', =>
        $('.edit_fitness_button' , @$el).fadeIn 'slow'

  onSaveFitness2:() =>
    event.preventDefault()
    fitness_goals=
      calories:$("#calories").val()
      carbs: $("#total_carbs").val(),
      fat: $("#total_fat").val(),
      protein: $("#protein").val(),
      cholesterol: $("#cholesterol").val(),
      sodium: $("#sodium").val(),
      potassium: $("#potassium").val(),
      calories: $("#calories").val(),
      satured: $("#saturated").val(),
      polyunsaturated: $("#polyunsaturated").val(),
      dietary_fiber: $("#dietary_fiber").val(),
      monounsaturated: $("#monounsaturated").val(),
      sugars: $("#sugars").val(),
      trans: $("#trans").val(),
      vitamin_a: $("#vitamin_a").val(),
      vitamin_c: $("#vitamin_c").val(),
      calcium: $("#calcium").val(),
      iron: $("#iron").val()

    @$el.block()
    app.me.save({calories_recomended: fitness_goals.calories},{
      success: (model, res) =>
        @model.save({"fitness_goals": fitness_goals},{
          success: (model, response) =>
            @$el.unblock()
            app.me.set('patient_preferences', model.toJSON())
            alert('This change require a page reload.')
            location.reload()
            
            $('.edit_fitness' , @$el).fadeOut 'slow', =>
              $('.saved_fitness' , @$el).fadeIn 'slow'
              $('.edit_fitness_button', @$el).fadeOut 'slow', =>
                $('#edit_fitness_btn' , @$el).fadeIn 'slow'
          error: (model, response) =>
            @$el.unblock()
            @error(response.responseJSON) if response?.responseJSON?
        })
      error: (model, res) =>
        @$el.unblock()
        @error(res.responseJSON) if res?.responseJSON?
    })

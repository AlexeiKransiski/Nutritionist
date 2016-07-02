class App.Views.Main.Exercises.AddExercise.Search.AddServings extends Null.Views.Base
  template: JST['app/main/exercises/search/add_servings.html']
  tagName: 'li'
  className: 'active'

  initialize: (options) =>
    super

  events:
    'click [data-role=add-cart]': 'onAddCart'
    'click [data-role=cancel]': 'onCancel'

  render: () =>
    super

    $('.bfh-selectbox', @$el).bfhselectbox('toggle')
    @

  getContext: =>
    return { model: @model}

  onAddCart: (event) =>
    event.preventDefault()
    console.log "add to card"
    time = parseInt($("#time").val())
    return if isNaN(time)
    #(MTE X 3.5 X PESO EN KG / 200) X DURACIÓN DE LA SESIÓN DE ENTRENAMIENTO EN MINUTOS.
    if @model.get('met')
      met = parseFloat(@model.get('met'))
    else
      if @model.get('exercise_type') == "1"
        met = 7.2
      else
        met = 6.3

    weight = parseInt(app.me.get('weight').value)

    calories = (met * 3.5 * weight/200) * time
    if $('#calories', @$el).length > 0 and $('#calories', @$el)?.val() != ''
      calories = parseInt($('#calories', @$el).val())

    data =
      exercise: @model.id
      exercise_detail: @model.toJSON()
      name: @model.get('name')
      description: @model.get('description')

      time: time
      met: met

      calories_burned: calories
      exercise_type: @model.get('exercise_type')

    if @model.get('exercise_type') == "1"
      data.distance = $('#distance', @$el).val()
    else
      data.sets = $('#sets', @$el).val()
      data.repetitions = $('#reps', @$el).val()
      data.weight = $('#weigth', @$el).val()


    # calories_burned is server side calculation
    exercise_log = new App.Models.ExerciseLog(data)
    exercise_log.set 'user', app.me.id
    #exercise_log.save()

    @fire 'cart:add', exercise_log
    #@removeAll()

  onCancel: (event) =>
    event.preventDefault()
    @fire 'servings:cancel'
    @removeAll()

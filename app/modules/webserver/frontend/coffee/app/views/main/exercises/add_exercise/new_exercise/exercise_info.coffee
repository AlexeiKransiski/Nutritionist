class App.Views.Main.Exercises.AddExercise.NewExercise.ExerciseInfo extends Null.Views.Base
  template: JST['app/main/exercises/add_exercise/new_exercise/exercise_info.html']
  options:
    meal_type: ''

  initialize: (options) =>
    super
    @on 'exercise:submit', @onSubmit

  events:
    'change input': 'onInputChange'
    'change textarea': 'onInputChange'

  render: =>
    super

  onSubmit: (event) =>
    console.log "exercise info: submit"

  onInputChange: (event) =>
    $form = $('[data-role="exercise-info"]', @$el)
    data = @getFormInputs $form
    @model.set(data)

    
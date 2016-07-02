class App.Views.Main.Exercises.AddExercise.Cart.ExerciseInfo extends Null.Views.Base
  template: JST['app/main/exercises/add_exercise/cart/exercise_info.html']

  initialize: (options) =>
    super

    @render()

  render: () =>
    super
    $('.progress-bar', @$el).progressbar()

    @

  getContext: =>
    return { model: @model}

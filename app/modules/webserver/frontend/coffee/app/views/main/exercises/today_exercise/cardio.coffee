class App.Views.Main.Exercises.TodayExercise.Cardio extends Null.Views.Base 
  template: JST['app/main/exercises/today_exercise/cardio.html']
  tagName: 'tr'


  initialize: (options) =>
    super

  events:
    'click [data-role=remove-exercise-log]': 'onRemoveExerciseLog'

  render: () =>
    super

  getContext: =>
    return { model: @model, favorites: @options.favorites.pluck 'object' }

  onRemoveExerciseLog: =>
    event.preventDefault() if event?.preventDefault?
    @fire 'cardio:calculate_calories'
    @model.destroy()
    @removeAll()

class App.Views.Main.Exercises.TodayExercise.Strength extends Null.Views.Base
  template: JST['app/main/exercises/today_exercise/strength.html']
  tagName: 'tr'

  initialize: (options) =>
    super

  events:
    'ifChecked .ratings input': 'onChecked'
    'ifUnchecked .ratings input': 'onUnhecked'
    'click [data-role=remove-exercise-log-strenght]': 'onRemoveExerciseLog'


  render: () =>
    super

  getContext: =>
    return { model: @model, favorites: @options.favorites.pluck 'object' }

  onRemoveExerciseLog: =>
    event.preventDefault() if event?.preventDefault?
    @fire 'cardio:calculate_calories'
    @model.destroy()
    @removeAll()

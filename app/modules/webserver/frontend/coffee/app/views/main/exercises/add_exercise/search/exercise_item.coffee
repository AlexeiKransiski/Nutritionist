class App.Views.Main.Exercises.AddExercise.Search.ExerciseItem extends Null.Views.Base
  template: JST['app/main/exercises/add_exercise/search/exercise_item.html']
  tagName: 'li'

  initialize: (options) =>
    super

  events:
    'click [data-role=add-servings]': 'onAddServings'

  render: () =>
    super

  getContext: =>
    return { model: @model}

  onAddServings: (event) =>
    console.log "111111";
    event.preventDefault()
    console.log "ADD SERVINGS"
  



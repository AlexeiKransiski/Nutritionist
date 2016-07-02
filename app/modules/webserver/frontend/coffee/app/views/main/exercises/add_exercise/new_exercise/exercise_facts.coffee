class App.Views.Main.Exercises.AddExercise.NewExercise.ExerciseFacts extends Null.Views.Base
  template: JST['app/main/exercises/add_exercise/new_exercise/exercise_facts.html']
  className: 'hide'
  options:
    meal_type: ''

  initialize: (options) =>
    super

  events:
    'click [data-role=create-exercise]': 'onCreateExercise'
    'submit [data-role=exercise-facts]': 'onSubmit'
    'click [data-role=cancel]': 'onCancel'
    'change input': 'onInputChange'


  render: =>
    super

    $(".result_list", @$el).mCustomScrollbar(
      autoHideScrollbar:true,
      live: true
      advanced:
        updateOnContentResize: true
    )

    @

  onCreateExercise: (event) =>
    event.preventDefault()
    @fire 'exercise:create'

  onSubmit: (event) =>
    event.preventDefault()
    console.log "exercise facts: submit"
    #$('', @$el).submit()

  onCancel: (event) =>
    event.preventDefault()
    @fire 'exercise:cancel'

  onInputChange: (event) =>
    console.log "input change !!"
    $form = $('[data-role="exercise-facts"]', @$el)
    data = @getFormInputs $form
    console.log "data: ", data
    console.log "form: ", $form
    @model.set(data)

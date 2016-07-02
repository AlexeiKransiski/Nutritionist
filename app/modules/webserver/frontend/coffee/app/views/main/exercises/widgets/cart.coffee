class App.Views.Main.Exercises.Widgets.Cart extends Null.Views.Base 
  ###
  ###
  template: JST['app/main/exercises/widgets/cart.html'] 

  # events:
  #   'change input, textarea': 'onInputChanged'

  render: ->
    super
    
    @$('.result_list').mCustomScrollbar
      autoHideScrollbar: true
      advanced: updateOnContentResize: true

    @

  setNewExercise: (exercise) ->
    @newExercise = exercise

    @$('.empty-list').fadeOut 'slow', () =>
      @$('.newexer-list').fadeIn 'slow'

  goBack: ->
    delete @newExercise if @newExercise?

    @$('.newexer-list').fadeOut 'slow', () =>
      @$('.empty-list').fadeIn 'slow'

  # onInputChanged: ->
  #   changed = event.currentTarget
  #   value = $(event.currentTarget).val()
  #   console.log changed

  #   obj = {}
  #   obj[changed.name] = value

  #   @newExercise.set(obj)

  submit: ->
    if @$('.newexer-list').is(':visible')  # if form is displayed
      @$('.newexer-list input').each( (index, input) =>
        $ele = @$(input)
        @newExercise.set $ele.prop('name'), $ele.val()
      )

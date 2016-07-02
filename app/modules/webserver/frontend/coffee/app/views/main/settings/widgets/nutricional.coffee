class App.Views.Main.Settings.Widgets.Nutricional extends App.Views.Base
  template: JST['app/main/settings/widgets/nutricional.html']
  className: 'nutritionals_info'

  options:
    #tab: '#widget'
    hidden: true

  errors: {}
  form: '[data-role="nutricional-form"]'

  initialize: (options) =>
    super

    @nutricional_facts = ['carbs', 'fat', 'protein', 'cholesterol', 'sodium', 'sugars', 'potassium', 'vitamin_a', 'vitamin_c', 'calcium', 'iron', 'dietary_fiber', 'satured', 'polyunsaturated', 'monounsaturated', 'trans']

    id = null
    if app.me.get('patientPreferences') instanceof Object
      id = app.me.get('patientPreferences')._id
    else
      id = app.me.get('patientPreferences')

    @positions = []

    @patientPreferences = new App.Models.PatientPreferences({_id: id })

    @listenToOnce @patientPreferences, "sync", @render

    @patientPreferences.fetch()



  events:
    'click #updateNutritionalWidget': 'onUpdate'
    'change.bfhselectbox .nutrient-fact-pos': 'onChangeNutrientPos'

  render: () =>
    super

    $('.side_left .body li input', @$el).iCheck({
        checkboxClass: 'icheckbox_minimal-green'
    })

    if @$('.side_left .body').length > 0
      @$('.side_left .body').mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true

    #$('.priority .bfh-selectbox', @$el).bfhselectbox()
    if @patientPreferences.get("widgets_settings") != undefined
      for i in [1..6]
        @positions[i] = @getSelectValue(i, @patientPreferences.get("widgets_settings"))
        $('#position' + i, @$el).bfhselectbox({value: @positions[i]})
    else
      for i in [1..6]
        @positions[i] = @nutricional_facts[i - 1]
        $('#position' + i, @$el).bfhselectbox({value: @positions[i]})

    #@$el.attr 'data-tab', @options.tab
    #@$el.removeClass 'hide' unless @options.hidden

    @addNutrionalFacts()

    $( "#sortable1, #sortable2", @$el).sortable({
      connectWith: ".widget-nutricional"
      placeholder: "ui-state-highlight"
    }).disableSelection();

    @

  getContext: =>
    return {
      model: app.me,
      patientPreferences: @patientPreferences
    }


  addNutrionalFacts: () =>
    _.each @nutricional_facts, (item) =>
      unless item in app.me.get('widgets').nutricional.items
        $li = $('<li>')
        $li.attr('data-value', item)
        $li.html item
        $('#sortable1', @$el).append($li)

    _.each app.me.get('widgets').nutricional.items, (item) =>
      $li = $('<li>')
      $li.attr('data-value', item)
      $li.html item
      $('#sortable2', @$el).append($li)

  getSelectValue:(pos, data)->
    for fact, i in @nutricional_facts
      if pos == data[fact].index
        return fact

  validate:(data)->
    indexes = []
    for i in [1..6]
      indexes[i] = $("#position" + i).val()

    for value, index in indexes
     count=0
     for value2, index in indexes
        if value == value2
          count++
     if count > 1
      return false

    return true

  onChangeNutrientPos: (event) =>
    current_pos = $(event.target.valueOf()).data('pos')
    if event.target.value in @positions
      for i in [1..6]
        if @positions[i] == event.target.value
          @positions[i] = @positions[current_pos]
          
          target_option = $('#position' + i + ' [data-option="' + @positions[i] + '"]', @$el)

          $('#position' + i, @$el).val(@positions[i])
          $('#position' + i + ' .bfh-selectbox-option', @$el).html($(target_option).html())
          break
          
    @positions[current_pos] = event.target.value


  onUpdate: (event) =>
    event.preventDefault()
    widgets_settings = @patientPreferences.get("widgets_settings")

    # Update Tracking Sequence Position
    widgets_settings.calories.index = 0
    for fact, i in @nutricional_facts
      widgets_settings[fact].index = 7
    for i in [1..6]
      widgets_settings[$("#position" + i).val()].index = i

    if @validate(widgets_settings)
      $("#error").hide()
      @$el.block()
      @patientPreferences.save({"widgets_settings": widgets_settings}, {
        success: (model, response) =>
          @$el.unblock()
          app.me.fetch()
          # app.me.set 'patientPreferences', model.toJSON()
        error: (model, response) =>
          @$el.block()
      })
    else
      $("#error").show()

      #return if _.keys(@errors).length > 0

      # fields = @getFormInputs $(@form), []
      #
      # unless fields.password == field.repeat_password
      #   @errors.repeat_password = "Password does not match"
      #   @formErrors $(@form), @errors
      #   return
      #
      # app.me.save(fields, {
      #   wait: true
      # })


      #values = $( "#sortable2", @$el ).sortable( "toArray", {attribute: 'data-value'} )
      #console.log "Nutricionit sort: ", values

      #widgets = app.me.get('widgets')
      #widgets.nutricional.items = values

      #app.me.save({widgets: widgets}, {
      #  success: (model, response) =>
      #    alert('Nutricional Facts updated')
      #  error: (model, response) =>
      #    alert('Erro updating Nutricional Facts')
      #  wait: true
      #})

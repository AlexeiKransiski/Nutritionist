class App.Views.Signup.Preferences extends Null.Views.Base
  template: JST['app/signup/preferences.html']

  events:
    'click .btn-more-item': 'onAddMore'
    'click .items a': 'removeItem'
    'click .next-step': 'onNextStep'
    'ifChecked .terms input[type=checkbox]': 'onItemChecked'
    'ifUnchecked .terms input[type=checkbox]': 'onItemUnchecked'
    'click .add-preference-items button': 'onAddMoreFirstTime'

  initialize: ->
    super
    @patient_preferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))
    @addTemplate = '<li><input type="text" class="form-control" value="" placeholder="Write here"><a href="" class="icon-delete"></a></li>'

  render: ->
    super
    $("#preferences").show()
    @$('.terms input').iCheck
        checkboxClass: 'icheckbox_minimal-green'

    @onAddMoreFirstTime({currentTarget: '[data-role="limitations"] button'}) if @patient_preferences.get('limitations').length > 0
    @onAddMoreFirstTime({currentTarget: '[data-role="food"] button'}) if @patient_preferences.get('foods').length > 0
    @onAddMoreFirstTime({currentTarget: '[data-role="medicines"] button'}) if @patient_preferences.get('medicines').length > 0
    @onAddMoreFirstTime({currentTarget: '[data-role="vitamins"] button'}) if @patient_preferences.get('vitamins').length > 0
    return this

  getContext: () =>
    return {model: @patient_preferences}

  onAddMore: (event) ->
    $ele = @$(event.currentTarget)
    #$ele.closest('.box_larges').find('.items ul').append(@addTemplate)
    # $ele.closest('.box-body').find('.items ul').append(@addTemplate)
    if $ele.closest('.box-preferences').find('ul li:last').length > 0
      $(@addTemplate).insertAfter($ele.closest('.box-preferences').find('ul li:last'))
    else
      $ele.closest('.box-preferences').find('ul').append(@addTemplate)

  removeItem: (event) ->
    event.preventDefault()
    @$(event.currentTarget).closest('li').remove()

  onItemChecked: (event) ->
    $ele = @$(event.currentTarget)
    $ele.closest('.box-preferences').find('.ok').fadeIn 'slow'

  onItemUnchecked: (event) ->
    $ele = @$(event.currentTarget)
    $ele.closest('.box-preferences').find('.ok').fadeOut 'slow'

  onAddMoreFirstTime: (event) ->
    event.preventDefault() if event?.preventDefault?
    $(event.currentTarget).parent().fadeOut 'slow', ->
      $(event.currentTarget).parent().parent().find('ul').fadeIn 'slow'
    $(event.currentTarget).parent().parent().find('.box-foot .terms').fadeOut 'slow', ->
      $(event.currentTarget).parent().parent().find('.box-foot .more').fadeIn 'slow'

  onNextStep: ->
    @$('.items').each (index, element) =>
      field = @$(element).data('field')
      #required = not @$(element).closest('.box_larges').find(':checkbox').is(':checked')
      required = not @$(element).closest('.box-preferences').find(':checkbox').is(':checked')
      return unless required

      elements = []
      @$(element).find('input').each( (index, element) =>  elements.push(@$(element).val()) if @$(element).val() )

      @patient_preferences.set(field, elements)

    @patient_preferences.save {}, {
      wait: true
      success: (model, response) =>
        app.me.setValue {patientPreferences: model.toJSON()}
        app.routers[1].navigate("suggest", {trigger: true})
      error: (model, response) =>
        console.log "ERROR patient prefernces: ", model, response
    }

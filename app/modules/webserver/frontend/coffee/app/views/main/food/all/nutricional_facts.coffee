class App.Views.Main.Food.All.NutricionalFacts extends Null.Views.Base
  template: JST['app/main/food/all/nutricional_facts.html']

  initialize: (options) =>
    super
    @dateSearch = options.dateSearch

    id = null
    if app.me.get('patientPreferences') instanceof Object
      id = app.me.get('patientPreferences')._id
    else
      id = app.me.get('patientPreferences')

    @facts = {}

    @patientPreferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))

    @foodLog = new App.Collections.FoodLog()
    @listenTo @foodLog, "sync", @calculatePercentajes

    @renderPreferences()
    @

  render: () =>
    super

    $('.progress-bar', @$el).progressbar()
    @

  getContext: =>
    data = {
      patientPreferences: @patientPreferences,
      facts: @facts
    }

    return data

  getNutritionFacts:(dateStart)->
    @foodLog.fetch
      data:
        created: @dateSearch.toISOString()
        user:app.me.id

  getPercentaje:(value, completeValue)->
    return parseFloat(100 * value)/parseFloat(completeValue)

  renderPreferences:()->
    @foodLog.fetch
      data:
        created: @dateSearch.toISOString()
        user: app.me.id

  calculatePercentajes:()->
    #Get percentaje per
    widgets_settings = @patientPreferences.get("widgets_settings")
    
    facts = []
    foodLog = @foodLog

    $.each widgets_settings, (i, value) ->
      facts[i] = 0
      foodLog.each (value, index)->
        facts[i] += parseFloat(value.get(i))

    @foodLog = foodLog
    @facts = facts

    @render()

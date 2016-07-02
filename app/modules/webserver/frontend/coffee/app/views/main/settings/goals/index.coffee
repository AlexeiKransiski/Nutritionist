class App.Views.Main.Settings.Goals.Index extends App.Views.Base
  template: JST['app/main/settings/goals/index.html']
  className: 'tab-pane fade'
  id: 'goals'

  options:
    active: false

  that=null

  initialize: (options) =>
    super
    that=@

    @patientPreferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))

    @goals = new App.Views.Main.Settings.Goals()
    @fitness = new App.Views.Main.Settings.Fitness
      model: @patientPreferences

    @on 'fitness:refresh', @refreshFitness

    return @

  render: () =>
    super

    @appendView @goals.render(), '#goals'
    @appendView @fitness.render(), '#fitness'


    @

  refreshFitness: () =>
    @fitness.model.fetch()

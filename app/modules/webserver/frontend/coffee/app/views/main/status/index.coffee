class App.Views.Main.Status.Index extends Null.Views.Base
  template: JST['app/main/status/index.html']

  initialize: ->
    super
    @charts = new App.Views.Main.Status.Charts.Index()

  render: ->
    super

    @addView @charts.render(), '[data-role="charts"]'
    @

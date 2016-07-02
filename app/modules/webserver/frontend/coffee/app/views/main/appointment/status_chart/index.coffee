class App.Views.Main.Appointment.StatusChart.Index extends App.Views.Base
  template: JST['app/main/appointment/status_chart/index.html']
  className: 'tab-pane fade'
  id: 'statu'

  options:
    active: false
    model: null


  initialize: (options) =>
    super
    @is_rendered = false
    @charts = new App.Views.Main.Status.Charts.Index()
    return this


  getContext: =>
    result = super
    result['model'] = @options.model
    return result

  render: () =>
    super
    @$el.addClass('active') if @options.active
    return this

  showCharts: () =>
    return if @is_rendered
    @is_rendered = true
    @addView @charts.render(), '[data-role="charts"]'

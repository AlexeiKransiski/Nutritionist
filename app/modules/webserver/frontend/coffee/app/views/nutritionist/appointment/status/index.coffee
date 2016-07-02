class App.Views.Nutritionist.Appointment.Status.Index extends Null.Views.Base
  template: JST['app/nutritionist/appointment/status/index.html']

  initialize: (options) =>
    super
    @is_rendered = false

    @listenToOnce @model, 'sync', @appointmentFetched

    return this

  render: () =>
    super
    return this

  getContext: =>
    result = super
    result['model'] = @options.model
    return result

  appointmentFetched: () =>
    @charts = new App.Views.Main.Status.Charts.Index
      user_id: @model.get('patient')._id

  showCharts: () =>
    return if @is_rendered
    @is_rendered = true
    @addView @charts.render(), '[data-role="charts"]'

class App.Views.Main.Status.Charts.Index extends Null.Views.Base
  template: JST['app/main/status/charts/index.html']
  className: 'row'

  initialize: (options) =>
    super

    @user_id = options?.user_id || app.me.id

    @calories_chart = new App.Views.Main.Status.Charts.Calories
      user_id: @user_id

    @detail_chart = new App.Views.Main.Status.Charts.Details.Index
      user_id: @user_id

    return this

  events:
    'change.bfhselectbox [data-role=granularity]': 'onGranularityChange'

  render: =>
    super

    $('.bfh-selectbox[data-role=granularity]', @$el).bfhselectbox()

    @addView @calories_chart.render(), '[data-role=calories-charts]'
    @addView @detail_chart.render(), '[data-role=details-charts]'

    return this

  onGranularityChange: (event) =>
    @subviewCall 'onGranularityChange', {granularity: $(event.target).val()}

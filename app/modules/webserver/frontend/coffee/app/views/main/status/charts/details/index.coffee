class App.Views.Main.Status.Charts.Details.Index extends Null.Views.Base
  template: JST['app/main/status/charts/details/index.html']
  className: 'box_right details-charts'

  initialize: (options) =>
    super

    @user_id = options?.user_id || app.me.id

    @food_chart = new App.Views.Main.Status.Charts.Details.Food
      user_id: @user_id

    @body_progress_chart = new App.Views.Main.Status.Charts.Details.BodyProgress
      user_id: @user_id

    return this

  render: =>
    super

    $('.flexslider', @$el).flexslider({
        animation: "slide",
        animationLoop: false,
        slideshow: false,
        controlNav: false,
        customDirectionNav: $(".custom-navigations a", @$el)
        after: @onSliderChange
        start: @onSliderChange
    })

    $('.tablet[data-role=granularity]', @$el).bfhselectbox()

    @addView @body_progress_chart.render(), '[data-role=body-progress-chart]'
    @addView @food_chart.render(), '[data-role=food-chart]'

    return this

  onGranularityChange: (event) =>
    @subviewCall 'onGranularityChange', event

  # TODO: change the plugin to do the slide for the charts
  onSliderChange: (event) =>
    $slide = $('.flex-active-slide', @$el)
    $('[data-role="chart-caption"]', @$el).html($slide.data('caption'))

    return false;

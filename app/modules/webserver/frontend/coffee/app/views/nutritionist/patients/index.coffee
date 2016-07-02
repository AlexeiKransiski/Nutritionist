class App.Views.Nutritionist.Patients.Index extends Null.Views.Base
  template: JST['app/nutritionist/patients/index.html']

  initialize: (options) =>
    super

    @options =
      view_as: 'cards'

    @sections = [
      {
        name: 'Waiting for reply'
        collection: new App.Collections.Appointments()
        filter:
          status:
            '$in': ['waiting', 'answered']
      },
      {
        name: 'New consultation'
        collection: new App.Collections.Appointments()
        filter:
          status: 'open'
      },
      {
        name: 'Finished'
        collection: new App.Collections.Appointments()
        filter:
          status: 'completed'
          limit: 20
      },
    ]

    @view_as =
      'cards': new App.Views.Nutritionist.Patients.Cards.Wrapper({
        sections: @sections
      })
      'list': new App.Views.Nutritionist.Patients.List.Wrapper({
        sections: @sections
      })

    return this

  events:
    'click .view-as': 'onSwitchViewAs'

  render: () =>
    super

    @loadViewAs()

    #
    # $('.box-body ul').mCustomScrollbar({
    #   autoHideScrollbar: true,
    #   advanced:{
    #     updateOnContentResize: true
    #   }
    # });
    #
    # $('.box-bodys ul').mCustomScrollbar({
    #   autoHideScrollbar: true,
    #   advanced:{
    #     updateOnContentResize: true
    #   }
    # });

    return this

  onSwitchViewAs: (event) =>
    event.preventDefault()
    $view = $(event.target)
    unless $view.prop("tagName") == "A"
      $view = $view.parents("a")
    view = $view.data('role')
    $.cookies.set('patients-view-as', view)
    @loadViewAs(view)

  loadViewAs: (view) =>
    unless view?
      view = $.cookies.get('patients-view-as') || @options.view_as

    $(".view-as", @$el).removeClass('active')
    $("[data-role=#{view}]", @$el).addClass('active')
    @addView @view_as[view].render(), '[data-role=patient-results]'
    @current_view = @view_as[view]
    @refresh()

  refresh: () =>
    @current_view.refresh()

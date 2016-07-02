class App.Views.Nutritionist.Appointment.Preferences.Index extends Null.Views.Base
  template: JST['app/nutritionist/appointment/preferences/index.html']

  options:
    active: false
    model: null
    mood:null
    foodList:null
    exerciseList:null
    patientPreferences:null

  initialize: (options) =>
    super
    _.extend @options, options
    return this

  render: () =>
    super

    # $('.box-body ul', @$el).mCustomScrollbar(
    #   autoHideScrollbar:true,
    #   live: true
    #   advanced:
    #     updateOnContentResize: true
    # )

    $('.box-body ul', @$el).mCustomScrollbar({
      autoHideScrollbar: true,
      advanced:{
        updateOnContentResize: true
      }
    });

    return this

  getContext: () =>
    return {model: @model}

class App.Views.Main.Settings.Preferences.Notifications extends App.Views.Base
  template: JST['app/main/settings/preferences/notifications.html']
  className: 'rest_boxes notifications hidden'

  options:
    #tab: '#preferences'
    hidden: true

  initialize: (options) =>
    super

  events:
    'click [data-role=update]': 'onUpdate'

  render: () =>
    super
    @$el.attr 'data-tab', @options.tab
    @$el.removeClass 'hide' unless @options.hidden

    @

  onUpdate: (event)=>
    event.preventDefault()
    fields = @getFormInputs $('[data-role="notifications"]', @el), ['']

    fields.email_notifications = 0 unless fields.email_notifications?

    patient_preferences = new App.Models.PatientPreferences({_id: app.me.get('patientPreferences')._id })
    patient_preferences.save fields, {
      wait: true
      success: (model, response) =>
        app.me.setValue {patientPreferences: model.toJSON()}
      error: (model, response) =>
        console.log "ERROR patient prefernces: ", model, response
    }

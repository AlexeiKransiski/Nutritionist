class App.Views.Main.Appointment.Row extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/row.html']
  className: 'item'

  initialize: (options) =>
    super
    @filterBy = 'all'
    @qSearch = ''
    return this

  events:
    'click #filters span': 'onListFilter'
    'submit #search-appointment': 'onSearch'
    'click .completed': 'onCloseAppointment'

  render: () =>
    super
    @$el.css 'opacity', 1
    @$el.css 'display', 'inline'

    return this

  getContext: () =>
    return {model: @model}

  onCloseAppointment: (event) =>
    event.preventDefault()    
    @model.save({status: 'completed'}, {
      patch: true
      success: =>
        @render
    })

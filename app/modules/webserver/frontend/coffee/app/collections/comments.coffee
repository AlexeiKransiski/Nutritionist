class App.Collections.Comments extends Null.Collections.Base
  url: '/api/v1/comments'
  model: App.Models.Comment

  setAppointment: (id) =>
    @appointment = id

  create: (model, options) =>
    if model instanceof Backbone.Model
      model.set('appointment', @appointment)
    else
      model.appointment = @appointment

    super(model, options)

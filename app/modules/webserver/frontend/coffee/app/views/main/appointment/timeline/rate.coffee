class App.Views.Main.Appointment.Timeline.Rate extends Null.Views.Base
  template: JST['app/main/appointment/timeline/rate.html']

  initialize: (options) =>
    super
    return this

  events:
    'click [data-role="send"]': 'onSendClick'
    'click [data-role="cancel"]': 'onCancelClick'

  render: () =>
    super
    return this

  getContext: () =>
    return {model: @model}

  onSendClick: (event) =>
    event.preventDefault()
    return unless @checkMessage()
    comment = new App.Models.Comment()
    @model.save({
      status: 'completed'
      rating: $('[name=rating-1]:checked', @$el).val()
      feedback: $('#feedback', @$el).val()
    }, {
      success: (model, response) =>
        @success('Message Sent')
        @fire 'rated'
      error: (model, response) =>
        if response.responseJSON?
          @error(response.responseJSON)
        else
          @error "Error creating message"
    })

  checkMessage: () =>
    valid = true
    if $("#feedback", @$el).val() == ""
      valid=false
      $("#feedback_error", @$el).show()
      $("#feedback_error", @$el).empty()
      $("#feedback_error", @$el).append("Please enter a message")
    else
      $("#feedback_error", @$el).show()
      $("#feedback_error", @$el).empty()
    return valid

  onCancelClick: (event) =>
    event.preventDefault()
    @fire 'action:cancel'

class App.Views.Nutritionist.Appointment.Timeline.Add extends Null.Views.Base
  template: JST['app/nutritionist/appointment/timeline/add.html']

  initialize: (options) =>
    super
    return this

  events:
    'keyup #message': 'onMessageChange'
    'change #message': 'onMessageChange'
    'click [data-role="send"]': 'onSendClick'

  render: () =>
    super
    return this

  onMessageChange: (event) =>
    $txt = $(event.target)
    text = $txt.val()
    length = text.length
    limit = 600
    if length <= limit
      $('#letters', @$el).html(length)
      return true
    else
      new_text = text.substr(0, limit);
      $txt.val(new_text);
      return false


  onSendClick: (event) =>
    event.preventDefault()
    return unless @checkMessage()
    comment = new App.Models.Comment()
    comment.save({
      appointment: @model.id
      message: $('#message', @$el).val()
    }, {
      success: (model, response) =>
        @success('Message Sent')
        @collection.add(model)
      error: (model, response) =>
        if response.responseJSON?
          @error(response.responseJSON)
        else
          @error "Error creating message"
    })

  checkMessage: () =>
    valid = true
    if $("#message", @$el).val() == ""
      valid=false
      $("#messages_error", @$el).show()
      $("#messages_error", @$el).empty()
      $("#messages_error", @$el).append("Please enter a message")
    else
      $("#messages_error", @$el).show()
      $("#messages_error", @$el).empty()
    return valid

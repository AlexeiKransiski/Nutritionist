class App.Views.Main.Appointment.Timeline.Add extends Null.Views.Base
  template: JST['app/main/appointment/timeline/add.html']

  initialize: (options) =>
    super
    return this

  events:
    'keyup #messages': 'onMessageChange'
    'change #messages': 'onMessageChange'
    'click [data-role="send"]': 'onSendClick'
    'click [data-role="cancel"]': 'onCancelClick'

  render: () =>
    super
    return this

  getContext: () =>
    return {model: @model}

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
      message: $('#messages', @$el).val()
    }, {
      success: (model, response) =>
        @success('Message Sent')
        @model.set('status', 'waiting')
        @collection.add(model)
      error: (model, response) =>
        if response.responseJSON?
          @error(response.responseJSON)
        else
          @error "Error creating message"
    })

  checkMessage: () =>
    valid = true
    if $("#messages", @$el).val() == ""
      valid=false
      $("#messages_error", @$el).show()
      $("#messages_error", @$el).empty()
      $("#messages_error", @$el).append("Please enter a message")
    else
      $("#messages_error", @$el).show()
      $("#messages_error", @$el).empty()
    return valid

  onCancelClick: (event) =>
    event.preventDefault()
    @fire 'action:cancel'

class App.Views.Main.Settings.Help.Index extends App.Views.Base
  template: JST['app/main/settings/help/index.html']
  className: 'tab-pane fade'
  id: 'help'

  options:
    active: false

  initialize: (options) =>
    super

  events:
    'click .btn-success': 'onSendHelp'
    'focus #title': 'onFocusTitle'
    'blur #title': 'onBlurTitle'

  render: () =>
    super

    @$('.bfh-selectbox').bfhselectbox()
    @

  #Events
  onSendHelp: ->
    event.preventDefault()
    $.ajax({
      url: '/api/v1/support'
      method: 'post'
      dataType: 'json'
      data:
        title: $('#title', @$el).val()
        subject: $('#subject', @$el).val()
        message: $('#message', @$el).val()

      success: (data, xhr) =>
        console.log "success", arguments
        $('.support' , @$el).fadeOut 'slow', =>
          $('.thanks' , @$el).fadeIn('slow').delay(6000).fadeOut 'slow', =>
            $('.support' , @$el).fadeIn 'slow', =>
              $('#subject' , @$el).val('')
              $('#title' , @$el).val('')
              $('#message' , @$el).val('')

      error: (xhr, err, errText) =>
        console.log "error: ", arguments
        @error('Error sending the message. Try again later.')
    })

  onFocusTitle: (event) =>
    $('#title' , @$el).attr('placeholder', '')

  onBlurTitle: (event) =>
    if ($('#title' , @$el).val() == '')
      $('#title' , @$el).attr('placeholder', 'Title for your Concern')      
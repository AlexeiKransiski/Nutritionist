class App.Views.Nutritionist.Appointment.Timeline.Alert extends Null.Views.Base
  template: JST['app/nutritionist/appointment/timeline/alert.html']

  initialize: (options) =>
    super
    return this

  render: () =>
    super
    @showAlert()
    return this

  getContext: () =>
    return {model: @model}

  showAlert: () =>
    replies = new App.Collections.Comments(@model.get('replies'))
    length = replies.length
    last = replies.last()

    switch @model.get('status')
      when 'completed'
        @onCompleted()
      else
        @onAnswered(length)

  onOpen: () =>
    return

  onAnswered: (length) =>
    switch length
      when 4
        @onCompleted()
      else
        @show('answered')

  onWaiting: () =>
    @show('answered')

  onCompleted: () =>
    console.log 'completed'
    if @model.get('rating')
      @show('end-and-rating')
    else
      @show('end-no-rating')

  show: (alert) =>
    $('.alert-box', @$el).addClass('hide')
    $("[data-role=#{alert}]", @$el).removeClass('hide')

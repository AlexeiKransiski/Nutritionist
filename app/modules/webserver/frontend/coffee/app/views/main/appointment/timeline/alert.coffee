class App.Views.Main.Appointment.Timeline.Alert extends Null.Views.Base
  template: JST['app/main/appointment/timeline/alert.html']

  initialize: (options) =>
    super
    return this

  events:
    'click [data-role="answer-no-accepted"]': 'onAddQuestion'
    'click [data-role="answer-accepted"]': 'onRateNutritionist'

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
      when 'open'
        @onOpen()
      when 'answered'
        @onAnswered(length)
      when 'waiting'
        @onWaiting()
      when 'completed'
        @onCompleted()
      else
        @onAnswered(length)

  onOpen: () =>
    @show('first-msg')
    return

  onAnswered: (length) =>
    switch length
      when 4
        @onCompleted()
      else
        @show('first-answer-survey')

  onWaiting: () =>
    @show('second-msg')

  onCompleted: () =>
    @show('completed')
    $('[data-role="rating-stars"]', @$el).css('width', @getRatingStarsWidth())

  show: (alert) =>
    $('.comments', @$el).addClass('hide')
    $("[data-role=#{alert}]", @$el).removeClass('hide')

  getRatingStarsWidth: () =>
    switch @model.get('rating')
      when 1
        width = '25px'
      when 2
        width = '55px'
      when 3
        width = '87px'
      when 4
        width = '116px'
      when 5
        width = '150px'
      else
        width = '0px'
    return width

  onAddQuestion: (event) =>
    event.preventDefault()
    @fire 'new:question'

  onRateNutritionist: (event) =>
    event.preventDefault()
    @fire 'show:rate'

class App.Views.Nutritionist.Appointment.Timeline.Comment extends Null.Views.Base
  template: JST['app/nutritionist/appointment/timeline/comment.html']
  tagName: 'div'
  className: 'row'

  initialize: (options) =>
    super

    @comment_type =
      question: 'comments'
      answer: 'answered'

    @comment_type_label =
      question: 'Ask'
      answer: 'Answered'

    return this

  render: () =>
    super
    return this

  getContext: () =>

    return {
      model: @model,
      comment_type: @comment_type[@model.get('status')]
      comment_type_label: @comment_type_label[@model.get('status')]
      sender: (if app.me.id == @model.get('sender') then 'You' else @model.get('sender_name'))
    }

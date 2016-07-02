class App.Views.Main.Appointment.Timeline.Comment extends Null.Views.Base
  template: JST['app/main/appointment/timeline/comment.html']
  tagName: 'div'
  className: 'comments'

  initialize: (options) =>
    super

    @comment_type =
      question: ''
      answer: 'nutritionist'

    return this

  render: () =>
    super
    return this

  getContext: () =>

    return {
      model: @model,
      comment_type: @comment_type[@model.get('status')]
      sender: @model.get('sender_name')
    }

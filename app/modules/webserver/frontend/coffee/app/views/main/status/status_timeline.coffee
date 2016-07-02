class App.Views.Main.StatusTimeline extends Null.Views.Base  
  template: JST['app/main/status/status_timeline.html']

  initialize: ->
    super
    @statusStream = new App.Collections.Status()
    @statusStream.fetch({data:{"user":app.me.id}}) 


  render: ->
    super

    @

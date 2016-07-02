class App.Views.Main.Dashboard.Index extends Null.Views.Base
  template: JST['app/main/dashboard/index.html']

  initialize: (options) =>
    super

    @main_info = new App.Views.Main.Dashboard.MainInfo
      model: app.me
      
    @track_input = new App.Views.Common.Main.TrackInput
      model: null
      type: 'default'

    @checklist = new App.Views.Main.Dashboard.Widgets.Checklist()


  render: () =>
    super
    @appendView @main_info.render(), '[data-role=main_info]'
    @appendView @track_input.render(), '[data-role=tracking]'
    @appendView @checklist.render(), '[data-role=checklist]'

class App.Views.Main.Settings.Index extends Null.Views.Base
  template: JST['app/main/settings/index.html']

  initialize: (options) =>
    super

    # profile boxes
    @my_profile = new App.Views.Main.Settings.MyProfile.Index
      active: true

    # widget boxes
    @widgets = new App.Views.Main.Settings.Widgets.Index
      active: false

    # preferecens boxes
    @preferences = new App.Views.Main.Settings.Preferences.Index
      active: false

    # subscription boxes
    @subscriptions = new App.Views.Main.Settings.Subscriptions.Index
      active: false

    # goals boxes
    @goals = new App.Views.Main.Settings.Goals.Index
      active: false

    # help boxes
    @help = new App.Views.Main.Settings.Help.Index
      active: false    

    @on "reload_goals",@reloadGoals  

  events:
    'click [data-toggle="tab"]': 'onTabClicked'

  render: () =>
    super

    @appendView @my_profile.render(), '[data-role=tabs]'
    @appendView @widgets.render(), '[data-role=tabs]'
    @appendView @preferences.render(), '[data-role=tabs]'
    @appendView @subscriptions.render(), '[data-role=tabs]'
    @appendView @goals.render(), '[data-role=tabs]'
    @appendView @help.render(), '[data-role=tabs]'

    @

  reloadGoals:()=>
    @appendView @goals.render(), '[data-role=tabs]'

  onTabClicked: (event) =>
    $tab = $(event.target)
    unless $tab.prop("tagName") == 'A'
      return

    #tab_id = $tab.attr('href')
    #$('.rest_boxes', @$el).addClass('hide')
    #$(".rest_boxes[data-tab=#{tab_id}]", @$el).removeClass('hide')

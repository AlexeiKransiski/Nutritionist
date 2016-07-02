class App.Routers.Signup extends Null.Routers.Base
  routes:
    'info': 'firstStep',
    'life': 'secondStep',
    'preferences': 'thirdStep',
    'plan': 'fourStep',
    'suggest': 'lastStep',


  page_class: App.Views.Signup.Page

  $a = $("<a>")
  $a.attr('href', "")
  $a.data('role', 'route')

  firstStep: =>
    app.loadPage App.Views.Signup.Info, {el: "[data-role=main]"}
    @scrollTop()

    ga('set', 'page', '/signup-progress-info');
    ga('send', 'pageview');

    fbq('track', "PageView");

  secondStep: =>
    app.loadPage App.Views.Signup.Life, {el: "[data-role=main]"}
    @scrollTop()

    ga('set', 'page', '/signup-progress-life');
    ga('send', 'pageview');

    fbq('track', "PageView");

  thirdStep: =>
    app.loadPage App.Views.Signup.Preferences, {el: "[data-role=main]"}
    @scrollTop()

    ga('set', 'page', '/signup-progress-preferences');
    ga('send', 'pageview');

    fbq('track', "PageView");

  fourStep: =>
    app.loadPage App.Views.Signup.ChoosePlan, {el: "[data-role=main]"}
    @scrollTop()

    ga('set', 'page', '/signup-progress-plan');
    ga('send', 'pageview');

    fbq('track', "PageView");

  lastStep: =>
    app.loadPage App.Views.Signup.Suggest, {el: "[data-role=main]"}
    @scrollTop()

    ga('set', 'page', '/signup-progress-suggest');
    ga('send', 'pageview');

    fbq('track', "PageView");
    fbq('track', 'Purchase', {value: '0.00', currency:'USD'});

  scrollTop: =>
    $('body').scrollTop(0)

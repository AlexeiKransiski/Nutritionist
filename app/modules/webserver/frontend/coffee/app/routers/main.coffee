class App.Routers.Main extends Null.Routers.Base
  routes:
    '': 'index',
    'food': 'food'
    'settings': 'settings'
    'exercises': 'exercises'
    'progress': 'progress'
    'status': 'status'
    'nutritionist': 'nutritionist'
    'appointment/:id': 'appointment'

  page_class: App.Views.Main.Page

  index: =>
    @selectNav('')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Contacts")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Dashboard.Index, {el: "[data-role=main]"}

    ga('set', 'page', '/user-dashboard');
    ga('send', 'pageview');

    fbq('track', "PageView");

  food: =>
    @selectNav('food')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Food")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Food.Index, {el: "[data-role=main]"}

    ga('set', 'page', '/food');
    ga('send', 'pageview');

    fbq('track', "PageView");

  settings: =>
    @selectNav('settings')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Settings")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Settings.Index, {el: "[data-role=main]"}

    ga('set', 'page', '/settings');
    ga('send', 'pageview');

    fbq('track', "PageView");

  exercises: =>
    @selectNav('exercises')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Exercises")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Exercises.Index, {el: "[data-role=main]"}
    
    ga('set', 'page', '/exercises');
    ga('send', 'pageview');

    fbq('track', "PageView");

  progress: =>
    @selectNav('progress')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Progress")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Progress.Index, {el: "[data-role=main]"}

    ga('set', 'page', '/progress');
    ga('send', 'pageview');

    fbq('track', "PageView");

  status: =>
    @selectNav('status')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Status")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Status.Index, {el: "[data-role=main]"}

    ga('set', 'page', '/status');
    ga('send', 'pageview');

    fbq('track', "PageView");

  nutritionist: =>
    @selectNav('nutritionist')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Nutritionist")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Nutritionist.Index, {el: "[data-role=main]"}

    ga('set', 'page', '/nutritionist');
    ga('send', 'pageview');

    fbq('track', "PageView");

  appointment: (id) =>
    @selectNav('nutritionist')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Nutritionist")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Main.Appointment.Index, {el: "[data-role=main]", modelID: id[0]}

    ga('set', 'page', '/appointment');
    ga('send', 'pageview');
    
    fbq('track', "PageView");

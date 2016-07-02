class App.Routers.Nutritionist extends Null.Routers.Base
  routes:
    '': 'index',
    # 'settings': 'settings'
    'patients': 'patients'
    # 'calendar': 'calendar'
    # 'inbox': 'inbox'
    # 'status': 'status'
    # 'reports': 'reports'
    'appointment/:id': 'appointment'
    'historial/:id': 'historial'

  page_class: App.Views.Nutritionist.Page

  index: =>
    @selectNav('')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Contacts")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Nutritionist.Dashboard.Index, {el: "[data-role=main]"}

  patients: =>
    @selectNav('patients')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Patients")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Nutritionist.Patients.Index, {el: "[data-role=main]"}

  appointment: (id) =>
    @selectNav('patients')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Nutritionist")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Nutritionist.Appointment.Index, {el: "[data-role=main]", modelID: id[0]}

  historial: (id) =>
    @selectNav('patients')
    $a = $("<a>")
    $a.attr('href', "")
    $a.data('role', 'route')
    $a.html("Nutritionist")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Nutritionist.ClinicHistory.Index, {el: "[data-role=main]", modelID: id[0]}
  #
  # settings: =>
  #   @selectNav('settings')
  #   $a = $("<a>")
  #   $a.attr('href', "")
  #   $a.data('role', 'route')
  #   $a.html("Settings")
  #   $('[data-role="breadcrum"]').html($a)
  #   app.loadPage App.Views.Main.Settings.Index, {el: "[data-role=main]"}
  #
  # exercises: =>
  #   @selectNav('exercises')
  #   $a = $("<a>")
  #   $a.attr('href', "")
  #   $a.data('role', 'route')
  #   $a.html("Exercises")
  #   $('[data-role="breadcrum"]').html($a)
  #   app.loadPage App.Views.Main.Exercises.Index, {el: "[data-role=main]"}
  #
  # progress: =>
  #   @selectNav('progress')
  #   $a = $("<a>")
  #   $a.attr('href', "")
  #   $a.data('role', 'route')
  #   $a.html("Progress")
  #   $('[data-role="breadcrum"]').html($a)
  #   app.loadPage App.Views.Main.Progress.Index, {el: "[data-role=main]"}
  #
  # status: =>
  #   @selectNav('status')
  #   $a = $("<a>")
  #   $a.attr('href', "")
  #   $a.data('role', 'route')
  #   $a.html("Status")
  #   $('[data-role="breadcrum"]').html($a)
  #   app.loadPage App.Views.Main.Status.Index, {el: "[data-role=main]"}
  #
  # nutritionist: =>
  #   @selectNav('nutritionist')
  #   $a = $("<a>")
  #   $a.attr('href', "")
  #   $a.data('role', 'route')
  #   $a.html("Nutritionist")
  #   $('[data-role="breadcrum"]').html($a)
  #   app.loadPage App.Views.Main.Nutritionist.Index, {el: "[data-role=main]"}

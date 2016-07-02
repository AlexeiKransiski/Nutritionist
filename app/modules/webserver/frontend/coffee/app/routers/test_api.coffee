class App.Routers.TestApi extends Null.Routers.Base
  routes:
    '': 'users',
    'appointments': 'appointments'
    'food': 'food'
    'exercises': 'exercises'


  $a = $("<a>")
  $a.attr('href', "")
  $a.data('role', 'route')

  users: =>
    @selectNav('users')
    $a.html("Users")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.TestApi.Users.Index, {el: "[data-role=main]"}

  appointments: =>
    @selectNav('appointments')
    $a.html("Appointments")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.TestApi.Appointments.Index, {el: "[data-role=main]"}

  food: =>
    @selectNav('food')
    $a.html("Food")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.TestApi.Food.Index, {el: "[data-role=main]"}

  exercises: =>
    @selectNav('exercises')
    $a.html("Exercises")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.TestApi.Exercises.Index, {el: "[data-role=main]"}

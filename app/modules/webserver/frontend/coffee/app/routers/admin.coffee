class App.Routers.Admin extends Null.Routers.Base
  routes:
    '': 'users',
    'patients': 'patients'
    'surgeries': 'surgeries'
    'locations': 'locations'
    'messages': 'messages'
    'devices': 'devices'
    'contacts': 'contacts'
    'customers': 'customers'


  page_class: App.Views.Admin.Page

  $a = $("<a>")
  $a.attr('href', "")
  $a.data('role', 'route')

  users: =>
    @selectNav('')
    $a.html("Users")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Users.Index, {el: "[data-role=main]"}

  patients: =>
    @selectNav('patients')
    $a.html("Patients")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Patients.Index, {el: "[data-role=main]"}

  surgeries: =>
    @selectNav('surgeries')
    $a.html("Surgeries")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Surgeries.Index, {el: "[data-role=main]"}

  locations: =>
    @selectNav('locations')
    $a.html("Locations")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Locations.Index, {el: "[data-role=main]"}

  messages: =>
    @selectNav('messages')
    $a.html("Messages")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Messages.Index, {el: "[data-role=main]"}

  devices: =>
    @selectNav('devices')
    $a.html("Devices")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Devices.Index, {el: "[data-role=main]"}

  contacts: =>
    @selectNav('contacts')
    $a.html("Contacts")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Contacts.Index, {el: "[data-role=main]"}

  customers: =>
    @selectNav('customers')
    $a.html("Customers")
    $('[data-role="breadcrum"]').html($a)
    app.loadPage App.Views.Admin.Customers.Index, {el: "[data-role=main]"}

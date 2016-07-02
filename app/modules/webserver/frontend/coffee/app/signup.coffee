$(document).ready () ->
  console.log "Singup"

  $('.terms input').iCheck(
    checkboxClass: 'icheckbox_minimal-green'
  )

  # Simple user model to just signup
  class User extends Backbone.Model
    urlRoot: '/api/v1/users'

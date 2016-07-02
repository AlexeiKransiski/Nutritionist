$(document).ready () ->

  $('.terms input').iCheck
    checkboxClass: 'icheckbox_minimal-green'

    @

  $("#form-login").validate({
    rules: {
        email: {
            required: true,
            email: true
        },
        password: {
          required: true
        }
    },


    messages: {
      email: "Please enter a valid email address",
      password:"Please enter your password"
    },

    submitHandler:()->
      data =
       email: $('#email').val(),
       password: $('#password').val()

      $.ajax({
        url: '/api/v1/auth/local'
        type: 'post'
        data: data
        dataType: 'json'
        success: (data) ->
          if data.profileFilled
            $.cookies.set('auth_token', data.token)
            $.cookies.set('user_id', data._id)
            window.location.href = '/'
          else
            alert data.email + " doesn't exist."
        error: (xhr, error) ->
          alert "Bad username or password"

      })
      return false
  });

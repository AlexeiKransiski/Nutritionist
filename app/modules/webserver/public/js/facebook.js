
  $( document ).ready(function() {

  });

  window.appId = "{{appId}}";

  // This is called with the results from from FB.getLoginStatus().
  function statusChangeCallback(response) {
    console.log(response);
    if (response.status === 'connected') {
      // Logged into your app and Facebook.
      $.ajax({
        url: '/api/v1/auth/facebook/token',
        type: 'post',
        data: {
          access_token:response.authResponse.accessToken
        },
        dataType: 'json',
        success: function(data) {
          console.log(data.token);
          $.cookies.set('auth_token', data.token);
          data.facebook_token=response.authResponse.accessToken;
          $.cookies.set('user', data);
          return window.location.href = '/';
        },
        error: function(xhr, error) {
          console.log(xhr.responseJSON.message);
          //Get account data.
          FB.api('/me', function(response) {
            console.log('Successful login for: ' + response.name);
            console.log(response);
            return window.location.href = '/signup?warn=' + xhr.responseJSON.message + '&name=' + response.first_name + '&lastName=' + response.last_name;
          });

          
        }
      });

    } else if (response.status === 'not_authorized') {
      // The person is logged into Facebook, but not your app.
      //document.getElementById('status').innerHTML = 'Please log ' +
      //  'into this app.';
    } else {
      // The person is not logged into Facebook, so we're not sure if
      // they are logged into this app or not.
      //document.getElementById('status').innerHTML = 'Please log ' +
      //  'into Facebook.';
    }
  }

  // This function is called when someone finishes with the Login
  // Button.  See the onlogin handler attached to it in the sample
  // code below.
  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }



  // Load the SDK asynchronously
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));


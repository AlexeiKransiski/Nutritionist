Null.Sync = (method, model, options) ->
  token = $.cookies.get('auth_token')
  if token
    options.dataType = "json"
    options.beforeSend = (xhr) ->
      xhr.setRequestHeader("Authorization", "Bearer #{token}")

  return Backbone.sync(method, model, options)


## AJAX setup
$.ajaxSetup({
  beforeSend: (xhr) ->
    #$(".loading").addClass("active")
    token = $.cookies.get('auth_token')
    xhr.setRequestHeader("Authorization", "Bearer #{token}")
  ,
  complete: () ->
    # setTimeout(() ->
    #         $(".loading").removeClass("active")
    #       , 500)
})

$(document).ready ->
  ## Backbone link navgiate
  $( document ).on( "click", '[data-role=route]', (event) ->
    event.preventDefault()
    $a = $(event.target)
    while not $a.is 'a'
      $a = $a.parent()

    Backbone.history.navigate("#{$a.attr('href')}", {trigger: true})
  )

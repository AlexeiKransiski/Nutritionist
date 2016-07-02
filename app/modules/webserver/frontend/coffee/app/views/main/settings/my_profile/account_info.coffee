class App.Views.Main.Settings.MyProfile.AccountInfo extends App.Views.Base
  template: JST['app/main/settings/my_profile/account_info.html']
  className: 'account_info'

  options:
    #tab: '#profile'
    hidden: true

  that = null

  errors: {}
  form: '[data-role="account-info-form"]'
  initialize: (options) =>
    super
    that = @

  events:
    'keyup #username': 'onUsernameChange'
    'keyup #email': 'onEmailChange'
    'click [data-role="update-account"]': 'onUpdate'

  render: () =>
    super

    #@$el.attr 'data-tab', @options.tab
    #@$el.removeClass 'hide' unless @options.hidden

    @

  getContext: =>
    return {model: app.me}

  onUsernameChange: (event) =>
    clearTimeout(@delay_search_username)
    $input = $(event.target)
    return $input.parents('.form-group').unblock() if $input.val().length <= 4

    $input.parents('.form-group').block()
    @delay_search_username = setTimeout(() =>
      users = new App.Collections.Users()
      users.fetch
        data:
          username: $input.val()
          _id:
            '$ne': app.me.id
        success: (collection, response) =>
          $input.parents('.form-group').unblock()
          if collection.length > 0
            @errors.username = "Already exist"
          else
            delete @errors.username
          @formErrors $(@form), @errors

        error: (collection, error) =>
          $input.parents('.form-group').unblock()
          console.log "error: ", arguments

    , 200)


  onEmailChange: (event) =>
    clearTimeout(@delay_search_email)
    $input = $(event.target)
    return $input.parents('.form-group').unblock() if $input.val().search(/.*@.*/) < 0

    $input.parents('.form-group').block()
    @delay_search_email = setTimeout(() =>
      users = new App.Collections.Users()
      users.fetch
        data:
          email: $input.val()
          _id:
            '$ne': app.me.id
        success: (collection, response) =>
          $input.parents('.form-group').unblock()
          if collection.length > 0
            @errors.email = "Already exist"
          else
            delete @errors.email
          @formErrors $(@form), @errors

        error: (collection, error) =>
          $input.parents('.form-group').unblock()
          console.log "error: ", arguments

    , 200)


  onUpdate: (event) =>
    event.preventDefault()
    return if _.keys(@errors).length > 0
    fields = @getFormInputs $(@form), []
    
    app.me.save(fields,
      success:(e)->
        that.render()
    )

      #success:(e)->
      #  @render()

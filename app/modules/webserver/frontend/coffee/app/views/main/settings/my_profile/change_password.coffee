class App.Views.Main.Settings.MyProfile.ChangePassword extends App.Views.Base
  template: JST['app/main/settings/my_profile/change_password.html']
  className: 'change_password'

  options:
    #tab: '#profile'
    hidden: true

  errors: {}
  form: '[data-role="change-password-form"]'
  initialize: (options) =>
    super

  events:
    'change #repeat_password': 'onPasswordCheckMatch'
    'click [data-role="update-password"]': 'onUpdate'

  render: () =>
    super

    #@$el.attr 'data-tab', @options.tab
    #@$el.removeClass 'hide' unless @options.hidden

    @

  onPasswordCheckMatch: (event) =>
    @validateFields()

  onUpdate: (event) =>
    event.preventDefault()

    @validateFields()

    return if _.keys(@errors).length > 0

    fields = @getFormInputs $(@form), []
    app.me.save({
      oldpassword: fields.oldpassword
      password: fields.password
    }, {
      success: (model, response) =>
        app.me.unset('oldpassword')
        alert('Password changed successfully.')
      error: (model, response) =>
        alert('Failed to change password')
      wait: true
    })

  validateFields: =>

    @errors = {}

    oldpassword = $('#oldpassword', @$el).val()
    password = $('#password', @$el).val()
    repeat_password = $('#repeat_password', @$el).val()

    if oldpassword == ''
      @errors['oldpassword'] = "Required Field"

    if password == ''
      @errors['password'] = "Required Field"

    unless password == repeat_password
      @errors['repeat_password'] = "Password does not match"
      

    @formErrors $(@form), @errors
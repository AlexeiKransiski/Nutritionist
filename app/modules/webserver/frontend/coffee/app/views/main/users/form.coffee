class App.Views.Main.Users.Form extends Null.Views.Base
  template: JST['app/main/users/form.html']

  form: '[data-role=signup-form]'

  permission: "User:create"

  initialize: (options) =>
    super

  events:
    'submit .signup-form': 'saveModel'

  onclick: (event) =>
    console.log "event"

  render: () =>
    super


    $('#formWizard-newUser', @$el).bootstrapWizard
      'nextSelector': '.button-next'
      'previousSelector': '.button-previous'

      # onNext: (tab, navigation, index) =>
      #   console.log "next"
      onTabClick: () =>
        return false

      onNext: (tab, navigation, index) =>
        console.log "next"
        bugs = 0
        hasError = (id) =>
          $(id).parents('.form-group').addClass('has-error')
          bugs = 1

        isEmail = (email) =>
          regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
          return regex.test(email)

        if index is 1

          hasError('#role') unless $('#role').val()?
          hasError('#email') unless isEmail($('#email').val())
          hasError('#username') unless $('#username').val() != ""
          hasError('#password') unless $('#password').val() != ""
          hasError('#first_name') unless $('#first_name').val() != ""
          hasError('#last_name') unless $('#last_name').val() != ""
          hasError('#prefix_name') unless $('#prefix_name').val()?


          return false if bugs == 1

        if index is 2

          false if bugs is 1


      onTabShow: (tab, navigation, index) =>
        $total = navigation.find('li').length
        $current = index+1
        $percent = ($current/$total) * 100

        showFinishBtn = =>
          $('#formWizard-newUser', @$el).find('.button-next').hide()
          $('#formWizard-newUser', @$el).find('.button-finish').show()

        hideFinishBtn = =>
          $('#formWizard-newUser', @$el).find('.button-next').show()
          $('#formWizard-newUser', @$el).find('.button-finish').hide()

        $('#formWizard-newUser', @$el).find('.progress-bar').css 'width', "#{$percent}%"

        $('#formWizard-newUser > .steps li', @$el).each (index) ->
          $(this).removeClass('complete')
          index += 1
          $(this).addClass('complete') if index < $current

        if $current >= $total then showFinishBtn() else hideFinishBtn()

    @


  saveModel: (e) ->
    e.preventDefault()

    data = @getFormInputs $(@form)

    user =
      "type": data.type,
      "role":  data.role,
      "customer": data.customer,
      "username": data.username,
      "email": data.email,
      "password": data.password,
      "ssn":  data.ssn,
      "prefix_name": data.prefix_name,
      "first_name":  data.first_name,
      "last_name":  data.last_name,
      "dob":  data.dob,
      "contactInfo": {
        "phone":{
          "office":  data.office_phone
          "cell":  data.cellphone
        },
        "email":{
          "personal":  data.personal_email
          "work":  data.work_email
        }
      }

    console.log "User data: ", user
    @collection.create user, {
      success: (model, response) =>
        console.log "Created", model, response
      error: (model, response) =>
        console.log "ERror", model, response
      wait: true

    }

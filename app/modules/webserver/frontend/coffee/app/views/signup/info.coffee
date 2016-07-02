class App.Views.Signup.Info extends Null.Views.Base
  template: JST['app/signup/info.html']

  events:
    'change #personal-info input': 'onChangeInput'
    #'change #health-info input': 'onChangeHealthInput'
    'change.bfhselectbox #personal-info .bfh-selectbox.valuable': 'onChangeInput'
    'change.bfhselectbox #personal-info .bfh-selectbox.date': 'onChangeDateInput'
    'click .unit-selector': 'onChangeUnit'
    'click #next-step': 'onNextStep'
    'change #height':'onChangeHeight'
    'change #weight':'onChangeWeight'
    'change #desire':'onChangeDesireWeight'
    'change #height_ft':'onChangeHeightImperial'
    'change #height_in':'onChangeHeightImperial'
    'change #weightImperial':'onChangeWeightImperial'
    'change #desireImperial':'onChangeDesireWeightImperial'
    'change .bfh-selectbox[data-id=gender]':'onChangeGender'

  initialize: ->
    @dob = new Date
    @heightUnit = 'cm'
    @weightUnit = 'kg'
    @unit = 'imperial'

  getContext: ->
    return {
      user: app.me
    }

  render: ->
    super

    #@$('.bfh-selectbox').bfhselectbox()
    default_gender = if app.me.get('gender') then app.me.get('gender') else 'M'
    $('.bfh-selectbox[data-id=gender]').bfhselectbox({
      value: default_gender
    })
    $('.bfh-selectbox[data-id=days]').bfhselectbox()
    $('.bfh-selectbox[data-id=month]').bfhselectbox()
    $('.bfh-selectbox[data-id=year]').bfhselectbox()

    $('.bfh-selectbox[data-id=pregnant]').bfhselectbox({
      value: "No"
    })
    $('.bfh-selectbox[data-id=breastfeeding]').bfhselectbox({
      value: "No"
    })

    $('.custom_radio input').iCheck({
        radioClass: 'iradio_polaris'
    });

    @onChangeGender()

    #@users = new App.Views.Common.Helpers.Users.Select({el: $('select#patient', @$el), filter: {is_nutricionist: 0}})
    # Helpers.generateSlider($('#heightImperial', @$el), @onChangeHeightImperial)
    return this

  onChangeGender:->
    if $('.bfh-selectbox[data-id=gender]').val() == "F"
      $("#femaleOptions").fadeIn();

  onChangeHeight:->
    heightFactor = 0.39370
    $("#heightImperial").val($("#height").val()*heightFactor)

  onChangeWeight:->
    weightFactor = 2.204623
    $("#weightImperial").val($("#weight").val()*weightFactor)

  onChangeDesireWeight:->
    weightFactor = 2.204623
    $("#desireImperial").val($("#desire").val()*weightFactor)

  onChangeHeightImperial: =>
    height_ft = $('#height_ft', @$el).val()
    height_in = $('#height_in', @$el).val()
    $("#height").val(parseFloat(Helpers.getCmFromFtInch(height_ft, height_in)))

  onChangeWeightImperial:->
    weightFactor = 1.0 / 2.204623
    $("#weight").val($("#weightImperial").val()*weightFactor)

  onChangeDesireWeightImperial:->
    weightFactor = 1.0 / 2.204623
    $("#desire").val($("#desireImperial").val()*weightFactor)


    #  heightFactor = 0.39370
    #  weightFactor = 2.204623

    #console.log app.me
    #if app.me.get('height').value == "" || isNaN(app.me.get('height').value)
    #  app.me.get('height').value = 0
    #if app.me.get('weight').value == "" || isNaN(app.me.get('weight').value)
    #  app.me.get('weight').value = 0
    #if app.me.get('desired_weight').value == "" || isNaN(app.me.get('desired_weight').value)
    #  app.me.get('desired_weight').value = 0


    #app.me.get('height').value *= heightFactor
    #app.me.get('weight').value *= weightFactor
    #app.me.get('desired_weight').value *= weightFactor




  onNextStep: =>

    if @checkValidation()

      app.me.get('height').units = "cm"
      app.me.get('weight').units = "kg"
      app.me.get('desired_weight').units = "kg"

      app.me.get('height').value = $("#height").val()
      app.me.get('weight').value = $("#weight").val()
      app.me.get('desired_weight').value = $("#desire").val()

      widgets = app.me.get('widgets')
      unless widgets?
        widgets = {}

      widgets.meassure = @unit
      app.me.set 'widgets', widgets

      if moment().diff(moment(@dob), 'years') > 0
        app.me.set('dob', @dob)
        app.me.set('gender', $('.bfh-selectbox[data-id=gender]').val())
        if app.me.get('gender') == 'F'
          app.me.set('pregnant', $('input[name=pregnant]:checked', @$el).val())
          app.me.set('breastfeeding', $('input[name=breastfeeding]:checked', @$el).val())

        console.log(app.me)
        app.me.save {},
          success: (model, data, xhr) ->
            unless data.error
              app.routers[1].navigate("life", {trigger: true})

  validateEmail:(email)->
    re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);

  checkValidation:()->
    @clearMessages()
    valid=true
    if $("#firstname1").val() == ""
      valid=false
      $("#firstname_error").show()
      $("#firstname_error").empty()
      $("#firstname_error").append("Please enter your firstname")
      $("#firstname1").addClass 'error'

    if $("#lastname1").val() == ""
      valid=false
      $("#lastname_error").show()
      $("#lastname_error").empty()
      $("#lastname_error").append("Please enter your lastname")
      $("#lastname1").addClass 'error'

    if $("#email").val() == "" || !@validateEmail($("#email").val())
      valid=false
      $("#email_error").show()
      $("#email_error").empty()
      $("#email_error").append("Please enter a valid email")
      $("#email").addClass 'error'

    if $("#days").val() == "" || $("#month").val() == "" || $("#year").val() == ""
      valid=false
      $("#birthday_error").show()
      $("#birthday_error").empty()
      $("#birthday_error").append("Please enter your birthday")
      if $("#days").val() == ""
        $("#days a").addClass 'error'
      if $("#month").val() == ""
        $("#month a").addClass 'error'
      if $("#days").val() == ""
        $("#year a").addClass 'error'

    if $("#gender").val() == ""
      valid=false
      $("#gender_error").show()
      $("#gender_error").empty()
      $("#gender_error").append("Please select your gender")

    if $("#height").val() == ""
      valid=false
      $("#height_error").show()
      $("#height_error").empty()
      $("#height_error").append("Please enter your height")
      $("#height").addClass 'error'
      $("#height").parent().find('span').addClass 'error'

    if $("#weight").val() == ""
      valid=false
      $("#weight_error").show()
      $("#weight_error").empty()
      $("#weight_error").append("Please enter your weight")
      $("#weight").addClass 'error'
      $("#weight").parent().find('span').addClass 'error'

    if $("#desire").val() == ""
      valid=false
      $("#desire_error").show()
      $("#desire_error").empty()
      $("#desire_error").append("Please enter your desire")
      $("#desire").addClass 'error'
      $("#desire").parent().find('span').addClass 'error'

    return valid

  clearMessages:()->
    $("#firstname_error").show()
    $("#firstname_error").empty()
    $("#firstname1").removeClass 'error'
    $("#lastname_error").show()
    $("#lastname_error").empty()
    $("#lastname1").removeClass 'error'
    $("#email_error").show()
    $("#email_error").empty()
    $("#email").removeClass 'error'
    $("#birthday_error").show()
    $("#birthday_error").empty()
    $("#dyas a").addClass 'error'
    $("#month a").addClass 'error'
    $("#year a").addClass 'error'
    $("#gender_error").show()
    $("#gender_error").empty()
    $("#height_error").show()
    $("#height_error").empty()
    $("#weight_error").show()
    $("#weight_error").empty()
    $("#desire_error").show()
    $("#desire_error").empty()

  onChangeUnit: (event) ->
    event.preventDefault()
    @$('.unit-selector').removeClass('active')

    # we don't process if same unit
    return if @$(event.currentTarget).addClass('active').data('unit') == @unit

    @unit = @$(event.currentTarget).addClass('active').data('unit')

    if @unit == 'imperial'
      $("#imperial").show()
      $("#metric").hide()
      @weightUnit = 'lb'
      @heightUnit = 'inch'
    else
      $("#metric").show()
      $("#imperial").hide()
      @weightUnit = 'kg'
      @heightUnit = 'cm'

  _calculateBMI: (height, weight) ->
    return 0 if height == 0
    if @unit == 'metric'
      return (weight * 10000) / (height * height)  # 10000 is to convert from cm2 to m2
    else
      return (weight * 703) / (height * height)

  onChangeDateInput: (event) =>
    $("#dayhidden").val(1)
    value = @$(event.currentTarget).val()
    map = {
      month: 'setMonth'
      year: 'setFullYear'
      days: 'setDate'
    }
    @dob[map[$(event.currentTarget).data('name')]](parseInt(value)) unless isNaN(parseInt(value))

  onChangeInput: (event) ->
    changed = event.currentTarget
    value = @$(event.currentTarget).val()

    obj = {}
    if changed.name
      obj[changed.name] = if $(event.currentTarget).is(':checkbox') then $(event.currentTarget).is(':checked') else value
    else
      obj[$(event.currentTarget).data('name')] = value

    app.me.set(obj)

    # if need to show pregnant question
    if $(event.currentTarget).data('name') == 'gender'
      if value == 'female'
        @$('.pregnant').fadeIn 500
      else
        @$('.pregnant').fadeOut 500


  onChangeHealthInput: (event) ->
    changed = event.currentTarget
    value = @$(event.currentTarget).val()

    obj = app.me.get(changed.name)
    obj['value'] = parseInt(value)
    obj['units'] = @unit

    @$('#bmi-value').text(@_calculateBMI(app.me.get('height').value, app.me.get('weight').value))

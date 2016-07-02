class App.Views.Main.Settings.MyProfile.Index extends App.Views.Base
  template: JST['app/main/settings/my_profile/index.html']
  className: 'tab-pane fade in'
  id: 'profile'

  @patientPreferences = null
  options:
    active: false

  initialize: (options) =>
    super


    @on 'crop_done', @onPersonalInformationUpdate

  setupSubviews: () =>
    @crop_avatar = new App.Views.Common.Main.Crop.Index
      field: 'avatar'
      crop_w: 120
      crop_h: 120
      onUploadAndCrop: @onPersonalInformationUpdate


    @my_profile_account = new App.Views.Main.Settings.MyProfile.AccountInfo
      hidden: false

    @my_profile_change_password = new App.Views.Main.Settings.MyProfile.ChangePassword
      hidden: false

    @my_profile_delete = new App.Views.Main.Settings.MyProfile.DeleteAccount
      hidden: false


  events:
    'click [data-role=update-peronal-info]': 'onPersonalInformationUpdate'
    'change .bfh-selectbox[data-id=gender]':'onChangeGender'
    # 'change #avatar': 'onAvatarChange'

  render: () =>
    super
    @setupSubviews()
    # crop avatar view
    @appendView @crop_avatar.render(), '[data-role="upload-avatar"]'
    # my profile extra boxes
    @appendView @my_profile_account.render(), '[data-role=account_information]'

    if app.me.get("facebook_id")==undefined
      @appendView @my_profile_change_password.render(), '[data-role=change_password]'

    @appendView @my_profile_delete.render(), '[data-role=delete_account]'


    @$el.addClass('active') if @options.active

    $('.bfh-selectbox[data-id=gender]', @$el).bfhselectbox({
      value: app.me.get('gender')
    })

    $('.bfh-selectbox[data-id=pregnant]', @$el).bfhselectbox({
      value: app.me.get("pregnant")
    })

    $('.bfh-selectbox[data-id=breastfeeding]', @$el).bfhselectbox({
      value: app.me.get("breastfeeding")
    })

    $('.bfh-selectbox[data-id=year]', @$el).bfhselectbox({
      value: moment(app.me.escape('dob')).format('YYYY')
    })
    $('.bfh-selectbox[data-id=month]', @$el).bfhselectbox({
      value: moment(app.me.escape('dob')).format('MM')
    })
    $('.bfh-selectbox[data-id=day]', @$el).bfhselectbox({
      value: moment(app.me.escape('dob')).format('DD')
    })
    $('.bfh-selectbox[data-id=height_units]', @$el).bfhselectbox({
      value: app.me.get('height').units
    })
    $('.bfh-selectbox[data-id=weight_units]', @$el).bfhselectbox({
      value: app.me.get('weight').units
    })
    $('.bfh-selectbox[data-id=desired_weight_units]', @$el).bfhselectbox({
      value: app.me.get('desired_weight').units
    })

    # $(":file", @$el).jfilestyle({input: false, buttonText: "", icon: false})

    id = null
    if app.me.get('patientPreferences') instanceof Object
      id = app.me.get('patientPreferences')._id
    else
      id = app.me.get('patientPreferences')

    @patientPreferences = new App.Models.PatientPreferences({_id: id })
    @patientPreferences.fetch()

    #@listenToOnce @patientPreferences,'sync',@render
    # Helpers.generateSlider($('#height', @$el)) if app.me.get("widgets").meassure == "imperial"

    $('.bfh-selectbox[data-id=gender]', @$el).on('change.bfhselectbox', () =>
      if $('.bfh-selectbox[data-id=gender]').val() == "F"
        $("#femaleOptions", @$el).slideDown('slow')
        #$(".personal_info", @$el).animate({height:465},500)
      else
        $("#femaleOptions", @$el).slideUp('slow')
        #$(".personal_info", @$el).animate({height:345},500)

    );

    if app.me.get('gender') == "F"
      $("#femaleOptions", @$el).slideDown('slow');
      #$(".personal_info", @$el).animate({height:465},500);

    $("[name=breastfeeding]", @$el).filter("[value=#{app.me.get('breastfeeding')}]").prop('checked', true)
    $("[name=pregnant]", @$el).filter("[value=#{app.me.get('pregnant')}]").prop('checked', true)
    return this

  getContext: =>
    return {model: app.me}

  onChangeGender:()->
    if $('.bfh-selectbox[data-id=gender]', @$el).val() == "F"
      $("#femaleOptions").fadeIn 'slow'
    else
      $("#femaleOptions").fadeOut 'slow'

  getCaloriesPerDay:(activity,newGender,newIsPregnant,newIsBreastfeeding)->
    #get gender coeficient
    genderCoeficient = 0
    ageCoeficient = 0
    if newGender=="M"
      genderCoeficient = 66
      ageCoeficient = 6.7
    else
      genderCoeficient = 665
      ageCoeficient = 4.6

    #get activity coeficient
    activityCoeficient = 1
    activityStatus = activity
    if activityStatus == "sedentary"
      activityCoeficient = 1.2
    else if activityStatus == "light"
      activityCoeficient = 1.5
    else if activityStatus == "active"
      activityCoeficient = 1.7
    else if activityStatus == "very_active"
      activityCoeficient = 1.9

    #Check if weigth is in cms.
    weight = 0
    weight = parseFloat(app.me.get("weight").value)

    #Check if desired_weight is in cms.
    desired_weight = 0;
    desired_weight = parseFloat(app.me.get("desired_weight").value)

    goal=0
    if newGender == "M"
      if desired_weight < weight
        goal=parseInt(-500)
      else if desired_weight > weight
        goal=parseInt(700)
      else if desired_weight == weight
        goal=0
    else
      if newIsPregnant == "Yes"
        goal=300
        if app.me.get("breastfeeding") == "Yes"
         goal= goal + 500
      else
        if desired_weight < weight
          goal=parseInt(-500)
        else if desired_weight > weight
          goal=parseInt(700)
        else if desired_weight == weight
          goal=0

    #Get years.
    years = new moment().diff(app.me.get('dob'), 'years')

    #get height
    height=0
    heigth = parseFloat(app.me.get("height").value)
    #now calculate recomended calories.
    calories = ((genderCoeficient + (12.7 * weight) + (5 * height) - (ageCoeficient * years)) * activityCoeficient) + goal

    @caloriesRecommended = parseInt(calories)

    return @caloriesRecommended

  onPersonalInformationUpdate: (event) =>
    event.preventDefault() if event?.preventDefault?
    fields = @getFormInputs $('[data-role="personal-info-form"]', @el), ['avatar']

    height = 0
    weight = 0
    desire = 0
    if app.me.get("widgets").meassure == "metric"
      height = fields.height
      weight = fields.weight
      desire = fields.desired_weight
    else
      heightFactor = 1.0 / 0.39370
      weightFactor = 1.0 / 2.204623
      height = parseFloat(Helpers.getCmFromFtInch(fields.height_ft, fields.height_in))
      weight = parseFloat(fields.weight * weightFactor).toFixed(0)
      desire = parseFloat(fields.desired_weight * weightFactor).toFixed(0)

    data = {
      first_name: fields.first_name
      last_name: fields.last_name

      gender: fields.gender
      status: '0' # check the config.coffee
      height:
        value: height
        units: 'cm'
      weight:
        value: weight
        units: 'kg'

      desired_weight:
        value: desire
        units: 'kg'
    }

    console.log "calories y water updated"

    app.me.set 'dob', moment("#{fields.year}-#{fields.month}-#{fields.day}", "YYYY-MM-DD").toISOString(), {silent: true} if fields.year != '' and fields.month != '' and fields.day != ''

    app.me.set 'pregnant', $('[name=pregnant]:checked', this.$el).val(), {silent: true}
    app.me.set 'breastfeeding', $('[name=breastfeeding]:checked', this.$el).val(), {silent: true}

    app.me.set 'height', data.height, {silent: true}
    app.me.set 'weight', data.weight, {silent: true}
    app.me.set 'desired_weight', data.desired_weight, {silent: true}

    activity = app.me.get('patientPreferences').activity
    weather = app.me.get('patientPreferences').weather

    app.me.set "water_recomended", Helpers.getWaterConsumtion(activity,data.weight.value,weather).toFixed(1), {silent: true}
    app.me.set "calories_recomended", Helpers.getCaloriesPerDay(activity), {silent: true}

    app.me.set(data, {silent: true})
    put_data = app.me.toJSON()
    delete put_data.avatar

    @$el.block()
    $('[data-role="personal-info-form"]', @$el).ajaxSubmit({
      url: app.me.url()
      # url: '/api/v1/image_crop_upload'
      type: "put"
      data: _.omit put_data, ['_id', 'id', 'pregnant', 'breastfeeding']
      success: (data, xhr) =>
        $('#nav-img').attr('src', data.avatar_thumb)
        $('#nav-img').attr('alt', data.full_name)
        $('[data-role=avatar-preview]', @$el).attr('src', data.avatar_thumb)
        app.me.set(data)
        @$el.unblock()
        @fire 'reload_goals'
      error: () =>
        console.log "errors: ", arguments
        @$el.unblock()
    });

    #app.me.save()

class App.Views.Main.Settings.Preferences.Index extends App.Views.Base
  template: JST['app/main/settings/preferences/index.html']
  className: 'tab-pane fade'
  id: 'preferences'

  options:
    active: false

  @preferenceList=null
  @patientPreferences = null
  @preferences = null
  @count=0
  @countFood=0
  that=null
  @physicalLimitation=null
  @foods=null

  initialize: (options) =>
    that=@
    super
    @count=0
    @countFood=0
    @notifications = new App.Views.Main.Settings.Preferences.Notifications
      hidden: false

    #@preferences = new App.Collections.Preference()
    #@preferences.fetch()

    @foods = new App.Collections.FoodLimitation()
    @physicalLimitation = new App.Collections.PhysicalLimitation()
    @medicines = new App.Collections.Medicines()
    @suplements = new App.Collections.Suplements()


    @patientPreferences = new App.Models.PatientPreferences(app.me.get('patientPreferences'))
    #async.series
    # [@loadFoods, @loadPhysicalLimitation],
    #  (error) ->


    async.series([
      @loadFoods,
      @loadPhysicalLimitation,
      @loadMedicines,
      @loadSuplements,
      # @loadPatientPreference
    ], (err, results) =>
      @render()
    )

    @addTemplate = '<li><input type="text" class="form-control add" value="" placeholder="Write here"><a href="" class="icon-delete"></a></li>'

    #async.series(
    #  'loadPhysicalLimitation': (done) =>
    #    @physicalLimitation.fetch
    #      success:(data)=>
    #        done(data)
    #
    #  'loadFoods': (done) =>
    #    @foods.fetch
    #      success:(data)->
    #        done(data)

    #  'loadPatientPreference': (done) =>
    #    @patientPreferences.fetch
    #      success:(data)=>
    #        done(data)

    #  (err, results) =>
    #    @render()

    #)

    #@listenTo @patientPreferences, 'sync', @loadPreference
    #@listenTo @preferences, 'sync', @render

    @

  events:
    #'click [data-role="update"]': 'onUpdate'
    'click #savePreference':'onUpdate'
    'click #addPhysicalLimitation':'onAddPhysicalLimitation'
    'click #addFoodLimitation':'onAddFoodLimitation'
    'click #addMedicineLimitation':'onAddMedicineLimitation'
    'click #addDiseaseLimitation':'onAddDiseaseLimitation'
    'click .add-more': 'onAddMore'
    'click a.icon-delete': 'removeItem'
    'ifChecked .terms input[type=checkbox]': 'onItemChecked'
    'ifUnchecked .terms input[type=checkbox]': 'onItemUnchecked'
    'click .add button': 'onAddMoreFirstTime'

  getContext: =>
    return {
      patientPreferences: @patientPreferences,
      foods:@foods,
      physicalLimitation:@physicalLimitation,
      medicines:@medicines,
      suplements:@suplements
    }

  loadFoods:(callback)=>
    @foods.fetch
      success:(data) =>
        callback()

  loadPhysicalLimitation:(callback) =>
    @physicalLimitation.fetch
      success:() =>
        callback()

  loadMedicines:(callback)=>
    @medicines.fetch
      success:(data) =>
        callback()


  loadSuplements:(callback)=>
    @suplements.fetch
      success:(data) =>
        callback()


  loadPatientPreference:(callback) =>
    @patientPreferences.fetch
      success:()=>
        callback()


  loadPreference:() =>
    @preferences.fetch
      success:(data)->
        that.preferenceList=data
        console.log "that.preferenceList"
        console.log that.preferenceList
        that.render()

  render: () =>
    super
    # my preferences extra boxes
    @appendView @notifications.render(), '[data-role=notifications]'

    if app.me.get("patient_preferences") != null && app.me.get("patient_preferences") != undefined
      for disease in app.me.get('patientPreferences').diseases
        $("input[value='#{disease}']", @$el).click()

    if($(".terms").length > 0)
      $('.terms input').iCheck
        checkboxClass: 'icheckbox_minimal-green'

    $(".boxes .box ul").mCustomScrollbar({
        autoHideScrollbar:true,
        advanced:{
            updateOnContentResize: true
            autoScrollOnFocus: false
        }
    });

    @_showItems('limitations') if @physicalLimitation.length > 0 or @patientPreferences.get('limitations').length > 0
    @_showItems('food') if @foods.length > 0 or @patientPreferences.get('foods').length > 0
    @_showItems('medicines') if @medicines.length > 0 or @patientPreferences.get('medicines').length > 0
    @_showItems('vitamins') if @suplements.length > 0 or @patientPreferences.get('vitamins').length > 0

    $('.box-body ul', @$el).mCustomScrollbar(
      autoHideScrollbar:true,
      live: true
      advanced:
        updateOnContentResize: true
    )

    return this


  _showItems: (type) =>
    $box = $("[data-role=#{type}]", @$el)
    $('.ok', $box).css('display', 'none')
    $('.add', $box).css('display', 'none')
    $('ul', $box).css('display', 'block')

    $('.terms', $box).css('display', 'none')
    $('.more', $box).css('display', 'block')



  onUpdate: (event) =>
    #alert 1
    event.preventDefault()


    fields = @getFormInputs $('[data-role="app_preferences"]', @el), ['']

    fields.diseases = [] unless fields.diseases?

    #fields.limitations = ["11","sd","sdf"]

    #app.me.get("patientPreferences").limitations = ["11","sd","sdf"]
    #app.me.save()

    console.log "Physical limitations"
    fields.limitations = []
    $.each $(".physical"), (index,item)->
      if $(item).is ':checked'
        fields.limitations.push(item.value)

    $.each $("#physicalList input.add"), (index, input) =>
      fields.limitations.push(input.value)

    fields.foods = []
    $.each $(".foods"), (index,item)->
      if $(item).is ':checked'
        fields.foods.push(item.value)

    $.each $("#foodList input.add"), (index, input) =>
      fields.foods.push(input.value)

    fields.medicines = []
    $.each $(".medicines"), (index,item)->
      if $(item).is ':checked'
        fields.medicines.push(item.value)

    $.each $("#medicineList input.add"), (index, input) =>
      fields.medicines.push(input.value)

    fields.vitamins = []
    $.each $(".suplements"), (index,item)->
      if $(item).is ':checked'
        fields.vitamins.push(item.value)

    $.each $("#diseaseList input.add"), (index, input) =>
      fields.vitamins.push(input.value)

    #patient_preferences = new App.Models.PatientPreferences({_id: app.me.get('patientPreferences')._id })
    #@patientPreferences.set "_id", app.me.get('patientPreferences')._id
    console.log("Antes de guardar")
    console.log @patientPreferences
    #alert "Revisar logs"
    @patientPreferences.set "limitations", fields.limitations
    @patientPreferences.set "foods", fields.foods
    @patientPreferences.set "medicines", fields.medicines
    @patientPreferences.set "vitamins", fields.vitamins

    @$el.block()
    @patientPreferences.save {},
      wait: true
      success: (model, response) =>
        @$el.unblock()

        app.me.setValue {patientPreferences: model.toJSON()}
        #$.notify.defaults({ className: "success" });
        #$.notify("You've succesfully updated your progress.",{globalPosition: 'bottom right'});

      error: (model, response) =>
        @$el.unblock()
        console.log "ERROR patient prefernces: ", model, response


  onAddPhysicalLimitation:()->
    $("#physicalList .mCSB_container .mCS_no_scrollbar").append('<li id="text_' + @count + '">
      <label id="textLbl_' + @count + '" onclick="showText(' + @count + ',this)" style="display:none;"></label>
      <input id="textInput_' + @count + '" onkeyup="onEnter(' + @count + ',this,event)" type="text" value="" class="physical" placeholder="Write here" style="width: 199px;">
      <a onclick="removeElem(' + @count + ')" href="javascript:void(0)">borrar</a>
      </li>')
    @count++

  onAddFoodLimitation:()->
    $("#foodList .mCSB_container .mCS_no_scrollbar").append('<li id="text_' + @count + '">
      <label id="textLbl_' + @count + '" onclick="showText(' + @count + ',this)" style="display:none;"></label>
      <input id="textInput_' + @count + '" onkeyup="onEnter(' + @count + ',this,event)" type="text" value="" class="food" placeholder="Write here" style="width: 199px;">
      <a onclick="removeElem(' + @count + ')" href="javascript:void(0)">borrar</a>
      </li>')
    @count++

  onAddMedicineLimitation:()->
    $("#medicineList .mCSB_container .mCS_no_scrollbar").append('<li id="text_' + @count + '">
      <label id="textLbl_' + @count + '" onclick="showText(' + @count + ',this)" style="display:none;"></label>
      <input id="textInput_' + @count + '" onkeyup="onEnter(' + @count + ',this,event)" type="text" value="" class="medicine" placeholder="Write here" style="width: 199px;">
      <a onclick="removeElem(' + @count + ')" href="javascript:void(0)">borrar</a>
      </li>')
    @count++

  onAddDiseaseLimitation:()->
    $("#diseaseList .mCSB_container .mCS_no_scrollbar").append('<li id="text_' + @count + '">
      <label id="textLbl_' + @count + '" onclick="showText(' + @count + ',this)" style="display:none;"></label>
      <input id="textInput_' + @count + '" onkeyup="onEnter(' + @count + ',this,event)" type="text" value="" class="disease" placeholder="Write here" style="width: 199px;">
      <a onclick="removeElem(' + @count + ')" href="javascript:void(0)">borrar</a>
      </li>')
    @count++

  onAddMore: (event) ->
    $ele = @$(event.currentTarget)

    if $ele.closest('.box-body').find('ul li:last').length > 0
      $(@addTemplate).insertAfter($ele.closest('.box-body').find('ul li:last'))
    else
      $ele.closest('.box-body').find('ul .mCSB_container').append(@addTemplate)

  removeItem: (event) ->
    event.preventDefault()
    @$(event.currentTarget).closest('li').remove()

  onItemChecked: (event) ->
    $ele = @$(event.currentTarget)
    $ele.closest('.box-body').find('.ok').fadeIn 'slow'

  onItemUnchecked: (event) ->
    $ele = @$(event.currentTarget)
    $ele.closest('.box-body').find('.ok').fadeOut 'slow'

  onAddMoreFirstTime: (event) ->
    event.preventDefault()
    $(event.currentTarget).parent().fadeOut 'slow', ->
      $(event.currentTarget).parent().parent().find('ul').fadeIn 'slow'
    $(event.currentTarget).parent().parent().find('.box-foot .terms').fadeOut 'slow', ->
      $(event.currentTarget).parent().parent().find('.box-foot .more').fadeIn 'slow'

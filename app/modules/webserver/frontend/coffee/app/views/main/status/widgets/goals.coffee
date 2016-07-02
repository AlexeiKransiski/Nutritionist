# TODO: maybe this later will have a base class to share based code with "Your checklist" in Dashboard
class App.Views.Main.Status.Widgets.Goals extends Null.Views.Base
  template: JST['app/main/status/widgets/goals.html']


  events: 
    'ifChecked li input[type=checkbox]': 'onItemChecked'
    'ifUnchecked li input[type=checkbox]': 'onItemUnchecked'
    'click #mychecklist a': 'onSelectPanel',
    'click #add_new' : 'onAddNew'
    'keyup .newcheckelement':'onSaveCheckListItem'
    'click #fitnessTab' : 'onFitnessTab'
    'click #nutritionalTab' : 'onNutritionalTab'
    'click #mentalTab' : 'onMentalTab'

  @result
  


  initialize: ->
    super

    @totalFitnessItems=0;
    @totalFitnessDone=0;

    @totalNutritionalItems=0;
    @totalNutritionalDone=0;

    @totalMentalItems=0;
    @totalMentalDone=0;

    @goals = new App.Collections.Goal()

    @listenTo(@goals, 'reset', @filterChecklistItems)

    @goals.fetch
      reset: true
      data:
        user: app.me.id

    @on 'checkitem:remove', @filterChecklistItems
    @on 'checkitem:update_add', @checklistUpdateAdd
    @on 'checkitem:update_remove', @checklistUpdateRemove

    @

  checklistUpdateAdd:()->
      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'fitness'
          @totalFitnessDone=parseInt(@totalFitnessDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalFitnessDone + '/' +  @totalFitnessItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'nutritional'
          @totalNutritionalDone=parseInt(@totalNutritionalDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalNutritionalDone + '/' +  @totalNutritionalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'mental'
          @totalMentalDone=parseInt(@totalMentalDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalMentalDone + '/' +  @totalMentalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')    


  checklistUpdateRemove:()->
      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'fitness'
          @totalFitnessDone=parseInt(@totalFitnessDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalFitnessDone + '/' +  @totalFitnessItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'nutritional'
          @totalNutritionalDone=parseInt(@totalNutritionalDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalNutritionalDone + '/' +  @totalNutritionalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'mental'
          @totalMentalDone=parseInt(@totalMentalDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalMentalDone + '/' +  @totalMentalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')    


  onFitnessTab:()->
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalFitnessDone + '/' +  @totalFitnessItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

  onNutritionalTab:()->
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalNutritionalDone + '/' +  @totalNutritionalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

  onMentalTab:()->
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalMentalDone + '/' +  @totalMentalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')    

  filterChecklistItems:() ->

    @totalFitnessItems=0;
    @totalFitnessDone=0;

    @totalNutritionalItems=0;
    @totalNutritionalDone=0;

    @totalMentalItems=0;
    @totalMentalDone=0;

    @fitness = @goals.filter( (model) -> model.get('type') == 'fitness')
    @nutritional = @goals.filter( (model) -> model.get('type') == 'nutritional')
    @mental = @goals.filter( (model) -> model.get('type') == 'mental')

    console.log "@nutritional"
    console.log @nutritional
    #@nutritional.each @addWeekChecklist

    @totalFitnessItems=@fitness.length;
    $("#fitnessChecklist").empty()
    for ci in @fitness
      view = new App.Views.Main.Status.Widgets.GoalItem({model:ci})
      @appendView view.render(), '#fitnessChecklist'
      $('.sidebar-right li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
      });
      console.log "totalFitnessDone"
      if ci.get("done")
        @totalFitnessDone = parseFloat(@totalFitnessDone) + parseFloat(1)


    @totalNutritionalItems=@nutritional.length;
    $("#nutritionalChecklist").empty()
    for ci in @nutritional
      view = new App.Views.Main.Status.Widgets.GoalItem({model:ci})
      @appendView view.render(), '#nutritionalChecklist'
      $('.sidebar-right li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
      });
      if ci.get("done")
        @totalNutritionalDone = parseFloat(@totalNutritionalDone) + parseFloat(1)

    @totalMentalItems=@mental.length;
    $("#mentalChecklist").empty()
    for ci in @mental
      view = new App.Views.Main.Status.Widgets.GoalItem({model:ci})
      @appendView view.render(), '#mentalChecklist' 
      $('.sidebar-right li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
      });   
      if ci.get("done")
        @totalMentalDone = parseFloat(@totalMentalDone) + parseFloat(1)



    #alert $('.sidebar-right .tab-content').find('.active').attr('id')

    if $('.sidebar-right .tab-content').find('.active').attr('id') == 'fitness'
      $("#resumeTasks").empty()
      $("#resumeTasks").append(@totalFitnessDone + '/' +  @totalFitnessItems + ' COMPLETED GOAL... <span class="pull-right">KEEP GOING!</span>')

    if $('.sidebar-right .tab-content').find('.active').attr('id') == 'nutritional'
      $("#resumeTasks").empty()
      $("#resumeTasks").append(@totalNutritionalDone + '/' +  @totalNutritionalItems + ' COMPLETED GOAL... <span class="pull-right">KEEP GOING!</span>')

    if $('.sidebar-right .tab-content').find('.active').attr('id') == 'mental'
      $("#resumeTasks").empty()
      $("#resumeTasks").append(@totalMentalDone + '/' +  @totalMentalItems + ' COMPLETED GOAL... <span class="pull-right">KEEP GOING!</span>')    


  render: ->
    super

    @$('li input[type=checkbox]').iCheck checkboxClass: 'icheckbox_minimal-green'

    if @$('.today').length > 0
      @$('.today').mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true
    if @$('.weeks').length > 0
      @$('.weeks').mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true
    if @$('.month').length > 0
      @$('.month').mCustomScrollbar
        autoHideScrollbar: true
        advanced: updateOnContentResize: true

    # first counting
    total = @goals.filter( (model) -> model.get('type') == 'fitness' ).length
    done = @goals.filter( (model) -> model.get('type') == 'fitness' and model.get('done') ).length

    @$('#counting').text("#{done}/#{total}")

    @

  onItemChecked: (event) ->
    text = @$(event.currentTarget).parent().parent().find('label').html()
    @$(event.currentTarget).parent().parent().find('label').empty().append '<del>' + text + '</del>'

  onItemUnchecked: (event) ->
    text = @$(event.currentTarget).parent().parent().find('label').text()
    @$(event.currentTarget).parent().parent().find('label').empty().append text

  onSelectPanel: (event) ->
    tabSelected = @$(event.currentTarget).data('checklist')
    total = @goals.filter( (model) -> model.get('type') == tabSelected ).length
    done = @goals.filter( (model) -> model.get('type') == tabSelected and model.get('done') ).length

    @$('#counting').text("#{done}/#{total}")

  onAddNew:() ->
    list = $('.sidebar-right .tab-content').find('.active').attr('id');
    new_task = "<input type=\'text\' class=\'form-control newcheckelement\' placeholder=\'New\' />";
    $('#'+list+ ' div ul').before(new_task);
    $('.sidebar-right .tab-content .active input[type=text]').focus();

  onSaveCheckListItem: (e)->
    console.log "e"
    console.log e
    if e.keyCode == 13
      if e.currentTarget.value == ""
        e.currentTarget.remove()
      else  
        data =
          description:e.currentTarget.value
          done:false
          type: $('.sidebar-right .tab-content').find('.active').attr('id')
          user:app.me.id
            
        checkList = new App.Models.Goal(data)
        checkList.save()
        @goals.fetch
          reset: true
          data:
            user: app.me.id
        e.currentTarget.remove()

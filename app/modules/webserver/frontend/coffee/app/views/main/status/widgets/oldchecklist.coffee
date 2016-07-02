class App.Views.Main.Status.Widgets.Checklist extends Null.Views.Base 
  template: JST['app/main/status/widgets/checklist.html']

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

    @goals = new App.Collections.Checklist()

    @listenTo(@goals, 'reset', @filterChecklistItems)

    @goals.fetch reset: true

    @on 'checkitem:remove', @filterChecklistItems
    @on 'checkitem:update_add', @checklistUpdateAdd
    @on 'checkitem:update_remove', @checklistUpdateRemove

    @

  checklistUpdateAdd:()->
      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'daily'
          @totalFitnessDone=parseInt(@totalFitnessDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalFitnessDone + '/' +  @totalFitnessItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'weekly'
          @totalNutritionalDone=parseInt(@totalNutritionalDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalNutritionalDone + '/' +  @totalNutritionalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'monthly'
          @totalMentalDone=parseInt(@totalMentalDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalMentalDone + '/' +  @totalMentalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')    


  checklistUpdateRemove:()->
      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'daily'
          @totalTodayDone=parseInt(@totalFitnessDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalFitnessDone + '/' +  @totalFitnessItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'weekly'
          @totalWeekDone=parseInt(@totalNutritionalDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalNutritionalDone + '/' +  @totalNutritionalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'monthly'
          @totalMonthDone=parseInt(@totalMentalDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalMentalDone + '/' +  @totalMentalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')    


  onDailyTab:()->
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalFitnessDone + '/' +  @totalFitnessItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

  onWeekTab:()->
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalNutritionalDone + '/' +  @totalNutritionalItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

  onMonthTab:()->
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


    @totalFitnessItems=@daily.length;
    $("#fitnessChecklist").empty()
    for ci in @daily
      view = new App.Views.Main.Status.Widgets.ChecklistItem({model:ci})
      @appendView view.render(), '#fitnessChecklist'
      $('.sidebar-right li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
      });
      console.log "totalFitnessDone"
      if ci.get("done")
        @totalFitnessDone = parseFloat(@totalFitnessDone) + parseFloat(1)


    @totalWeekItems=@weekly.length;
    $("#weeklyChecklist").empty()
    for ci in @weekly
      view = new App.Views.Main.Dashboard.Widgets.ChecklistItem({model:ci})
      @appendView view.render(), '#weeklyChecklist'
      $('.sidebar-right li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
      });
      if ci.get("done")
        @totalWeekDone = parseFloat(@totalWeekDone) + parseFloat(1)

    @totalMonthItems=@monthly.length;
    $("#monthlyChecklist").empty()
    for ci in @monthly
      view = new App.Views.Main.Dashboard.Widgets.ChecklistItem({model:ci})
      @appendView view.render(), '#monthlyChecklist' 
      $('.sidebar-right li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
      });   
      if ci.get("done")
        @totalMonthDone = parseFloat(@totalMonthDone) + parseFloat(1)





      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'daily'
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalTodayDone + '/' +  @totalTodayItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'weekly'
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalWeekDone + '/' +  @totalWeekItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'monthly'
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalMonthDone + '/' +  @totalMonthItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')    


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
    total = @goals.filter( (model) -> model.get('type') == 'daily' ).length
    done = @goals.filter( (model) -> model.get('type') == 'daily' and model.get('done') ).length

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
            
        checkList = new App.Models.ChecklistItem(data)
        checkList.save()
        @goals.fetch reset: true
        e.currentTarget.remove()

    


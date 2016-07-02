class App.Views.Main.Dashboard.Widgets.Checklist extends Null.Views.Base
  template: JST['app/main/dashboard/widgets/checklist.html']
  className: 'sidebar-right'

  events:
    # 'click li input[type=checkbox]': 'onItemChecked'
    # 'ifUnchecked li input[type=checkbox]': 'onItemUnchecked'
    'click #mychecklist a': 'onSelectPanel',
    'click #add_new' : 'onAddNew'
    'submit [data-role="new-item-form"]': 'onAddNew'

    # 'keyup .newcheckelement':'onSaveCheckListItem'
    #'click .input-group .btn-default': 'onSaveCheckListItem'
    'click #dailyTab' : 'onDailyTab'
    'click #weekTab' : 'onWeekTab'
    'click #monthTab' : 'onMonthTab'

  initialize: =>
    super

    @totalTodayItems = 0;
    @totalTodayDone = 0;

    @totalWeekItems = 0;
    @totalWeekDone = 0;

    @totalMonthItems = 0;
    @totalMonthDone = 0;

    @goals = new App.Collections.Checklist()

    @listenTo(@goals, 'reset', @filterChecklistItems)

    @goals.fetch
      reset: true
      data:
        user: app.me.id

    @on 'checkitem:remove', @filterChecklistItems
    @on 'checkitem:update_add', @checklistUpdateAdd
    @on 'checkitem:update_remove', @checklistUpdateRemove

    return this

  render: =>
    super

    @$('li input[type=checkbox]').iCheck checkboxClass: 'icheckbox_minimal-green'
    $('.todos-list', @$el).mCustomScrollbar({
      autoHideScrollbar:true,
      # live: true,
      advanced: {
        updateOnContentResize: true
        autoScrollOnFocus: false
      }
    })

    # first counting
    total = @goals.filter( (model) => model.get('type') == 'daily' ).length
    done = @goals.filter( (model) => model.get('type') == 'daily' and model.get('done') ).length

    @$('#counting').text("#{done}/#{total}")

    return this

  checklistUpdateAdd:() =>
      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'daily'
          @totalTodayDone=parseInt(@totalTodayDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalTodayDone + '/' +  @totalTodayItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'weekly'
          @totalWeekDone=parseInt(@totalWeekDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalWeekDone + '/' +  @totalWeekItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'monthly'
          @totalMonthDone=parseInt(@totalMonthDone) + 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalMonthDone + '/' +  @totalMonthItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')


  checklistUpdateRemove:() =>
      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'daily'
          @totalTodayDone=parseInt(@totalTodayDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalTodayDone + '/' +  @totalTodayItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'weekly'
          @totalWeekDone=parseInt(@totalWeekDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalWeekDone + '/' +  @totalWeekItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

      if $('.sidebar-right .tab-content').find('.active').attr('id') == 'monthly'
          @totalMonthDone=parseInt(@totalMonthDone) - 1
          $("#resumeTasks").empty()
          $("#resumeTasks").append(@totalMonthDone + '/' +  @totalMonthItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')


  onDailyTab:()=>
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalTodayDone + '/' +  @totalTodayItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

  onWeekTab:()=>
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalWeekDone + '/' +  @totalWeekItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

  onMonthTab:()=>
    $("#resumeTasks").empty()
    $("#resumeTasks").append(@totalMonthDone + '/' +  @totalMonthItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

  filterChecklistItems:() =>

    @totalTodayItems = 0;
    @totalTodayDone = 0;

    @totalWeekItems = 0;
    @totalWeekDone = 0;

    @totalMonthItems = 0;
    @totalMonthDone = 0;

    @daily = @goals.filter( (model) =>
      return moment(model.get('created')).week() == moment().week()
    )

    @weekly = @goals.filter( (model) =>
      return moment(model.get('created')).week() != moment().week() && model.get('done') == false
    )

    @monthly = @goals.filter( (model) => model.get('type') == 'monthly' && moment(model.get('created')).format('M') == moment().format('M') && moment(model.get('created')).format('Y') == moment().format('Y'))

    @totalTodayItems = @daily.length;
    $("#dailyChecklist").empty()
    for ci in @daily
      view = new App.Views.Main.Dashboard.Widgets.ChecklistItem({model:ci})
      @appendView view.render(), '#dailyChecklist'
      $('.today .empty', @$el).hide()

      if ci.get("done")
        @totalTodayDone = parseFloat(@totalTodayDone) + parseFloat(1)


    @totalWeekItems = @weekly.length;
    $("#weeklyChecklist").empty()
    for ci in @weekly
      view = new App.Views.Main.Dashboard.Widgets.ChecklistItem({model:ci})
      @appendView view.render(), '#weeklyChecklist'
      $('.weeks .empty', @$el).hide()
      if ci.get("done")
        @totalWeekDone = parseFloat(@totalWeekDone) + parseFloat(1)


    if $('.sidebar-right .tab-content').find('.active').attr('id') == 'daily'
        $("#resumeTasks").empty()
        $("#resumeTasks").append(@totalTodayDone + '/' +  @totalTodayItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')

    if $('.sidebar-right .tab-content').find('.active').attr('id') == 'weekly'
        $("#resumeTasks").empty()
        $("#resumeTasks").append(@totalWeekDone + '/' +  @totalWeekItems + ' COMPLETED TASK... <span class="pull-right">KEEP GOING!</span>')


  onSelectPanel: (event) =>
    tabSelected = @$(event.currentTarget).data('checklist')
    total = @goals.filter( (model) => model.get('type') == tabSelected ).length
    done = @goals.filter( (model) => model.get('type') == tabSelected and model.get('done') ).length

    @$('#counting').text("#{done}/#{total}")

  onAddNew:(event) =>
    event.preventDefault()

    data =
      description: $('#newchecklistitem', @$el).val()
      done:false
      type: $('.sidebar-right .tab-content').find('.active').attr('id')
      user:app.me.id

    checkList = new App.Models.ChecklistItem(data)
    checkList.save()
    @goals.add checkList
    @filterChecklistItems()
    $('#newchecklistitem', @$el).val('')

  onSaveCheckListItem: (e)=>
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
        @goals.fetch
          reset: true
          data:
            user: app.me.id

        e.currentTarget.remove()

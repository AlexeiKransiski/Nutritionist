class App.Views.Main.Status.Widgets.GoalItem extends Null.Views.Base   
  template: JST['app/main/status/widgets/goal_item.html'] 

  events:
    'ifChecked li input[type=checkbox]': 'onItemChecked'
    'ifUnchecked li input[type=checkbox]': 'onItemUnchecked'
    'click #remove' : 'onRemove'

  getContext: () =>
   {model: @model}

  render: ->
    super

  onItemChecked: (event) ->
    text = @$(event.currentTarget).parent().parent().find('label').html()
    #@$(event.currentTarget).find('label').empty().append '<del>' + text + '</del>'
    @$(event.currentTarget).parent().parent().find('label').empty().append '<del>' + text + '</del>'
    @model.set "done", true 
    @model.save()
    @fire 'checkitem:update_add'

  onItemUnchecked: (event) ->
    text = @$(event.currentTarget).parent().parent().find('label').text()
    @$(event.currentTarget).parent().parent().find('label').empty().append text
    @model.set "done", false
    @model.save()
    @fire 'checkitem:update_remove'

  onRemove: (event) ->
    @model.destroy()  
    @fire 'checkitem:remove' 

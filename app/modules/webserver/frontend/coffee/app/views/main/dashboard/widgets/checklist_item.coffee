class App.Views.Main.Dashboard.Widgets.ChecklistItem extends Null.Views.Base
  template: JST['app/main/dashboard/widgets/checklist_item.html']
  tagName: 'li'
  className: 'fadeindown animated'

  events:
    'ifChecked input[type=checkbox]': 'onItemChecked'
    'ifUnchecked input[type=checkbox]': 'onItemUnchecked'
    'click #remove' : 'onRemove'
    
  getContext: () =>
   {model: @model}

  render: =>
    super
    $('input[type=checkbox]', @$el).iCheck({
      checkboxClass: 'icheckbox_minimal-green'
    })

    return this

  onItemChecked: (event) =>
    console.log "ITEM CHECKED"
    text = @$(event.currentTarget).parent().parent().find('label').html()
    @$(event.currentTarget).parent().parent().find('label').empty().append '<del>' + text + '</del>'
    @model.set "done", true
    @model.save()
    @fire 'checkitem:update_add'

  onItemUnchecked: (event) =>
    text = @$(event.currentTarget).parent().parent().find('label').text()
    @$(event.currentTarget).parent().parent().find('label').empty().append text
    @model.set "done", false
    @model.save()
    @fire 'checkitem:update_remove'

  onRemove: (event) =>
    @model.destroy()
    @fire 'checkitem:remove'

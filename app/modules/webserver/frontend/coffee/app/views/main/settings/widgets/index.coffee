class App.Views.Main.Settings.Widgets.Index extends App.Views.Base
  template: JST['app/main/settings/widgets/index.html']
  className: 'tab-pane fade'
  id: 'widget'

  options:
    active: false

  initialize: (options) =>
    super

    @widgets_nutricional = new App.Views.Main.Settings.Widgets.Nutricional
      hidden: false

  events:
    'click [data-role="update-units"]': 'onUpdate'
  render: () =>
    super

    # my widget extra boxes
    @appendView @widgets_nutricional.render(), '[data-role=nutritionals_info]'


    $('.bfh-selectbox[data-id=meassure]', @$el).bfhselectbox({
      value: app.me.get('widgets').meassure
    })

    #$('.bfh-selectbox[data-id=weight]', @$el).bfhselectbox({
    #  value: app.me.get('widgets').weight
    #})

    #$('.bfh-selectbox[data-id=height]', @$el).bfhselectbox({
    #  value: app.me.get('widgets').height
    #})

    #$('.bfh-selectbox[data-id=distance]', @$el).bfhselectbox({
    #  value: app.me.get('widgets').distance
    #})

    #$('.bfh-selectbox[data-id=energy]', @$el).bfhselectbox({
    #  value: app.me.get('widgets').energy
    #})
    @


  onUpdate: (event) =>
    event.preventDefault()

    #fields = @getFormInputs $('[data-role="widgets-units-form"]', @el), ['']

    widgets = app.me.get('widgets')
    widgets.meassure=$('#meassure').val()
    #_.extend widgets, fields
    @$el.block()
    app.me.save({widgets: widgets}, {
      success: (model, response) =>
        #alert('Widget Units updated')
        @$el.unblock()
        alert('This change require a page reload.')
        location.reload()
        # app.me.setValue model.toJSON()
      error: (model, response) =>
        alert('Error while updating Widget Units ')
        @$el.unblock()
      wait: true
    })

class App.Views.Main.Appointment.Shop.Card extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/shop/card.html']
  tagName: 'li'
  className: 'custom_radios'

  events:
    'click input': 'checked'
    
  render: () =>
    super

    #$('.custom_radios input[type=radio]').iCheck({
      #radioClass: 'iradio_polaris'
    #});

    if Helpers.checkDefaultCard(@model)
      @$el.addClass('active')
      @checked()

    return this

  getContext: =>
    return {model: @model}

  checked: (event) =>
    @fire 'card:selected'

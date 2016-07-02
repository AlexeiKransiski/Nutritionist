class App.Views.Main.Status.Charts.Details.LegendItem extends Null.Views.Base
  template: JST['app/main/status/charts/details/legend_item.html']
  className: 'checkbox'

  initialize: (options) =>
    super
    @name = options.name
    return this

  events:
    'ifChecked': 'onChecked'
    'ifUnchecked': 'onUnchecked'
  render: =>
    super

    # use icheck v2.0 the v1.0 its broken
    #$("input##{@name}", @$el).icheck
    $("input[type=checkbox]", @$el).icheck
      checkboxClass: 'icheckbox_minimal-green'

    return this

  getContext: () =>
    return {name: @name, color: Helpers.colorful_language(@name)}

  onChecked: (event) =>
    event.stopPropagation()
    @fire "item:checked"

  onUnchecked: (event) =>
    event.stopPropagation()
    @fire "item:unchecked"

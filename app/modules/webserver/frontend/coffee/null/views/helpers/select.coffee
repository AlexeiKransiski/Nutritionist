class Null.Views.Helpers.Select extends Null.Views.Base
  template: JST['null/helpers/select.html']

  filter: {}

  initialize: (options) =>
    # need collection and renderOption
    super
    @collection.on 'sync', @addAll, @
    @filter = options.filter if options.filter
    @_options = []

  render: () =>
    _.each @_options, (item) =>
      item.remove()
    @collection.fetch(
      data: @filter
    )
    @

  addAll: () =>
    @collection.each @addOne

  addOne: (item) =>
    option_data = @renderOption(item)
    $option = $('<option>')
    $option.val(option_data.value)

    if option_data.data?
      for k,v of option_data.data
        $option.attr("data-#{k}", v)

    $option.html(option_data.text)
    @_options.push $option
    @$el.append $option

  renderOption: (item) =>
    return {
      value: item.id
      text: item.id
    }

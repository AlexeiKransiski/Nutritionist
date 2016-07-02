class App.Views.Common.Me.Info extends Null.Views.Base
  template: JST['app/common/me/info.html']

  initialize: (options) =>
    super

    @listenTo @model, "change", @render
    @render()
    @

  render: () =>
    super

  getContext: =>
    return {model: @model}

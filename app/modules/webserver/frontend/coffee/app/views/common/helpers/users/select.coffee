class App.Views.Common.Helpers.Users.Select extends Null.Views.Helpers.Select

  initialize: (options) =>
    @collection = new App.Collections.Users()
    super

    @render()

  renderOption: (item) =>
    return {
      value: item.id,
      data:
        username: "#{item.get('username')}##{item.get('customer')}"
      text: "#{item.escape('name')}(#{item.get('username')})"
    }

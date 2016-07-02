class App.Views.Main.Progress.Compare.ImagesData extends Null.Views.Base
  template: JST['app/main/progress/compare/images_data.html']

  initialize: (options) =>
    super
    @beforeImage = options.beforeImage
    @afterImage = options.afterImage
    return this

  render: () =>
    super
    return this

  getContext: () =>
    return {
      oldImage: @beforeImage
      actualImage: @afterImage
    }

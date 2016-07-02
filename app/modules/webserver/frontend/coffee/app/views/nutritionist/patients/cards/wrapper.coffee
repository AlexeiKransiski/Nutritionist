class App.Views.Nutritionist.Patients.Cards.Wrapper extends Null.Views.Base
  template: JST['app/nutritionist/patients/cards/wrapper.html']
  tagName: 'div'
  className: 'row'

  initialize: (options) =>
    super
    @sections = options.sections
    return this

  render: () =>
    super
    _.each @sections, @loadSection
    return this

  loadSection: (section) =>
    section_view = new App.Views.Nutritionist.Patients.Cards.Section(section)
    @appendView section_view.render(), @$el

  refresh: (search) =>
    @subviewCall('refresh', search)

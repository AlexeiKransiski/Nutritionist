class App.Views.Nutritionist.Patients.List.Wrapper extends Null.Views.Base
  template: JST['app/nutritionist/patients/list/wrapper.html']

  initialize: (options) =>
    super
    @sections = options.sections
    return this

  render: () =>
    super
    _.each @sections, @loadSection

    $("#accordion", @$el).multiAccordion({
      active: 'all'
    });
    return this

  loadSection: (section) =>
    $h3 = $('<h3>')
    $h3.html(section.name)
    $('[data-role="sections"]', @$el).append($h3)
    section_view = new App.Views.Nutritionist.Patients.List.Section(section)
    @appendView section_view.render(), '[data-role="sections"]'

  refresh: (search) =>
    @subviewCall('refresh', search)

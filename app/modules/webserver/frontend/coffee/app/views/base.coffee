class App.Views.Base extends Null.Views.Base

  getFormInputs: (element, exclude) =>
    form_elements = super
    unless element
      element = $("form", @$el)
    unless exclude
      exclude = []

    _.each($(".bfh-selectbox", element), (input) =>
      return if $(input).data("id") in exclude
      form_elements[$(input).data("id")] = $(input).find('input[type=hidden]').val()
    )

    return form_elements

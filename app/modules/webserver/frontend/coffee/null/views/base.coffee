class Null.Views.Base extends Backbone.View
  # tempalte example
  # template: JST['app/test/test.html']
  options: {
    subject: {}
    resource: {}
    extra: {}
  }

  ###
    authorizator must be a object that has
    isAuthorized method wihch need as params
      - permission
      - subject
      - reosurce
      - options
      - callback
  ###
  authorizator: null

  ###
    permission is the type Resource:action
    e.j: Customer:create
    if the view has permission the will render
    or not the view. also if it render it can
    remove element from dom as well before render

    after permission is evaluated it will stored on
    @authorization  for later use on other methods
  ###
  permission: null

  initialize: (options) =>
    super
    @options = _.extend _.clone(@options), options
    @authorizator = @options.authorizator if @options.authorizator
    @template = @options.template if @options?.template?
    @__appendedViews = new Backbone.ChildViewContainer()

  getContext: () =>
    return {}
  ,

  render: () =>
    @$_el = $("<div>")
    @$_el.html(@template(@getContext()))
    if @permission?
      unless @options.subject.permissions_compiled.test(@permission)
        @$_el.html("")
        @_render @$_el
      else
        if @authorizator?
          @authorizator.isAuthorized @permission, @options.subject, @options.resource, @options.extra, (result) =>
            @authorization = result
            @applyAuthorization()
    else

      @_render @$_el

    return @
  ,

  _render: ($_el) =>
    $needs_perm = $('[data-hasperm]', @$_el)
    for element in $needs_perm
      $element = $(element)
      unless @options.subject.permissions_compiled.test($element.data('hasperm'))
        $element.remove()

    @$el.html($_el.html())


  preventSubmit: (event) =>
    event.preventDefault()
    return false

  applyAuthorization: () =>
    notAutorized = () =>
      @$_el.html("")
      @_render @$_el

    if @authorization == false or @authorization?.result == false
      notAutorized()
      return
    else
      to_leave = []
      to_remove = []

      stringAccess = (item) =>
        if item == "all"
          @_render @$_el.html(@template(@getContext()))
        else
          if item[0] == "-"
            $("[data-authorization=#{item.split("-")[1]}]", @$_el).remove()
          else
            to_leave.push "[data-authorization=#{item}]"

      arrayAccess = (items) =>
        console.log "removing fields"
        for item in access
          stringAccess(item)

        $('[data-authorization]', @$_el).not(to_leave.join(', ')).remove() if to_leave.length > 0

        @_render @$_el

      access = @authorization?.access

      return arrayAccess(access) if access instanceof Array
      if typeof access == "string"
        stringAccess(access)
        $('[data-authorization]', @$_el).not(to_leave.join(', ')).remove() if to_leave.length > 0
        @_render @$_el
        return
      return notAutorized()


  removeAll: () =>
    @stopListening()
    @undelegateEvents()
    @unbind()
    @removeSubviews()
    @$el.remove()
  ,

  remove: () =>
    @stopListening()
    @undelegateEvents()
    @unbind()
    @$el.html("")
  ,

  removeSubviews: () =>
    @__appendedViews.call('removeAll')

  subviewCall: (method, options) =>
    @__appendedViews.call(method, options)


  #
  __add: (view, destination = '', fn = 'append') =>
    $destination = @__detectDestination destination
    @__appendedViews.add view
    view._parent = @

    $destination[fn] view.$el

    if $('body').find($destination).length
      view.trigger 'ready', view
      view.rendered = yes
    else
      @on 'ready', =>
        view.trigger 'ready', view
        view.rendered = yes

    view.on 'remove', =>
      index =  _.indexOf @__appendedViews, view
      if index > -1
        @__appendedViews.splice index, 1
    @

  __detectDestination: (destination) =>
    destination or= ''
    if destination instanceof jQuery
      $destination = destination
    else
      $destination = if destination and @find(destination).length > 0 then @find(destination) else @$el
    $destination

  addView: (view, destination = '') =>
    @__add view, destination, 'html'

  prependView:(view, destination = '') =>
    @__add view, destination, 'prepend'

  appendView: (view, destination = '') =>
    @__add view, destination

  appendAfterView: (view, destination = '') =>
    @__add view, destination, "after"

  cleanForm: (element, exclude) =>
    unless element
      element = $("form", @$el)
    unless exclude
      exclude = []

    form_elements = {}

    _.each($("input[type=text]", element), (input) =>
      return if $(input).attr("id") in exclude
      $(input).val('')
    )
    _.each($("select", element), (input) =>
      return if $(input).attr("id") in exclude
      $(input).val('')
    )
    _.each($("textarea", element), (input) =>
      return if $(input).attr("id") in exclude
      $(input).val("")
    )


  getFormInputs: (element, exclude) =>
    unless element
      element = $("form", @$el)
    unless exclude
      exclude = []

    form_elements = {}

    _.each($("input[type=text]", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("input[type=number]", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("input[type=checkbox]:checked", element), (input) =>
      return if $(input).attr("id") in exclude
      if $("input[type=checkbox][name=#{$(input).attr("name")}]").length > 1
        form_elements[$(input).attr("id")] = [] unless form_elements[$(input).attr("id")]?
        form_elements[$(input).attr("id")].push $(input).val()
      else
        form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("input[type=radio]:checked", element), (input) =>
      return if $(input).attr("name") in exclude
      form_elements[$(input).attr("name")] = $(input).val()
    )

    _.each($("input[type=file]", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("input[type=password]", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("input[type=date]", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("input[type=time]", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("input[type=email]", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("textarea", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    _.each($("select", element), (input) =>
      return if $(input).attr("id") in exclude
      form_elements[$(input).attr("id")] = $(input).val()
    )

    return form_elements
  ,

  formErrors: (element, errors) =>
    $(".has-error", element).removeClass("has-error")
    $(".error-msg", element).remove()
    _.each(errors, (msg,id) =>
      $("##{id}", element).parents(".form-group").addClass("has-error")
      $("##{id}", element).parents(".form-group").children(".control-label").after("<label class='control-label error-msg'> (#{msg})</label>")
    )
  ,

  # Dragging events from child to parent
  fire: (name, params...) =>
    proxyEvent = new ProxyEvent @, name
    @_fireEvent proxyEvent, params...

  _fireEvent: (proxyEvent, params...)=>
    @trigger proxyEvent.name, proxyEvent, params...

    unless proxyEvent.isStopped()
      @_parent?._fireEvent proxyEvent, params...

  notify: (message, options) =>
    $.notify(message, options)

  success: (message) =>
    options =
      className: 'success'
      position: 'top right'
      showDuration: 2000

    @notify(message, options)

  error: (error) =>
    options =
      className: 'error'
      position: 'top right'
      showDuration: 2000

    if error.message
      @notify(error.message, options)
    else
      @notify error, options

_.extend Null.Views.Base, Backbone.Events

# Proxy jQuery methods
_.each ['find', 'addClass', 'attr', 'removeClass', 'fadeIn', 'fadeOut', 'effect', 'css', 'append', 'prepend', 'prop', 'is', 'blur'], (method) =>
  Null.Views.Base::[method] = (args...) ->
    @$el[method].apply @$el, args

class ProxyEvent
  constructor: (view, name) ->
    @name = name
    @view = view
    @stopped = no

  isStopped: -> @stopped

  stopPropagation: ->
    @stopped = yes


$spiner = $('<div>')
$spiner.addClass('maestre-spiner')
$spiner.spin
  lines: 13, # The number of lines to draw
  length: 20, # The length of each line
  width: 4,  # The line thickness
  radius: 13, # The radius of the inner circle
  corners: 1, # Corner roundness (0..1)
  rotate: 0, # The rotation offset
  direction: 1, # 1: clockwise, -1: counterclockwise
  color: '#000', # #rgb or #rrggbb or array of colors
  speed: 1, # Rounds per second
  trail: 60, # Afterglow percentage
  shadow: false, # Whether to render a shadow
  hwaccel: false, # Whether to use hardware acceleration
  className: 'spinner', # The CSS class to assign to the spinner
  zIndex: 2e9, # The z-index (defaults to 2000000000)
  top: '50%', # Top position relative to parent
  left: '50%' # Left position relative to parent


$.blockUI.defaults.message = $spiner
$.blockUI.defaults.css =
  border: 'none'
  padding: '15px'
  backgroundColor: 'transparent'
  '-webkit-border-radius': '10px'
  '-moz-border-radius': '10px'
  opacity: .5
  color: '#fff'
  top: '50%'
  left: '48%'

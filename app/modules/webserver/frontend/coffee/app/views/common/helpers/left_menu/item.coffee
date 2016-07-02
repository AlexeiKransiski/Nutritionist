class App.Views.Common.Helpers.LeftBar.Item extends Null.Views.Base
  tagName: 'li'
  options:
    icon: null
    a_type: 'route'
    a_href: '#'
    route: null
    text: null

  render: () =>
    @$el.attr('data-href', @options.route) if @options.route?
    # a element
    $a = $('<a>')
    $a.attr('data-role', 'route') if @options.a_type == 'route'
    $a.attr('href', @options.a_href)

    # icon
    if @options.icon?
      $i = $('<i>')
      $i.addClass(@options.icon)
      $a.append($i)

    # text
    $span = $('<span>')
    $span.addClass('text')
    $span.html(@options.text)

    $a.append($span)

    @$el.html($a)

    @

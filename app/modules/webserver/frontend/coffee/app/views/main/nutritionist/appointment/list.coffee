class App.Views.Main.Appointment.List extends Null.Views.Base
  template: JST['app/main/nutritionist/appointment/list.html']

  initialize: (options) =>
    super
    @filterBy = 'all'
    @qSearch = ''
    return this

  events:
    'click #filters span': 'onListFilter'
    'keyup #search-appointment': 'onKeyup'
    'submit #search-appointment': 'onSearch'

  render: () =>
    super
    @$("#filters li span[data-filter=#{ @filterBy }]").addClass('active')
    @listenTo @collection, 'sync', @addAll
    @addAll()
    return this

  getContext: () =>
    return {appointments: @collection, qSearch: @qSearch}

  onKeyup: () =>
    @qSearch = @$('#search-appointment :text').val().trim()

  onSearch: (event) =>
    event.preventDefault()
    @qSearch = @$('#search-appointment :text').val().trim()
    @collection.fetch data: $.param(@buildFilterSearchParams()), reset: true


  onListFilter: (event) =>
    #$.param(@buildFilterSearchParams()),
    @$("#filters li span").removeClass('active')
    @filterBy = @$(event.currentTarget).data('filter')
    @$("#filters li span[data-filter=#{ @filterBy }]").addClass('active')
    @collection.fetch
      data: $.param(@buildFilterSearchParams()),
      reset: true,

  buildFilterSearchParams: =>
    params = {}

    unless @qSearch == ''
      params =
        search:  @qSearch
        # '$or':[{
        #   'quiz.question1':
        #     "$regex": @qSearch, "$options": 'i'
        # },
        # {
        #   'replies':
        #     "$regex": @qSearch, "$options": 'i'
        # }]

    switch @filterBy
      when 'all'
        delete params.status
      when 'answered'
        params.status =
          '$in': ['answered', 'waiting']
      else
        params.status = @filterBy

    params.patient=app.me.id

    params

  addAll: () =>
    @subviewCall('removeAll')
    @collection.each @addOne

  addOne: (item) =>
    item_view = new App.Views.Main.Appointment.Row({model: item})
    @appendView item_view.render(), '[data-role="results"]'

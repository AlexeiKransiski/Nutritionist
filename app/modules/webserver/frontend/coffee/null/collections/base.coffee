class Null.Collections.Base extends Backbone.Collection
  sync: Null.Sync
  # parse: (results) ->
  #   @page = parseInt(results.page)
  #   @limit = parseInt(results.limit)
  #   @next_page = results.next_page
  #   @previous_page = results.previous_page
  #   return results.objects
  # ,
  parse: (results) ->
    @next_page = results.nextHref
    return results.data

  resetPaging: () ->
    @page = 1
    @limit = undefined
  ,

  nextPage: (options) ->
    unless options
      options = {}

    @filters.page = @page + 1
    @filters.limit = @limits
    options.data = @filters
    options.remove = false
    @fetch(options)
  ,

  filtrate: (data) ->
    unless data
      data = {data:{}}
    @filters = data.data
    @filters.page = @page
    @filters.limit = @limit
    @fetch(data)
  ,

  bulk: (models, options) =>
    default_options =
      merge: true

    _.extend default_options, options
    data =
      bulk: 1
      data: models
    bulk = new @model(data)
    bulk.save({},{
      success: (model, response) =>

        @add @parse model.toJSON() if default_options.merge
        default_options.success model, response if options?.success?
      error: (model, error) =>
        default_options.error model, response if options?.error?
    })

  navigate: () =>
    unless @router
      return console.log "define the 'router' property inside the collection class to use  NAVIGATE"
    Backbone.history.navigate("#{@router}", {trigger: true} )

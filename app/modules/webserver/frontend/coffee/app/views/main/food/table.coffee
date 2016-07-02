class App.Views.Main.Food.Table extends Null.Views.Base
  template: JST['app/main/food/table.html']
  tagName: 'table'
  className: 'table table-hover'
  options:
    footer: false
    filter: {}

  that = null
  @favoritesRetrieved = false
  @patientPreferences=null
  initialize: (options) =>
    super

    that = @
    @filter = options.filter
    @patientPreferences=options.patientPreferences


    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'remove', @calcCalories

    # @listenToOnce @patientPreferences, 'sync', @render
    #@listenTo @collection, 'sync', @addOne
    #@listenTo @collection, 'remove', @calcCalories

    @collection.parse = (data) ->
      return data.data

    @on 'cardio:calculate_calories',@calcCalories

    # @render()
    @

  render: () =>
    super

    @


  getContext: =>
    return {
      patientPreferences: @patientPreferences
    }
  # addAll: =>
  #   @collection.each @addOne
  refresh: (callback) =>
    $("#bodyTableList",@el).html("")
    @collection.reset()
    @collection.fetch
      data: @filter
      success: (collection, response) =>
        callback(null, collection)
      error: (collection, error) =>
        callback(error, null)

  addOne: (item) =>

    item_view = new App.Views.Main.Food.Row
      model: item
      patientPreferences: @patientPreferences

    @appendView item_view.render(), '#bodyTableList'

    $('.ratingsTable').iCheck({
      checkboxClass: 'icheckbox_futurico'
    })

  calcCalories: ()=>
    console.log "CALC CALORIES TABLE"
    kcals = parseFloat(_.reduce(@collection.pluck('calories'), (memo, cals) ->
      return memo + cals
    , 0)).toFixed(1)
    $("[data-role=#{@filter.meal_type}-kcals]", @$el).html("#{kcals} kcals")


  #reload:()=>
  #  @collection.each @addOne

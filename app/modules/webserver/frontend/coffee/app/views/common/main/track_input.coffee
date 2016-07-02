class App.Views.Common.Main.TrackInput extends Null.Views.Base
  template: JST['app/common/main/track_input.html']

  @sortedStream
  @foodLog = null
  @waterLog = null
  that=null
  options:
    type: 'default'

  types:
    'default': 'feeling'
    'food': 'food'
    'exercise': 'exercise'
    'water': 'water'
    'progress': 'progress'
    'appoinment': 'nutri'

  initialize: (options) =>
    super

    @fetched = false
    @collection = new App.Collections.Timeline()

    @foodLog = new App.Collections.Metrics()
    @exerciseLog = new App.Collections.Metrics()

    @waterLog = new App.Collections.WaterLogs()
    @statusStream = new App.Collections.Status()
    @progress = new App.Collections.Progress()

    @appointment_logs = new App.Collections.AppointmentsLogs()
    # @listenTo @foodLog, 'sync', @renderExcercise
    # @listenTo @exerciseLog, 'sync', @renderWaterLog
    # @listenTo @waterLog, 'sync', @renderStatusStream

    #@listenTo @foodLog, 'sync', @renderFoodLog
    # @listenTo @statusStream, 'sync', @sortRender
    # @listenTo @statusStream, 'remove', @sortRender

    return this

  events:
    'click #foodFilter': 'onFoodFilter'
    'click #saveStatus' : 'onSubmitStatus'
    'click .deletePost' : 'onDeletePost'
    'click .savePost' : 'onSavePost'
    'click .cancel':'onCancel'

  render: () =>
    super

    if @options.type == "status"
      $("#feeling").hide();
      $("#titleTracker").hide();

    unless @fetched
      @fetchData()

    return this

  getContext: =>
    return {
      collection:@collection,
      # statusStream: @statusStream,
      # foodLog: @foodLog
    }

  fetchData: () =>
    async.parallel([
      # food
      (cb) =>
        @foodLog.fetch
          data:{
            user: app.me.id
            context: 'food'
            year: moment().date(1).year()
            month: moment().date(1).format('MM')
          }
          success: (col, res) =>
            @foodLog.each (model) =>
              for day, value of model.get('days')
                value.created = moment("#{day}/#{model.get('month')}/#{model.get('year')}", 'DD/MM/YYYY').toISOString()
                value.context = model.get('context')
                @collection.add value
            return cb(null, col)
          error: (col, err) =>
            return cb(err.responseJSON, null)
      # exercise
      (cb) =>
        @exerciseLog.fetch
          data:{
            user: app.me.id
            context: 'exercise'
            year: moment().date(1).year()
            month: moment().date(1).format('MM')
          }
          success: (col, res) =>
            @exerciseLog.each (model) =>
              for day, value of model.get('days')
                value.created = moment("#{day}/#{model.get('month')}/#{model.get('year')}", 'DD/MM/YYYY').toISOString()
                value.context = model.get('context')
                @collection.add value
            return cb(null, col)
          error: (col, err) =>
            return cb(err.responseJSON, null)
      # water
      (cb) =>
        @waterLog.fetch
          data:{
            user: app.me.id,
            perUser:true
          }
          success: (col, res) =>
            @waterLog.each (model) =>
              @collection.add model
            return cb(null, col)
          error: (col, err) =>
            return cb(err.responseJSON, null)
      # status
      (cb) =>
        @statusStream.fetch
          data:{
            user: app.me.id,
          }
          success: (col, res) =>
            @statusStream.each (model) =>
              @collection.add model
            return cb(null, col)
          error: (col, err) =>
            return cb(err.responseJSON, null)
      # progress
      (cb) =>
        @progress.fetch
          data:{
            user: app.me.id,
          }
          success: (col, res) =>
            @progress.each (model) =>
              @collection.add model
            return cb(null, col)
          error: (col, err) =>
            return cb(err.responseJSON, null)

      # appointments logs
      (cb) =>
        @appointment_logs.fetch
          data:{
            patient: app.me.id,
          }
          success: (col, res) =>
            @appointment_logs.each (model) =>
              @collection.add model
            return cb(null, col)
          error: (col, err) =>
            return cb(err.responseJSON, null)

    ], (err, res) =>
      return if err?
      @fetched = true
      @sortRender()
      @listenTo @statusStream, 'add', @onStatusAdded
    )

  onStatusAdded: (new_status) =>
    @collection.add new_status
    @sortRender()

  sortRender:() =>
    #sorted = @statusStream.toArray().sort (a, b) =>
    # sorted = @collection.toArray().sort (a, b) =>
    #   a = a.get('created');
    #   b = b.get('created');
    #   if(a > b)
    #       return -1;
    #   if(a < b)
    #       return 1;
    #   return 0;
    #
    # @collection.reset()
    #
    # for sort in sorted
    #   @collection.add(sort)

    #console.log "sorted"
    #console.log sorted
    @render()
    return

  onCancel:(event)=>
    id = event.currentTarget.id.split("_")[1];
    $("#box_" + id).show();
    $("#" + id).hide();

  onFoodFilter: ()=>
    @foodLog.fetch({data:{"user":app.me.id}})

  renderFoodLog: ()=>
    @foodLog.each @renderFoodElement


  renderFoodElement: (event)=>
     $("#statusStream").empty()
     console.log event
     foodLogDetail = new App.Views.Common.Main.TrackBox({model:event,type:'food'})
     @appendView foodLogDetail.render(), "#foods"

  onSubmitStatus: ()=>
    data =
      status: $('input[name=options]:checked').val()
      user:app.me.id
      message:$("#statusMessage").val()

    status = new App.Models.Status(data)
    status.save({}, {
      success: (model, res) =>
        @statusStream.add(status)
      error: (mode, error) =>
        @error error.responseJSON if error?.responseJSON?
    })

  onDeletePost: (event)=>
    console.log event.currentTarget
    idModel = event.currentTarget.id.split("_")[1]
    modelToRemove = @statusStream.get(idModel);
    modelToRemove.destroy({
      success: () =>
        @render()
    })
    @statusStream.remove(idModel)

  onSavePost: (event) =>
    idModel = event.currentTarget.id.split("_")[1]
    modelToRemove = @statusStream.get(idModel);

    data =
      status: $('input[name=options]:checked').val()
      message:$("#message_" + idModel).val()

    modelToRemove.save(data, {
      success: () =>
        @render()
    })

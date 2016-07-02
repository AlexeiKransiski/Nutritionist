class Null.Models.Base extends Backbone.Model
  sync: Null.Sync
  idAttribute: "_id"
  name: ""
  delete_implication: ""

  navigate: () =>
    unless @router
      return console.log "define the 'router' property inside the model class to use  NAVIGATE"
    Backbone.history.navigate("#{@router}#{@id}", {trigger: true} )

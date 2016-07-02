import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  created: {type: Date, default: Date.now},

  /*
    when type = user must have user relation
  */
  /*user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},

  preferences:[{
    value:String
  }]*/

  food_preferences:[{
    value:String
  }],
  
  suplement_preferences:[{
    value:String
  }]

}

export default class Preference extends BaseModel{
  constructor(options){
    this._name = "preferences" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this._model = mongoose.model(this._name, this._schema)

    super(options)
  }

  postSave(){
    console.log("preference post save example")
  }

}

import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  
  created: {type: Date, default: Date.now},

  status:{type: String, default: 'Great'},

  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true},
  
  message:String

}

export default class Status extends BaseModel {
  constructor(options){
    this._name = "status" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this._model = mongoose.model(this._name, this._schema)

    super(options)
  }

  postSave(){
    console.log("status post save example")
  }

}

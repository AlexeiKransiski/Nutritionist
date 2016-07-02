import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  patient: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},
  date: Date
}


export default class NutritionLog extends BaseModel{
  constructor(options){
    this._name = "nutrition_log" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this._model = mongoose.model(this._name, this._schema)

    super(options)
  }

  postSave(){
    console.log("nutrition_log post save example")
  }

}

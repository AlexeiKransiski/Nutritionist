import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  nutrients: {type: Array, default: []},
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},
  date: Date
} 


export default class NutritionInformation extends BaseModel{
  constructor(options){
    this._name = "nutrition_information" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this._model = mongoose.model(this._name, this._schema)

    super(options)
  }

  postSave(){
    console.log("nutrition_information post save example")
  }

}

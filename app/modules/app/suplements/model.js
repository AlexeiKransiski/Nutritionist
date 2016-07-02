import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  created: {type: Date, default: Date.now},
  name: String
};


export default class Suplements extends BaseModel{
  constructor(options){
    this._name = "suplements" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this.createModel()

    super(options)
  }

  postSave(){
    console.log("suplements post save example")
  }

}

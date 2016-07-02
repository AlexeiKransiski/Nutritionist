import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  created: {type: Date, default: Date.now},
  name: String
};


export default class PhysicalLimitation extends BaseModel{
  constructor(options){
    this._name = "physical_limitation" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this.createModel()

    super(options)
  }

  postSave(){
    console.log("physical_limitation post save example")
  }

}

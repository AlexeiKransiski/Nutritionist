import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))
var _ = require('underscore')

let schema = {
  created: {type: Date, default: Date.now},
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true},
  /*
  *  transaction_type:
  *    - debit
  *    - credit
  */
  transaction_type: {type: String, require: true},
  amount: {type: Number},
  item: mongoose.Schema.Types.Mixed
}


export default class FoodLog extends BaseModel{
  constructor(options){
    this._name = "transactions" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)

    this.createModel()
    super(options)
  }

  postSave(){
    console.log("food post save example")
  }

}

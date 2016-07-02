import BaseModel from "app/base/model"
import Promise from "bluebird"

var moment = require('moment')
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},
  created: {type: Date, default: Date.now},
  context: {type: String},
  year: {type: Number},
  month: {type: Number},
  year_month: {type: Number},
  days: {type: mongoose.Schema.Types.Mixed}
}


export default class Metrics extends BaseModel{
  constructor(options){
    this._name = "metrics" //TODO: Use introspection to not need this (at least get filename programatically)
    this._schema = new mongoose.Schema(schema)
    this._schema.index({ user : 1, year_month: 1, context: 1 })
    this._schema.pre('save', this.preSave)

    this.createModel()
    super(options)
  }

  preSave(next){
    // this should be the model instance not the BaseModel intanse
    if (this.isNew){
        this.created = moment().toISOString()
    }
    next()
  }

  postSave(){
    console.log("food_log_stats post save example")
  }

}

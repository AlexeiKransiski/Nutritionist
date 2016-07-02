import BaseModel from "app/base/model"
import Promise from "bluebird"

var moment = require('moment')

var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},
  created: {type: Date, default: Date.now},
  date: {type: Date},

  glasses: {type: Number, default: 0},
}


export default class WaterLog extends BaseModel{
  constructor(options){
    this._name = "water_log" //TODO: Use introspection to not need this (at least get filename programatically)
    this._schema = new mongoose.Schema(schema)
    this._schema.index({ user : 1, date: 1 })
    this._schema.pre('save', this.preSave)

    this.createModel()
    super(options)
  }

  preSave(next){
    // this should be the model instance not the BaseModel intanse
    /*if (this.isNew){
      this.date = moment().format('YYYY/MM/DD')
    }*/
    next()
  }

  postSave(){
    console.log("food_log post save example")
  }

}

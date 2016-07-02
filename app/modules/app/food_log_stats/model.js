import BaseModel from "app/base/model"
import Promise from "bluebird"

var moment = require('moment')

var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},
  date: {type: Date},

  breakfast: {type: Number, default: 0},
  early_snack: {type: Number, default: 0},
  lunch: {type: Number, default: 0},
  afternoon_snack: {type: Number, default: 0},
  dinner: {type: Number, default: 0},
  late_snack: {type: Number, default: 0}
}


export default class FoodLogStats extends BaseModel{
  constructor(options){
    this._name = "food_log_stats" //TODO: Use introspection to not need this (at least get filename programatically)
    this._schema = new mongoose.Schema(schema)
    this._schema.index({ user : 1, date: 1 })
    this._schema.pre('save', this.preSave)

    //static methods
    //this._schema.statics.getORCreateCurrent =


    this.createModel()
    super(options)
  }

  preSave(next){
    // this should be the model instance not the BaseModel intanse
    if (this.isNew){
      if (this.date){
        this.date = moment(this.date).format('YYYY/MM/DD')
      }else{
        this.date = moment().format('YYYY/MM/DD')
      }
    }
    next()
  }

  // *getORCreateCurrent(user_id, date) {
  //   //yield this._model.findOneAsync({user: user_id, date: moment(date).toISOString()})
  //
  //   yield this._model.findOneAsync({user: "54bdb0056d7e85358190d525"})
  //
  //   //yield this._model.create({user: user_id})
  // }

  postSave(){
    console.log("food_log_stats post save example")
  }

}

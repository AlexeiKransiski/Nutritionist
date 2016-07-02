import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  created: {type: Date, default: Date.now},

  /*
    type:
      - generic
      - user
  */
  type: {type: String, default: 'user'},
  /*
    when type = user must have user relation
  */
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},

  // TODO: think a best way to add exercises to favories per user
  favorites: [{type: mongoose.Schema.Types.ObjectId, ref: 'users', unique: true}],

  name: String,
  description: String,
  exercise_type: String, // cardiovascular | strenght
  exercise_variant: String, // e.g. hard | soft

  // data source: http://products.wolframalpha.com/api/
  time: Number,
  distance: Number,
  calories_burned: Number,
  sets: Number,
  repetitions: Number,
  weight: Number,
  met: Number
}

export default class Exercise extends BaseModel {
  constructor(options){
    this._name = "exercises" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this._schema.pre('save', this.preSave)
    this.createModel()

    super(options)
  }

  preSave(next) {
    return next()
  }
  postSave(){
  }


}

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
  type: { type: String, default: 'user' },
  /*
    when type = user must have user relation
  */
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},

  // TODO: think a best way to add food to favories per user
  favorites: [{type: mongoose.Schema.Types.ObjectId, ref: 'users', unique: true}],

  // food bran/restaurant/name
  name: String,
  description: String,
  serving_types: [{
    name: String,
    factor: String
  }],
  serving_type: String,
  serving_per_container: String,

  //ndb_no id http://www.ars.usda.gov/Services/docs.htm?docid=8964
  ndb_no: Number,

  // nutricional faqs values
  // data source: http://products.wolframalpha.com/api/
  carbs: {type: Number, default: 0},
  fat: {type: Number, default: 0},
  protein: {type: Number, default: 0},
  cholesterol: {type: Number, default: 0},
  sodium: {type: Number, default: 0},
  potassium: {type: Number, default: 0},
  calories: {type: Number, default: 0},
  satured: {type: Number, default: 0},
  polyunsaturated: {type: Number, default: 0},
  dietary_fiber: {type: Number, default: 0},
  monounsaturated: {type: Number, default: 0},
  sugars: {type: Number, default: 0},
  trans: {type: Number, default: 0},
  vitamin_a: {type: Number, default: 0},
  vitamin_c: {type: Number, default: 0},
  calcium: {type: Number, default: 0},
  iron: {type: Number, default: 0}
};


export default class Food extends BaseModel{
  constructor(options){
    this._name = "food" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this.createModel()

    super(options)
  }
}

import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))
var _ = require('underscore')

let schema = {
  created: {type: Date, default: Date.now},
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true},
  /*
    meal_type:
      - breakfast
      - early_snack
      - lunch
      - afternoon_snack
      - dinner
      - late_snack
  */
  meal_type: String,
  food: {type: mongoose.Schema.Types.ObjectId, ref: 'food'},

  // on favorite a food_log should also add the user id to the
  // favorites on the food item
  // this is more for display
  // Question: if check favorites and there are old food_logs of the same
  //           food, should those ones have to be toggled too? i thing yes :P
  favorite: {type: Boolean, default: false},

  // redundante info to avoid populating food, save requests
  food_detail: {
    // food bran/restaurant/name
    name: String,
    description: String,
    serving_type: String,
    serving_per_container: String,

    // nutricional faqs values
    // data source: http://products.wolframalpha.com/api/
    carbs: Number,
    fat: Number,
    protein: Number,
    cholesterol: Number,
    sodium: Number,
    potassium: Number,
    calories: Number,
    satured: Number,
    polyunsaturated: Number,
    dietary_fiber: Number,
    monounsaturated: Number,
    sugars: Number,
    trans: Number,
    vitamin_a: Number,
    vitamin_c: Number,
    calcium: Number,
    iron: Number
  },
  name: String, //name of the food
  carbs: Number,
  fat: Number,
  protein: Number,
  cholesterol: Number,
  sodium: Number,
  potassium: Number,
  calories: Number,
  satured: Number,
  polyunsaturated: Number,
  dietary_fiber: Number,
  monounsaturated: Number,
  sugars: Number,
  trans: Number,
  vitamin_a: Number,
  vitamin_c: Number,
  calcium: Number,
  iron: Number,

  // amount of services of the food to call nutricional values for that meal
  servings: Number,
  serving_type: String,
  serving_factor: Number
}


export default class FoodLog extends BaseModel{
  constructor(options){
    this._name = "food_log" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this._schema.methods.getMetrics = this.getMetrics

    this.createModel()
    super(options)
  }

  postSave(){
    console.log("food post save example")
  }

  getMetrics() {
    return _.omit(this.toJSON(), ['_id', '__v', 'food_detail', 'meal_type', 'created', 'user', 'favorite', 'food', 'name', 'servings', 'serving_type', 'serving_factor'])
  }
}

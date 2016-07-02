import BaseModel from "app/base/model" 

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  created: {type: Date, default: Date.now},
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true},
  exercise_list: {type: mongoose.Schema.Types.ObjectId, ref: 'exercise_list'},
  name: String,
  description: String,
  exercises:[{
    
    exercise: {type: mongoose.Schema.Types.ObjectId, ref: 'exercise'},

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
    weight: Number
    
  }]

}


export default class ExerciseListToday extends BaseModel{
  constructor(options){
    this._name = "exercise_list_today" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)
    this.createModel()

    super(options)
  }

  postSave(){
    console.log("excersice list today post save example")
  }

}
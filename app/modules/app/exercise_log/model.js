import BaseModel from "app/base/model"
import Promise from "bluebird"

var _ = require('underscore')
var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  created: {type: Date, default: Date.now},
  exercise_date: {type: Date},
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true},
  /*
    exercise_type:
      - cardiovascular
      - strenght
  */
  exercise_type: String,
  exercise: {type: mongoose.Schema.Types.ObjectId, ref: 'exercise'},
  description: String,
  // on favorite an exercise_log should also add the user id to the
  // favorites on the exercise item
  // this is more for display
  // Question: if check favorites and there are old exercise_logs of the same
  //           exercise, should those ones have to be toggled too? i thing yes :P
  favorite: {type: Boolean, default: false},

  // redundant info to avoid populating exercise and minimize hits
  exercise_detail: {
    name: String,
    description: String,
    exercise_type: String,
    exercise_variant: String,

    // data source: http://products.wolframalpha.com/api/
    time: Number,
    calories_burned: Number,
    sets: Number,
    repetitions: Number,
    weight: Number,
    distance: Number,
    met: Number
  },
  name: String, //name of the exercise
  time: {type: Number, default: 0},
  distance: {type: Number, default: 0},
  calories_burned: {type: Number, default: 0},
  weight: {type: Number, default: 0},
  sets: {type: Number, default: 0},
  repetitions: {type: Number, default: 0},
  met: {type: Number, default: 0}
}


export default class ExerciseLog extends BaseModel{
  constructor(options){
    this._name = "exercise_log" //TODO: Use introspection to not need this (at least get filename programatically)
    this._schema = new mongoose.Schema(schema)
    this._schema.pre('save', this.preSave)
    this._schema.methods.getMetrics = this.getMetrics

    this.createModel()
    // this._model = mongoose.model(this._name, this._schema)
    super(options)
  }
  preSave(next) {
    if (this.time == null) this.time = 0;
    if (this.calories_burned == null) this.calories_burned = 0;
    if (this.repetitions == null) this.repetitions = 0;
    if (this.sets == null) this.sets = 0;
    if (this.weight == null) this.weight = 0;
    if (this.distance == null) this.distance = 0;
    next();
  }

  postSave(){
    console.log("exercise_log post save example")
  }

  getMetrics() {
    return _.omit(this.toJSON(), ['_id', '__v', 'exercise_detail', 'exercise_type', 'created', 'user', 'favorite', 'exercise_date', 'name', 'exercise', 'exercise_date', 'description'])
  }

}

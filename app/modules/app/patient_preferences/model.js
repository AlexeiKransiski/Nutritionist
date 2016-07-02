import BaseModel from "app/base/model"
import Promise from "bluebird"

var moment = require('moment')

var mongoose = Promise.promisifyAll(require('mongoose'))

let schema = {
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},
  created: {type: Date },

  diseases: {type: Array, default: []},

  weather: {type: String}, // values: cold, temperate, warm, hot
  activity: {type: String}, // values: sedentary, light, active, very_active
  workout: {type: Number}, // values: 15, 30, 45, 60
  maintain: {type: String}, // values: lose, maintain, gain

  limitations: {type: Array, default: []},
  foods: {type: Array, default: []},
  medicines: {type: Array, default: []},
  vitamins: {type: Array, default: []},

  email_notifications: {type: Boolean, default: true},

  fitness_goals:{
    carbs: {type: Number,default:0},
    fat: {type: Number,default:0},
    protein: {type: Number,default:0},
    cholesterol: {type: Number,default:0},
    sodium: {type: Number,default:0},
    potassium: {type: Number,default:0},
    calories: {type: Number,default:0},
    satured: {type: Number,default:0},
    polyunsaturated: {type: Number,default:0},
    dietary_fiber: {type: Number,default:0},
    monounsaturated: {type: Number,default:0},
    sugars: {type: Number,default:0},
    trans: {type: Number,default:0},
    vitamin_a: {type: Number,default:0},
    vitamin_c: {type: Number,default:0},
    calcium: {type: Number,default:0},
    iron: {type: Number,default:0}
  },

  widgets_settings:{
    calories:{
      description:{type: String,default:"Calories"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:0}
    },
    carbs:{
      description:{type: String,default:"Carbs"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:1}
    },
    fat:{
      description:{type: String,default:"Fat"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:2}
    },
    protein:{
      description:{type: String,default:"Protein"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:3}
    },
    cholesterol:{
      description:{type: String,default:"Cholesterol"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:4}
    },
    sodium:{
      description:{type: String,default:"Sodium"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:5}
    },
    sugars:{
      description:{type: String,default:"Sugars"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:6}
    },
    potassium:{
      description:{type: String,default:"Potassium"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:7}
    },
    vitamin_a:{
      description:{type: String,default:"Vitamin A"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:8}
    },
    vitamin_c:{
      description:{type: String,default:"Vitamin C"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:9}
    },
    calcium:{
      description:{type: String,default:"Calcium"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:10}
    },
    iron:{
      description:{type: String,default:"Iron"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:11}
    },
    dietary_fiber:{
      description:{type: String,default:"Dietary Fiber"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:12}
    },
    satured:{
      description:{type: String,default:"Saturated"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:13}
    },
    polyunsaturated:{
      description:{type: String,default:"Polyunsaturated"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:14}
    },
    monounsaturated:{
      description:{type: String,default:"Monounsaturated"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:15}
    },
    trans:{
      description:{type: String,default:"Trans"},
      checked:{type: Boolean, default: true},
      index:{type: Number,default:16}
    }
  }

}


export default class PatientPreferences extends BaseModel{
  constructor(options){
    this._name = "patient_preferences" //TODO: Use introspection to not need this (at least get filename programatically)
    this._schema = new mongoose.Schema(schema)
    this._schema.index({ user : 1, created: 1 })
    this._schema.pre('save', this.preSave)

    this.createModel()
    super(options)
  }

  preSave(next){
    // this should be the model instance not the BaseModel intanse
    if (this.isNew){
      this.created = moment().format('YYYY/MM/DD')
    }
    next()
  }

  postSave(){
    console.log("patient_preferences post save example")
  }

}

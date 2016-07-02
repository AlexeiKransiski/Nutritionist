import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'));

/**
 * Validations
 */

function validateStatus(value) {
  return ['open', 'waiting', 'answered', 'completed'].indexOf(value) > -1;
}

// Questionnaire Schema

let quiz = [
  {
   q: "1. Tell us how are you feeling, what is the reason of your consult?",
   id: 1,
   enabled: true,
   type: String
  },
  {
   q: "2. Tell us how are you feeling, what is the long term objectives of your consult?",
   id: 2,
   enabled: true,
   type: String
  },
  {
   q: "3. Stress level being 10 the highest, you are in?",
   id: 3,
   enabled: true,
   type: Number,
   choices: Array.apply(null, {length: 10}).map(function (value, index) { return Number.call(Number, index + 1) })
  }
]

let quizSchema = {
  patient: {type: mongoose.Schema.Types.ObjectId, ref: 'users'},
  date: Date
};

for (let key in quiz) {
  let q = quiz[key];
  if (q.enabled) {
    if (q.choices) {
      var validator = function (value) { return q.choices.indexOf(value) > -1 };
      quizSchema[`question${ q.id }`] = { type: q.type, validate: validator, required: true };
    } else {
      quizSchema[`question${ q.id }`] = { type: q.type, required: true };
    }
  }
};

// Reply schema

let replySchema = {
  message: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  status: { type: String, required: true },
  sender: { type: mongoose.Schema.Types.ObjectId, ref: 'users' },
  sender_name: { type: String, required: true },
  sender_avatar: { type: String, default: '/img/profile.png' },
  sender_status: String
}

// Appointment Schema

let appoitmentSchema = {
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'users' },
  nutritionist: { type: mongoose.Schema.Types.ObjectId, ref: 'users' },

  status: {type: String, validate: [validateStatus, '`{VALUE}` is not a valid `{PATH}`'], default: 'open' },
  quiz: quizSchema,
  replies: [replySchema],
  mood: {type: String},
  date: { type: Date },

  rating: {type: Number},
  feedback: {type: String},

  createdAt: { type: Date, default: Date.now },
  modifiedAt: { type: Date },

  // Calculated with the user.dob
  age: {type: Number},

  // Copy data from user on appointment creation
  full_name: {type: String},
  email: {type: String},
  avatar_src: {type: String},


  nutritionist_info: {
    full_name: {type: String},
    email: {type: String},
    avatar_src: {type: String},
  },

  height:{
    value: Number,
    units: String
  },
  weight:{
    value: String,
    units: String
  },
  desired_weight:{
    value: String,
    units: String
  },

  // Copy data from user.patientPreferences on appointment creation
  limitations: {type: Array, default: []},
  foods: {type: Array, default: []},
  medicines: {type: Array, default: []},
  vitamins: {type: Array, default: []},

  weather: {type: String}, // values: cold, temperate, warm, hot
  activity: {type: String}, // values: sedentary, light, active, very_active
  workout: {type: Number}, // values: 15, 30, 45, 60
  maintain: {type: String}, // values: lose, maintain, gain
};


export default class Appointment extends BaseModel{
  constructor(options){
    this._name = "appointments" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(appoitmentSchema)
    this._schema.index({ status : 1, replies: 1 })
    this._schema.path('patient').set(this.setPatient);

    this._schema.methods.addMessage = this.addMessage

    this.createModel()
    super(options)
  }

  postSave(){
    console.log("appointment post save example")
  }

  setPatient(new_value) {
    var _old_patient = this.patient;
    if (new_value == ""){
      return null;
    }else{
      if (new_value._id) {
        return new_value._id;
      } else {
        return new_value;
      }
   }
  }

  *addMessage(msg){
    this.replies.push(msg)
    switch(this.replies.length){
      case 2:
        this.status = 'answered'
        console.log('1')
        break
      case 3:
        this.status = 'waiting'
        console.log('2')
        break
      case 4:
        this.status = 'answered'
        console.log('3')
        break
    }
    return yield this.save()
  }

}

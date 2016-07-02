import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'))
var _ = require('underscore')

let schema = {
  created: {type: Date, default: Date.now},
  patient: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true},
  nutitionist: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: false},
  appointment: {type: mongoose.Schema.Types.ObjectId, ref: 'appointments', required: true},
  appointment_data: mongoose.Schema.Types.Mixed,
  /*
  events:
    - new
    - answered
    - waiting
    - completed
    - reated
  */
  event: {type: String, default: 'new'}
}


export default class AppointmentLog extends BaseModel{
  constructor(options){
    this._name = "appointments_log" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)

    this.createModel()
    super(options)
  }

}

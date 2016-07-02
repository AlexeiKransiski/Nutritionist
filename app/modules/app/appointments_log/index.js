import Model from "./model"
import BaseManager from "app/base/manager"
var _ = require('underscore')


export default class AppointmentLogManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *event(name, options) {
    var data = {
      appointment: options.appointment._id,
      appointment_data: options.appointment.toJSON(),
      patient: options.appointment.patient,
      nutitionist: options.appointment.nutritionist,
      event: name
    };
    return yield super.create(data)
  }
}

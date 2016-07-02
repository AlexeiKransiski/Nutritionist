import Model from "./model"
import BaseManager from "app/base/manager"
import UserManager from "app/users"
import AppointmentsLog from "app/appointments_log"
var _ = require('underscore')
var moment = require('moment')



export default class AppointmentManager extends BaseManager {

  constructor(options){
    this.model = new Model()
    this.populate = {
      "patient": '',
    }
    this.sort = {
      'createdAt': -1
    }
  }

  *create(data) {
    var user, nutritionist, appointment, msg;
    var users = new UserManager();
    var appointment_log, log;
    var present_count;

    user = yield users.findById(data.patient)
    if(user.subscription_appointments == 0 && user.appointments == 0){
      throw {status: 401, message: 'Patient does not have appointments'}
      return
    }
    if (user.nutritionist_assigned) {
      nutritionist = yield users.findById(user.nutritionist_assigned)
    } else {
      nutritionist = yield users.findNutritionist()
    }

    if (nutritionist) {
      user.nutritionist_assigned = nutritionist._id
      yield nutritionist.incrementNutritionistAppointments()
      yield user.saveAsync()
      
      data.nutritionist = nutritionist._id
      data = this.setUpDataFromNutritionist(data, nutritionist)
    } else {
      throw {status: 401, message: 'All nutritionists are busy. Please contact support.'}
      return
    }
    data = this.setUpDataFromPatient(data, user)
    msg = {
      sender: user._id,
      sender_name: user.full_name,
      message: data.message,
      status: 'question',
      sender_status: data.mood
    }
    if(user.avatar_src){
      msg.sender_avatar = user.avatar_src
    }
    data.replies = [msg]
    appointment = yield super.create(data)

    yield user.useAppointment()

    appointment_log = new AppointmentsLog()
    log = yield appointment_log.event("new", {appointment: appointment})

    return appointment
  }

  *updateById(id, data) {
    var appointment;

    appointment = yield super.updateById(id, data)
    yield this.addLog(appointment.status, appointment)

    return appointment
  }

  setUpDataFromPatient(data, patient) {
    var raw_data = patient.toJSON()
    _.extend(data, _.pick(raw_data, 'full_name', 'email', 'avatar_src', 'height', 'weight', 'desired_weight'))
    _.extend(data, _.pick(raw_data.patientPreferences, 'limitations', 'foods', 'medicines', 'vitamins', 'weather', 'activity', 'workout', 'maintain'))
    data.age = moment().diff(moment(raw_data.dob), 'years')
    return data
  }

  setUpDataFromNutritionist(data,  nutritionist) {
    var raw_data = nutritionist.toJSON()
    data.nutritionist_info = {}
    _.extend(data.nutritionist_info, _.pick(raw_data, 'full_name', 'email', 'avatar_src', 'height', 'weight', 'desired_weight'))
    return data
  }

  *addMessage(id, user_id, data) {
    var msg, user, msg_type, appointment;
    var users = new UserManager()
    var appointment_log, log;

    user = yield users.findById(user_id)
    appointment = yield this.findById(id)

    if (user._id.toString() == appointment.patient._id.toString()){
      msg_type = 'question'
    }else{
      msg_type = 'answer'
    }

    msg = {
      sender: user._id,
      sender_name: user.full_name,
      sender_avatar: user.avatar_src,
      message: data.message,
      status: msg_type
    }
    appointment = yield appointment.addMessage(msg)

    yield this.addLog(appointment.status, appointment)

    return _.last(appointment.replies)
  }

  *addLog(event, appointment) {
    var appointment_log, log;
    appointment_log = new AppointmentsLog()
    log = yield appointment_log.event(event, {appointment: appointment})

  }
}

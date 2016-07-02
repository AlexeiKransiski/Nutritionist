import conf from "config"
import BaseManager from "app/base/manager"
import appointmentManager from 'app/appointments'
import userManager from 'app/users'

export default class CommentManager extends BaseManager {

  constructor(options){
    this.name = "comments"
    return
  }

  *create(data) {
    var user_id = data.user;
    var appointment_id = data.appointment;

    var appointment = new appointmentManager();

    return yield appointment.addMessage(appointment_id, user_id, data.fields);
  }
}

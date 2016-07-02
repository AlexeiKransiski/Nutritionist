import conf from "config"
import BaseManager from "app/base/manager"
import userManager from 'app/users'
import Promise from "bluebird"

var sendgrid  = require('sendgrid')(conf.get("sendgrid.app_id"), conf.get("sendgrid.secret_id"));

export default class SupportManager extends BaseManager {

  constructor(options){
    this.name = "support"
    return
  }

  *create(data) {
    var user_id = data.user;
    var user;

    var users = new userManager();
    user = yield users.findById(user_id)
    
    return yield this.sendEmail(user, data)
  }

  *sendEmail(user, data) {

    var body = "<ul>"
                  + "<li><b>from: </b>" + user.full_name + "</li>"
                  + "<li><b>email: </b>" + user.email + "</li>"
                  + "<li><b>subject: </b>" + data.subject + "</li>"
                  + "<li><b>title: </b>" + data.title + "</li>"
                  + "<li><b>message: </b>" + data.message + "</li>"
                  + "</ul>"

    var email = new sendgrid.Email({
      to:       conf.get("emails.support"),
      from:     conf.get("emails.sender"),
      fromname: conf.get("emails.sender_name"),
      subject:  'Qalorie Support Message: ' + user.full_name,
      html:     body,
      text:     body
    });

    email.setFilters({
        'templates': {
            'settings': {
                'enable': 1,
                'template_id' : conf.get("sendgrid.support_id"),
            }
        }
    });

    sendgrid.send(email, function(){})
    
  }

}

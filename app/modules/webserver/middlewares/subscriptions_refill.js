import userManager from 'app/users'

var moment = require('moment')


module.exports = function *(next) {
  if(!this.isAuthenticated()){
    return yield next
  }
  var now = moment()
  var current_refill = moment(this.req.user.current_refill)
  var next_refill = moment(this.req.user.next_refill)
  var last_refill = moment(this.req.user.last_refill)

  if (now.isAfter(next_refill) && last_refill.isBefore(next_refill)) {
    var user = new userManager();
    yield user.refillSubscription(this.req.user._id);
  }

  return yield next
}

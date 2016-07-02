import Model from "./model"
import BaseManager from "app/base/manager"
import Promise from "bluebird"
import UserManager from "app/users"

var _ = require('underscore');
var moment = require('moment');

export default class TransactionManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *create(data) {

  }

  *addCredit(user_id, appointment) {
    var data = {};
    var transaction;

    data.transaction_type = 'debit'
    data.user = user_id
    data.item = appointmet

    transaction = yield super.create(data)

    users = new UserManager()
    users.creditAppointment(user_id, 1)
    return transaction
  }

  *addDebit(user, payment) {
    var data = {};
    var transaction;

    data.transaction_type = 'credit'
    data.user = user._id
    data.item = payment

    transaction = yield super.create(data)

    users = new UserManager()
    users.debitAppointment(user_id, payment.items)
    return transaction
  }
}

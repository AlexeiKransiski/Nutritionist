import conf from "config"

import Model from "./model"
import BaseManager from "app/base/manager"
import Promise from "bluebird"
import TransactionManager from "app/transactions"
import UserManager from "app/users"

var _ = require('underscore');
var moment = require('moment');

export default class OrderManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *create(data) {
    var user, order, item, amount
    var users = new UserManager()

    user = yield users.findById(data.user)

    data.stripe_customer = user.customer.stripe_id
    order = yield super.create(data)
    if (order.status == "error") {
      throw {status: 400, code: order.stripe_payment_error.statusCode, message: order.stripe_payment_error.message}
      return
    }
    item = _.findWhere(order.stripe_order.items, {type: 'sku', parent: conf.get('stripe.products.appointments.id')})
    if (item){
      amount = item.quantity
    }else{
      amount = data.items
    }
    yield user.addAppointment(data.items)
    return order
  }

}

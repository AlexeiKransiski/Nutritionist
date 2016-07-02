import BaseModel from "app/base/model"

import Promise from "bluebird"
import Stripe from 'app/stripe'

var co = require('co');

var mongoose = Promise.promisifyAll(require('mongoose'))
var _ = require('underscore')

let schema = {
  created: {type: Date, default: Date.now},
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true},
  stripe_customer: {type: String, required: true},
  items: {type: Number},
  price: {type: Number},
  discount: {type: Number},
  card: {type: String},
  /*
  * status: created, paid, canceled, error
  */
  status: {type: String, default: 'created'},
  stripe_order: {type: mongoose.Schema.Types.Mixed},
  stripe_payment: {type: mongoose.Schema.Types.Mixed},
  stripe_payment_error: {type: mongoose.Schema.Types.Mixed}
}


export default class FoodLog extends BaseModel{
  constructor(options){
    this._name = "orders" //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema)

    this._schema.pre('save', this.preSave)
    this._schema.methods.getStripeOrderData = this.getStripeOrderData

    this.createModel()
    super(options)
  }

  preSave(next) {
    var that = this;

    if (!this.isNew) {
      return next()
    }
    var stripe = new Stripe();
    co( function* () {
      var order;
      order = yield stripe.createAppointmentsOrder(that);
      return order
    }).then( function (order) {
      co(function* (){
        var payment;
        payment = yield stripe.payOrder(order, that.card)
        return payment
      }).then(function(payment){
        that.getStripeOrderData(payment)
        next()
      }, function (err){
        that.status = 'error'
        that.stripe_payment_error = err
        return next()
      })
    }, function (err) {
      err.status = err.statusCode
      return next(err)
    })
    return
  }

  postSave(){
    console.log("example")
  }

  getStripeOrderData(order) {
    this.stripe_order = order
    this.status = order.status
    return
  }
}

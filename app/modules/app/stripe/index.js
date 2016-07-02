import conf from "config"
import BaseManager from "app/base/manager"
var stripe = require('stripe')(conf.get('stripe.private_key'))
var _ = require('underscore')

export default class StripeManager extends BaseManager {
  constructor() {
    return this
  }

  *getCustomer(user){
    var customer;
    customer = yield stripe.customers.retrieve(user.customer.stripe_id);
    return customer
  }

  *createCustomer(user, params){
    var customer;
    customer = yield stripe.customers.create({
      email: user.email,
      plan: conf.get('stripe.plans.monthly.id'),
      metadata: {
        full_name: user.full_name
      },
      source: params.source
    })
    return customer
  }

  *updateSubscription(user, data) {
    var subscription, customer, update;

    update = _.omit(data, '_id')
    subscription = yield stripe.customers.updateSubscription(user.customer.stripe_id, user.subscription.stripe_id, update);
    customer = yield stripe.customers.retrieve(user.customer.stripe_id)

    return customer
  }

  *addCard(user, data){
    var card, customer;
    card = yield stripe.customers.createSource(user.customer.stripe_id, data);
    return card
  }

  *updateCard(user, card_id, data){
    var card, customer, fields, cleaned_data, make_default = false;

    fields = _.keys(data);
    cleaned_data = _.omit(data, [
      'customer',
      'id',
      'default',
      'address_line1_check',
      'address_zip_check',
      'brand',
      'country',
      'cvc_check',
      'dynamic_last4',
      'fingerprint',
      'funding',
      'last4',
      'tokenization_method',
      'object',
      'source'
    ])

    if (fields.length > 0){
      card = yield stripe.customers.updateCard(user.customer.stripe_id, card_id, cleaned_data);
    }else{
      card = yield stripe.customers.retrieveCard(user.customer.stripe_id, card_id);
    }

    return card
  }

  *defaultCard(user, card_id) {
    var customer;
    customer = yield stripe.customers.update(user.customer.stripe_id, {default_source: card_id});
    return customer
  }

  *deleteCard(user, card_id) {
    var customer;
    customer = yield stripe.customers.deleteCard(user.customer.stripe_id, card_id);
    return customer
  }

  *charge(data) {
    return true
  }

  *createAppointmentsOrder(data) {
    var order;
    console.log('ORDER DATA', data)

    order = yield stripe.orders.create({
      customer: data.stripe_customer,
      currency: 'usd',
      items: [
        {
          type: 'sku',
          parent: '1_app',
          quantity: data.items
        },
        {
          type: 'discount',
          currency: 'usd',
          amount: conf.get(`stripe.products.appointments.discount.${data.items}`) * -1,
          description: `${data.items} consultation plan has ${data.discount} free consultation`
        }
      ]
    })
    console.log('STRIPE  CREATEED ORDER')
    return order
  }

  *payOrder(order, card) {
    var payment;
    payment = yield stripe.orders.pay(order.id, {
      customer: order.customer,
      source: card
    })
    return payment
  }

  *createOrderAndPay(data) {
    var order, payment;
    order = yield this.createAppointmentsOrder(data)
    console.log( 'order', order)
    payment = yield this.payOrder(order, data.card)
    return payment
  }

}

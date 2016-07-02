import conf from "config"
import BaseManager from "app/base/manager"
import userManager from 'app/users'

var stripe = require('stripe')(conf.get('stripe.private_key'))

export default class CardManager extends BaseManager {

  constructor(options){
    this.name = "cards"
    return this
  }

  *create(data) {
    var user_id = data.user;
    delete data.user;
    var user = new userManager();
    return yield user.addCard(user_id, data.fields);
  }

  *updateById(card_id, data) {
    var user_id = data.user;
    delete data.user;
    var user = new userManager();
    return yield user.updateCard(user_id, card_id, data.fields);
  }

  *deleteById(user_id, card_id) {
    var user = new userManager();
    return yield user.deleteCard(user_id, card_id);
  }

}

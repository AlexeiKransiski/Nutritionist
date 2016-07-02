import conf from "config"
import BaseManager from "app/base/manager"
import userManager from 'app/users'

export default class SubscriptionManager extends BaseManager {

  constructor(options){
    this.name = "subscriptions"
    return
  }

  *updateById(id, data) {
    console.log('SUB MANA: ', id, data)
    var user = new userManager();
    return yield user.updateSubscription(id, data.fields);
  }
}

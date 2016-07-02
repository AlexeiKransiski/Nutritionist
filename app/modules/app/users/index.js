import Model from "./model"
import BaseManager from "app/base/manager"
import IM from "imagemagick"
import conf from "config"
import Promise from "bluebird"

var sendgrid  = require('sendgrid')(conf.get("sendgrid.app_id"), conf.get("sendgrid.secret_id"));

Promise.promisifyAll(IM)
Promise.promisifyAll(sendgrid)
// relationships
import patientPreferencesManager from 'app/patient_preferences'

var _ = require('underscore')
console.log("USER MANANGER")

export default class UserManager extends BaseManager{

  constructor(options){
    this.model = new Model()
    this.populate = {
      "patientPreferences": '',
    }
  }

  *create(query) {
    var user, patienPreferences, patient_preferences, resource, subscription

    user = yield this.model._model.findOne({email: query.email})
    
    if (user && !user.profileFilled) {
      yield this.model._model.remove({email: user.email})
      console.log('Remove temparary user')
    }

    user = yield super.create(query)

    patienPreferences = new patientPreferencesManager()
    patient_preferences = yield patienPreferences.create({user: user._id})

    // yield this.sendWelcomeEmail(user)

    user.patientPreferences = patient_preferences._id
    if (this.populate){
      resource = yield user.saveAsync()
      return yield this.populateResource(resource[0])
    }else{
      return yield user.saveAsync()
    }
    return yield user.saveAsync()
  }

  *updateById(id, updates) {
    var doc, crop, files_names, user;
    
    user = yield this.findById(id)
    if (!user.profileFilled && _.has(updates, 'welcome') ) {
      yield this.sendWelcomeEmail(user)
      delete updates.welcome
    }
    if (_.has(updates, 'avatar')){
      delete updates.avatar
    }
    if (_.has(updates, 'credit_cards')){
      delete updates.credit_cards
    }
    if (_.has(updates, 'oldpassword')){
      if (!user.compareOldPassword(updates.oldpassword)) {
        err = new Error('Old password is not correct.');
        err.status = 403;
        throw err;
      }
      delete updates.oldpassword
    }
    if (_.has(updates, 'create_stripe_customer')){
      console.log('create stripe')
      delete updates.create_stripe_customer

      yield user.createStripeCustomer(updates)
      return yield this.sendFreeTrialUpgradeConformationEmail(user)
    }
    doc = yield super.updateById(id, updates)

    if (updates.files){
      files_names = _.keys(updates.files)
      for (var i=0; i < files_names.length; i++){
        // TODO: replace mongoose-attachment with mongoose-crate: https://github.com/achingbrain/mongoose-crate
        var path;
        if (files_names[i] == 'avatar') {
          path = doc[files_names[i]].original.path
        }else if (files_names[i] == 'photo') {
          path = doc[files_names[i]].photo_original.path
        }
        try{
          yield this.imConvert(doc, files_names[i],updates)
          yield doc.attachAsync(files_names[i], {
            path: path
          })
        }catch(e){
          throw e
        }
      }
      return doc
    }else{
      return doc
    }
  }

  *imConvert(doc, field, data) {
    var path;
    if (field == 'avatar') {
      path = doc[field].original.path
    }else if (field == 'photo') {
      path = doc[field].photo_original.path
    }
    yield IM.convertAsync([
      path,
      '-gravity',
      'NorthWest',
      '-crop',
      `${data[field + '_w']}x${data[field + '_h']}+${data[field + '_x']}+${data[field + '_y']}`,
      '-resize',
      `${data[field + '_sw']}x${data[field + '_sh']}!`,
      path
    ])
  }

  *changePassword(id, updates){
    var user

    user = yield this.model._model.findByIdAsync(id)
  }

  *updateSubscription(id, update) {
    var user;
    user = yield this.findById(id)

    return yield user.updateSubscription(update)
  }

  *refillSubscription(id) {
    var user;
    user = yield this.findById(id)
    return yield user.refillSubscription()
  }

  *addCard(user_id, data) {
    var user;

    user = yield this.findById(user_id)
    return yield user.addCard(data)
  }

  *updateCard(user_id, card_id, data) {
    var user;

    user = yield this.findById(user_id)
    return yield user.updateCard(card_id, data)
  }

  *deleteCard(user_id, card_id) {
    var user;

    user = yield this.findById(user_id)
    return yield user.deleteCard(card_id)
  }

  *creditAppointment(user_id, amount){
    var user;

    user = yield this.findById(user_id)
    return yield user.useAppointment(amount)
  }

  *debitAppointment(user_id, amount){
    var user;

    user = yield this.findById(user_id)
    return yield user.addAppointment(amount)
  }


  *findNutritionist() {
    var queryset;
    var nutritionist;
    var min_count;
    queryset = yield this.model._model.find({is_nutritionist: true, appointments_count: {$lt: 800}}).sort({'appointments_count': 1}).limit(1).execAsync()
    if (queryset.length > 0 ) {
      return queryset[0];
    } else {
      return null
    }
  }



  *incrementNutritionistAppoinment() {
    var nutritionist;
    nutritionist = yield this.findNutritionist()
    if (nutritionist){
      yield nutritionist.incrementNutritionistAppointments()
      return nutritionist
    }else{
      throw Error('NO NUTRITIONIST FOUND')
    }

  }

  *sendWelcomeEmail (user){
    var email = new sendgrid.Email({
      // to:       user.email,
      to:       user.email,
      from:     conf.get("emails.sender"),
      fromname: conf.get("emails.sender_name"),
      subject:  `Welcome to Qalorie ${user.full_name}`,
      text:     user.email,
      html:     user.email
    });
    console.log('Send Welcome Email' + user.full_name)

    email.setFilters({
        'templates': {
            'settings': {
                'enable': 1,
                'template_id' : conf.get("sendgrid.welcome_id"),
            }
        }
    });

    return sendgrid.sendAsync(email);
  }

  *deleteById(id) {
    var updates, user;
    updates ={
      is_active: false
    }
    user = yield this.findById(id)

    yield this.sendGoodByeEmail(user)
    return  yield this.updateById(id, updates)
  }

  *sendGoodByeEmail (user){
    var email = new sendgrid.Email({
      to:       user.email,
      from:     conf.get("emails.sender"),
      fromname: conf.get("emails.sender_name"),
      subject:  'Deleted Account',
      text:     user.email,
      html:     user.email
    });


    email.setFilters({
        'templates': {
            'settings': {
                'enable': 1,
                'template_id' : conf.get("sendgrid.delete_id"),
            }
        }
    });

    email.addSubstitution('-full_name-', user.full_name);

    return sendgrid.sendAsync(email);
  }

  *sendFreeTrialUpgradeConformationEmail (user){
    var email = new sendgrid.Email({
      to:       user.email,
      from:     conf.get("emails.sender"),
      fromname: conf.get("emails.sender_name"),
      subject:  'Confirmation',
      text:     user.subscription.stripe_data.plan.amount/100,
      html:     user.subscription.stripe_data.plan.amount/100,
    });

    email.setFilters({
        'templates': {
            'settings': {
                'enable': 1,
                'template_id' : conf.get("sendgrid.ft_upgrade_id"),
            }
        }
    });

    email.addSubstitution('-first_name-', user.first_name);

    return sendgrid.send(email);
  }

}

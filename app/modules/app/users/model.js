import conf from "config"
import BaseModel from "app/base/model"
import Promise from "bluebird"
import path from 'path'
import IM from "imagemagick"
var co = require('co');

import Stripe from 'app/stripe'
var _ = require('underscore')

var filePluginLib = require('mongoose-file');
var filePlugin = filePluginLib.filePlugin;
var make_upload_to_model = filePluginLib.make_upload_to_model;

var moment = require('moment')
var uniqueValidator = require('mongoose-unique-validator')
var validator = require('validator')
var uuid = require("uuid")
var bcrypt = require("bcrypt")
var SALT_WORK_FACTOR = 10


var mongoose = Promise.promisifyAll(require('mongoose'))
// SMELL, TODO: this shouldn't be using require and var
//import mongoose from "mongoose"
//Promise.promisifyAll(mongoose.Model)
//Promise.promisifyAll(mongoose.Model.prototype)

var uploads_base = path.join(__dirname, "../../webserver/public/");
var uploads = path.join(uploads_base, "uploads/u");

var attachments = Promise.promisifyAll(require('mongoose-attachments-localfs'));

var uploads_base = path.join(__dirname, "../../webserver/public/");
var rel_path = "/uploads/u/images"
var uploads = path.join(uploads_base, rel_path);


let userSchema = {
  first_name: {type: String},
  last_name: {type: String},
  password: {type: String},
  email: {type: String, required: true, unique: true},
  is_active: {type: Boolean, default: true},
  is_nutritionist: {type: Boolean, default: false},
  nutritionist_assigned: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
  patientPreferences: {type: mongoose.Schema.Types.ObjectId, ref: 'patient_preferences'},
  nutritionistPreferences: {type: mongoose.Schema.Types.ObjectId, ref: 'NutritionistPreferences'},
  created: { type: Date, default: Date.now },
  modified: { type: Date, default: Date.now },
  dob: Date,
  /*
    status:
      '0': greate
      '1': happy
      '2': chill
      '3': sick
      '4': bad
      '5': depress
  */
  status: {type: Number, default: 0},
  height:{
    value: Number,
    units: String
  },
  weight:{
    value: String,
    units: String
  },
  desired_weight:{
    value: String,
    units: String
  },
  //Add rocomendations
  calories_recomended:{type: Number, default: 0},
  water_recomended:{type: Number, default: 0},
  time_recomended:{type: Number, default: 0},
  gender: {type: String},
  pregnant: {type: String, default: 'No'},
  breastfeeding: {type: String, default: 'No'},
  widgets: {
    weight: {type: String, default: 'kgr'},
    height: {type: String, default: 'mts'},
    distance: {type: String, default: 'km'},
    energy: {type: String, default: 'cal'},
    meassure:{type: String, default: 'metric'},

    nutricional: {
      items: {type: Array, default: ['carbs', 'fat', 'protain', 'cholesterol', 'sodium', 'potassium']}
    }
  },
  goals:{
    text:{type: String},
    motivation:{type: String}
  },

  lifestyle: {type: String},

  profileFilled: {type: Boolean, default: false},
  facebook_id: {type:String},
  facebook_token:{type:String},
  customer: {
    stripe_id: {type: String}
  },
  subscription: {
    plan: {type: String, default: conf.get('stripe.plans.trial.id')}, //free, month and year
    stripe_id: {type: String},
    status: {type: String, default: 'active'},
    coupon: {type: String},
    stripe_data: {type: mongoose.Schema.Types.Mixed}
  },

  current_refill: {type: Date},
  next_refill: {type: Date},
  last_refill: {type: Date},

  default_credit_card: {type: String},
  credit_cards: {type: mongoose.Schema.Types.Mixed},

  // appointment balace
  appointments: {type: Number, default: 0},
  subscription_appointments: {type: Number, default: 1},

  // for nutritionist
  appointments_count: {type: Number, default: 0}
}


export default class User extends BaseModel{
  //TODO: Find a way to define schema and model in super so not every model have to import mongoose
  constructor(options){
    this._name = "users" //TODO: Use introspection to not need this

    // schemade definition
    this._schema = new mongoose.Schema(userSchema)
    this._schema.methods.getStripeCustomerData = this.getStripeCustomerData
    this._schema.methods.createStripeCustomer = this.createStripeCustomer
    this._schema.methods.updateSubscription = this.updateSubscription
    this._schema.methods.addCard = this.addCard
    this._schema.methods.updateCard = this.updateCard
    this._schema.methods.deleteCard = this.deleteCard
    this._schema.methods.useAppointment = this.useAppointment
    this._schema.methods.addAppointment = this.addAppointment
    this._schema.methods.incrementNutritionistAppointments = this.incrementNutritionistAppointments
    this._schema.methods.refillSubscription = this.refillSubscription

    this._schema.pre('save', this.preSave)

    this._schema.plugin(uniqueValidator)
    this._schema.set('toObject', {
      getters: true,
      virtuals: true
    })
    this._schema.set('toJSON', {
      virtuals: true
    })

    // files
    let that = this;

    // TODO: replace mongoose-attachment with mongoose-crate: https://github.com/achingbrain/mongoose-crate
    this._schema.plugin(attachments, {
        directory: uploads,
        storage : {
            providerName: 'localfs'
        },
        properties: {
            avatar: {
                styles: {
                    original: {
                        // keep the original file
                    },
                    thumb: {
                      thumbnail: '100x100^',
                      gravity: 'center',
                      extent: '100x100',
                      '$format': 'jpg'
                    }
                }
            },
            photo: {
                styles: {
                    photo_original: {
                        // keep the original file
                    },
                    photo_thumb: {
                      thumbnail: '100x100^',
                      gravity: 'center',
                      extent: '100x100',
                      '$format': 'jpg'
                    }
                }
            }
        }
    });

    this._schema.virtual('avatar_src').get(function() {
      if (!this.avatar || !this.avatar.original || !this.avatar.original.path) return '/img/profile.png';
      return `${path.join(`${rel_path}/original`, path.basename(this.avatar.original.path))}?t=${moment(this.modified).unix()}`;
    });
    this._schema.virtual('avatar_thumb').get(function() {
      if (!this.avatar || !this.avatar.thumb || !this.avatar.thumb.path) return '/img/profile.png';
      return `${path.join(`${rel_path}/thumb`, path.basename(this.avatar.thumb.path))}?t=${moment(this.modified).unix()}`;
    });

    this._schema.virtual('photo_src').get(function() {
      if (!this.photo || !this.photo.photo_original || !this.photo.photo_original.path) return null;
      return `${path.join(`${rel_path}/photo_original`, path.basename(this.photo.photo_original.path))}?t=${moment(this.modified).unix()}`;
    });
    this._schema.virtual('photo_thumb').get(function() {
      if (!this.photo || !this.photo.photo_thumb || !this.photo.photo_thumb.path) return null;
      return `${path.join(`${rel_path}/photo_thumb`, path.basename(this.photo.photo_thumb.path))}?t=${moment(this.modified).unix()}`;
    });
    // setters
    this._schema.path('patientPreferences').set(function(new_value){
      this._old_patientPreferences = this.patientPreferences
      if( new_value == ""){
        return this._old_patientPreferences
      }else if (new_value._id){
        return new_value._id
      }else{
        return new_value
      }
    })

    this._schema.path('nutritionistPreferences').set(function(new_value){
      this._old_nutritionistPreferences = this.nutritionistPreferences
      if( new_value == ""){
        return this._old_nutritionistPreferences
      }else if(new_value._id){
        return new_value._id
      }else{
        return new_value
      }
    })

    // validations
    this._schema.path("email").validate( function (val) {
        return validator.isEmail(val)
      },
      "Invalid Email"
    )

    // virtual fields
    this._schema.virtual('full_name').get(function () {
      return this.first_name + ' ' + this.last_name;
    });

    this._schema.virtual('token').get(function() {
      return this._token;
    })

    this._schema.virtual('token').set(function (token) {
      this._token = token
      return
    })

    // methods
    this._schema.methods.comparePassword = this.comparePassword
    this._schema.methods.compareOldPassword = this.compareOldPassword

    this.createModel()

    super(options)
  }

  preSave(next) {
    var user = this
    this.modified = Date.now()
    this.email = this.email.toLocaleLowerCase()
    if (!this.isModified("password")) {
      return next()
    }

    bcrypt.genSalt(SALT_WORK_FACTOR, function(err, salt) {
      if (err) {
        return next(err);
      }
      return bcrypt.hash(user.password, salt, function(err, hash) {
        if (err) {
          return next(err);
        }
        user.password = hash;
        return next()
      });
    });
    return;
  }

  postSave(){
    return true
  }

  comparePassword(candidatePassword, cb) {
    bcrypt.compare(candidatePassword, this.password, function(err, isMatch) {
      if (err) {
        return cb(err, false);
      }
      return cb(null, isMatch);
    });
  }

  compareOldPassword(candidatePassword) {
    return bcrypt.compareSync(candidatePassword, this.password)
  }

  *createStripeCustomer(params) {
    var that = this;
    var stripe = new Stripe();

    var newCustomer;
    newCustomer = yield stripe.createCustomer(this, params);
    this.getStripeCustomerData(newCustomer)
    this.current_refill = moment(this.subscription.stripe_data.current_period_start * 1000).toISOString()
    this.next_refill = moment(this.subscription.stripe_data.current_period_start * 1000).add(1, 'M').toISOString()
    this.last_refill = moment(this.subscription.stripe_data.current_period_start * 1000).toISOString()

    return yield this.save()
  }

  *updateSubscription(data) {
    var that = this;
    var customer;
    var stripe = new Stripe();

    customer = yield stripe.updateSubscription(that, data);
    this.getStripeCustomerData(customer)
    this.current_refill = moment(this.subscription.stripe_data.current_period_start * 1000).toISOString()
    this.next_refill = moment(this.subscription.stripe_data.current_period_start * 1000).add(1, 'M').toISOString()
    this.last_refill = moment(this.subscription.stripe_data.current_period_start * 1000).toISOString()

    return yield that.save()
  }

  *refillSubscription() {
    var data, now = moment()
    var current_refill = moment(this.current_refill).year(now.year()).month(now.month()).toISOString()
    var next_refill = moment(this.current_refill).add(1, 'M').toISOString()
    var last_refill = moment().toISOString()

    data = {
      '$set': {
        'current_refill': current_refill,
        'next_refill': next_refill,
        'last_refill': last_refill
      },
      '$inc': {
        'subscription_appointments': 1
      }
    }
    this.update(data)
    return yield this.updateAsync(data)
  }

  *addCard(data) {
    var that = this;
    var customer, card, user;
    var stripe = new Stripe();

    card = yield stripe.addCard(that, data);
    customer = yield stripe.defaultCard(this, card.id)

    this.getStripeCustomerData(customer)
    user = yield that.save()

    return card
  }

  *updateCard(card_id, data) {
    var that = this;
    var customer, make_default, user, card;
    var stripe = new Stripe();
    if (_.has(data, 'default') && data.default == true) {
      make_default = true;
      delete data.default
    }

    card = yield stripe.updateCard(that, card_id, data);
    if (make_default) {
      customer = yield stripe.defaultCard(this, card_id)
    }else{
      customer = yield stripe.getCustomer(this)
    }
    this.getStripeCustomerData(customer)
    user = yield that.save()
    return card
  }

  *deleteCard(card_id) {
    var that = this;
    var err;
    var customer, card, user;
    var stripe = new Stripe();
    if (this.credit_cards.total_count <= 1) {
      err = new Error('Customer only has one card.');
      err.status = 403;
      throw err;
    }else if (this.default_credit_card == card_id){
      err = new Error('No posible to delete the default credit card, first change the default card.');
      err.status = 403;
      throw err;
    }
    card = yield stripe.deleteCard(this, card_id);
    customer = yield stripe.getCustomer(this)
    user = yield that.save()
    return card
  }

  getStripeCustomerData(stripe_customer) {
    this.customer.stripe_id = stripe_customer.id
    this.subscription.stripe_id = stripe_customer.subscriptions.data[0].id
    this.subscription.plan = stripe_customer.subscriptions.data[0].plan.id
    this.subscription.stripe_data = stripe_customer.subscriptions.data[0]

    var ref, ref1, ref2, ref3;
    if ((typeof stripe_customer !== "undefined" && stripe_customer !== null ? (ref = stripe_customer.subscriptions) != null ? (ref1 = ref.data[0]) != null ? (ref2 = ref1.discount) != null ? (ref3 = ref2.coupon) != null ? ref3.id : void 0 : void 0 : void 0 : void 0 : void 0) != null) {
      this.subscription.coupon = stripe_customer.subscriptions.data[0].discount.coupon.id
    }
    this.credit_cards = stripe_customer.sources
    this.default_credit_card = stripe_customer.default_source
    return
  }

  *addAppointment(amount) {
    var data;
    data = {
      '$inc': {
        'appointments': amount
      }
    }
    this.update(data)
    return yield this.updateAsync(data)
  }

  *useAppointment() {
    var data;

    if (this.subscription_appointments > 0 ){
      data = {
        '$inc': {
          'subscription_appointments': -1
        }
      }
    }else{
      data = {
        '$inc': {
          'appointments': -1
        }
      }
    }

    return yield this.updateAsync(data)
  }

  *incrementNutritionistAppointments() {
    var data;
    data = {
      '$inc': {
        'appointments_count': 1
      }
    }
    // this.update(data)
    return yield this.updateAsync(data)
  }
}

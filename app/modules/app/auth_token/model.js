import conf from "config"
import BaseModel from "app/base/model"
import Promise from "bluebird"

var _ = require("underscore")
var jwt = require('jwt-simple')
var uniqueValidator = require('mongoose-unique-validator')

var mongoose = Promise.promisifyAll(require('mongoose'))
// SMELL, TODO: this shouldn't be using require and var
//import mongoose from "mongoose"
//Promise.promisifyAll(mongoose.Model)
//Promise.promisifyAll(mongoose.Model.prototype)

let authTokenSchema = {
  token:  { type: String },
  user_id:  { type: String, required: false },
  scope: [{type: String}],
  context: {
    user_id: { type: String, required: false }
  }
}

export default class AuthToken extends BaseModel{
  //TODO: Find a way to define schema and model in super so not every model have to import mongoose
  constructor(options){
    this._name = "auth_token" //TODO: Use introspection to not need this

    // schema definitien
    this._schema = new mongoose.Schema(authTokenSchema)
    this._schema.plugin(uniqueValidator)
    this._schema.pre('save', this.preSave)
    this._schema.statics.get_or_create = this.getOrCreate
    this._schema.statics.verify = this.verityToken

    //model creation
    // try{
    //   this._model = mongoose.model(this._name, this._schema)
    //
    // }catch(error){
    //   this._model = mongoose.model(this._name)
    // }
    this.createModel()

    super(options)
  }

  preSave(next) {
    var token = this
    var context = _.clone(token.context.toJSON())
    var a = _.extend(context, {scope: token.scope})

    token.token = jwt.encode(context, conf.get('auth.auth_token_secret'))
    next()
  }

  postSave(){
    console.log("post save example")
  }

  getOrCreate(userId, callback){
    var Model = this
    this.findOne({
      user_id: userId,
    }, function(error, result) {
      var context, scope, token;
      if (error) {
        return callback(error, null);
      }
      if (result === null) {
        context = {
          user_id: userId
        };
        scope = ["user"];
        token = new Model({
          context: context,
          scope: scope,
          user_id: userId
        });
        return token.save(function(error, result) {
          if (error) {
            return callback(error, null);
          }
          return callback(null, result);
        });
      } else {
        return callback(null, result);
      }
    });
  }

  verityToken(token, callback) {
    this.findOne({
      token: token
    }, function(error, result) {
      if (error) {
        return callback(error, null);
      }
      if (result === null) {
        return callback(null, null);
      } else {
        return callback(null, result);
      }
    });
  }
}

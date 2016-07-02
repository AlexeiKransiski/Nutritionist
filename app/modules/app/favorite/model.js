import BaseModel from "app/base/model"

import Promise from "bluebird"
var mongoose = Promise.promisifyAll(require('mongoose'));

let schema = {
  owner: { type: mongoose.Schema.Types.ObjectId, ref: 'users' },
  object: { type: mongoose.Schema.Types.ObjectId },
  type: { type: String, required: true },  // base types now are food and exercise.

  createdAt: { type: Date, default: Date.now }
};


export default class Favorite extends BaseModel{
  constructor(options){
    this._name = "favorite"; //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema);
    this._model = mongoose.model(this._name, this._schema);

    super(options);
  }

  postSave(){
    console.log("favorite post save example");
  }

}

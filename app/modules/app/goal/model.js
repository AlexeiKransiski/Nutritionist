import BaseModel from "app/base/model"
import Promise from "bluebird"

var mongoose = Promise.promisifyAll(require('mongoose'));


function typeValidator(value) {
  return ['fitness', 'nutritional', 'mental'].indexOf(value.toLowerCase()) > -1;
}


let schema = {
  created: { type: Date, default: Date.now },

  description: { type: String, default: "" },
  done: { type: Boolean, default: false },
  type: { type: String, required: true, validate: [typeValidator, '`{VALUE}` is not a valid `{PATH}`'] },

  // References
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'users' }
}


export default class Goal extends BaseModel {
  constructor(options){
    this._name = "goal"; //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema);

    this.createModel();
    super(options);
  }

  postSave(){
    console.log("Goal post save example");
  }

}

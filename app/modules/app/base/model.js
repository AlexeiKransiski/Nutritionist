import mongoose from "mongoose"
import Promise from "bluebird"
import colors from "colors"

export default class BaseModel {
  constructor(options){

    // TODO: Use metaprograming Proxies to deliver underlying datastore methods
    //       or something ninja like: Object.defineProperty(this, "oe", {value: "yeah"})
    this.setupHooks()
  }

  createModel() {
    try{
      this._model = mongoose.model(this._name, this._schema)
    }catch(error){
      this._model = mongoose.model(this._name)
    }
    Promise.promisifyAll(this._model)
    Promise.promisifyAll(this._model.prototype);
  }

  setupHooks(){
    this.setupPostSave()
    this.setupPostRemove()
  }

  setupPostRemove(){
    if(this.postRemove != undefined){
      console.log(`[BaseModel]`.blue+` Setting up `.green+`${this._name} postRemove`.yellow+` hook`.green)
      this._schema.post('remove', this.postRemove)
    }
  }

  setupPostSave(){
    if(this.postSave != undefined){
      console.log(`[BaseModel]`.blue+` Setting up `.green+`${this._name} postSave`.yellow+` hook`.green)
      this._schema.post('save', this.postSave)
    }
  }
}

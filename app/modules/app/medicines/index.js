import Model from "./model"
import BaseManager from "app/base/manager"

export default class MedicinesManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  // *findAll(query, limit, offset) {
  //   console.log("offset: "+offset)
  //   return yield this.model._model.findAsync(query, {}, {skip: 0, limit: 2})
  // }

}

import Model from "./model"
import BaseManager from "app/base/manager"

var _ = require('underscore')

export default class PreferenceManager extends BaseManager{ 

  constructor(options){
    this.model = new Model()
  }

}

import Model from "./model"
import BaseManager from "app/base/manager"
var moment = require('moment')

export default class NutritionInformationManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }
}

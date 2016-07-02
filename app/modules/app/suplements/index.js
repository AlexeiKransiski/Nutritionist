import Model from "./model"
import BaseManager from "app/base/manager"

export default class SuplementsManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

}

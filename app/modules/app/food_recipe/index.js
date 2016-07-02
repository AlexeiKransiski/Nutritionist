import Model from "./model"
import BaseManager from "app/base/manager"

export default class FoodRecipeManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }
}

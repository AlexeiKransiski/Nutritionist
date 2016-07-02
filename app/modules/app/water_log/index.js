import Model from "./model"
import BaseManager from "app/base/manager"
var moment = require('moment')

export default class WaterLogManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  // *getOrCreateCurrent(user_id, date) {
  //   var result, food_log
  //   console.log('food_log start')
  //   // try{
  //   //   food_log = yield this.model._model.findOneAsync({date: moment(date)})//.then(function(food_log){
  //   //   console.log('food_log: ')
  //   // }catch(e){
  //   //   console.log
  //   // }
  //   //   return
  //   // }).catch(function(error){
  //   //   console.log('food_log: ', food_log)
  //   //
  //   // })
  //   return yield this.model.getORCreateCurrent(user_id, date)
  //   console.log('result:', result)
  //   // result = this.model.getORCreateCurrent(user_id, date)
  //   // food_log = result.next().then(function(item){
  //   //   console.log('then: ',item)
  //   // }).catch(function(error){
  //   //   console.log('catch: ', error)
  //   // })
  //   // // while(!food_log.done){
  //   // //   food_log = result.next()
  //   // // }
  //   // console.log('food log:', result, food_log)
  //   return
  // }
}

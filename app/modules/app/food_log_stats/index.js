import Model from "./model"
import BaseManager from "app/base/manager"
var moment = require('moment')
var _ = require('underscore')

export default class FoodLogStatsManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *addFood(food_log){
    var food_log_stat, date, stats
    date = moment(moment(food_log.created).format('YYYY/MM/DD'), "YYYY/MM/DD").toISOString()
    try{
      food_log_stat = yield this.model._model.findOneAsync({user: food_log.user, date: date})
    }catch(_error){
      throw(_error)
    }
    if(!food_log_stat){
      stats = {
        user: food_log.user,
        date: date
      }
      stats[food_log.meal_type] = food_log.calories
      food_log_stat = yield this.create(stats)
      return food_log_stat

    }else{
      food_log_stat[food_log.meal_type] += food_log.calories
      return yield food_log_stat.saveAsync()
    }
  }

  *addBulkFood(food_log){
    var food_log_stat, date, stats, calories
    date = moment(moment(food_log.created).format('YYYY/MM/DD'), "YYYY/MM/DD").toISOString()
    try{
      food_log_stat = yield this.model._model.findOneAsync({user: food_log[0].user, date: date})
    }catch(_error){
      throw(_error)
    }
    calories = _.reduce(_.pluck(food_log, 'calories'), function(memo, num){
      return memo + num
    }, 0)
    if(!food_log_stat){
      stats = {
        user: food_log[0].user,
        date: date
      }
      stats[food_log[0].meal_type] = calories
      food_log_stat = yield this.create(stats)
      return food_log_stat

    }else{
      food_log_stat[food_log[0].meal_type] += calories
      return yield food_log_stat.saveAsync()
    }
  }
}

import Model from "./model"
import BaseManager from "app/base/manager"
import FoodLogStatsManager from "app/food_log_stats"
import Metrics from 'app/metrics'
var _ = require('underscore')


export default class FoodLogManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *findAll(query, limit, offset) {
    console.log(query)
    if (query.distinct == 1) {
      delete query.distinct
      var food_logs = yield this.model._model.findAsync(query, {}, {skip:0, limit: 999999})
      var food_log_food_ids = []
      var food_logs_grouped = []

      _.each(food_logs, function(log) {
        if (_.contains(food_log_food_ids, log.food.toString())) {
          return
        }
        food_log_food_ids.push(log.food.toString())
        food_logs_grouped.push(log)
      })

      return food_logs_grouped.slice(offset, offset + limit);
    } else {
      return yield super.findAll(query, limit, offset)
    }

    
  }

  *create(query){
    var food_log, FoodLogStats, food_log_stat;
    var is_bulk=false, bulk_result;
    var metric, log;
    if (query.bulk){
      is_bulk = true
      _.each(query.data, function(item){
        item.user = query.user
      })
      query = query.data
    }
    try{
      food_log = yield super.create(query)
    }catch(_error){
      console.log("error creating food_log")
      throw(_error)
    }

    if (is_bulk){
      bulk_result = {
        data: food_log,
        nextHref: null
      }
      FoodLogStats = new FoodLogStatsManager()
      food_log_stat = yield FoodLogStats.addBulkFood(food_log)
      return bulk_result
    }else{
      metric = new Metrics()
      log = yield metric.create(food_log)
      FoodLogStats = new FoodLogStatsManager()
      food_log_stat = yield FoodLogStats.addFood(food_log)
      return food_log
    }
  }

  *deleteById(id) {
    var food_log = yield super.deleteById(id)
    var metric = new Metrics()

    var log = yield metric.delete(food_log)
    return food_log
  }
}

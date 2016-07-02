import Model from "./model"
import BaseManager from "app/base/manager"

import FoodLogModel from 'app/food_log/model'
import ExerciseLogModel from 'app/exercise_log/model'
import ProgressModel from 'app/progress/model'

var moment = require('moment')
var _ = require('underscore')

export default class MetricsDailyManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *create(log) {
    var context;

    if (log instanceof (new FoodLogModel())._model){
      context = 'food'
    }else if(log instanceof (new ExerciseLogModel())._model) {
      context = 'exercise'
    }else if(log instanceof (new ProgressModel())._model) {
      context = 'progress'
    }

    try{
      yield this.addLog(context, log)
    }catch(e){
      console.log(`ADD DAILY METRIC FAIL -> USER: ${log.user} FOOD_LOG: ${log._id} DATE: ${log.created} ERROR: ${e}`)
      throw(e)
    }
  }

  *addLog(context, log){
    var log_stat, log_date, date, stats, increment_data;
    if(context == 'food'){
      log_date = moment(log.created);
    }else if (context == 'exercise'){
      log_date = moment(log.exercise_date);
    }else if (context == 'progress'){
      log_date = moment(log.date);
    }else{
      log_date = moment(log.created);      
    }

    try{
      log_stat = yield this.model._model.findOneAsync({
        user: log.user,
        year_month: log_date.format('YYYYMM'),
        context: context
      })
    }catch(_error){
      throw(_error)
    }
    if(!log_stat){
      stats = {
        user: log.user,
        context: context,
        year: log_date.format('YYYY'),
        month: log_date.format('MM'), //check moment().month() it 0-11
        year_month: log_date.format('YYYYMM'),
        days: {}
      }
      stats.days[log_date.date()] = log.getMetrics()
      log_stat = yield super.create(stats)
      return log_stat

    }else{
      increment_data = this.getIncrementMetrics(log_date.date(), log.getMetrics())
      return yield log_stat.updateAsync(increment_data)
    }
  }

  getIncrementMetrics(day, data) {
    var keys, inc_metrics = {};
    keys = _.keys(data)
    for (var i=0; i<keys.length; i++) {
      inc_metrics[`days.${day}.${keys[i]}`] = parseFloat(data[keys[i]])
    }
    return {
      '$inc': inc_metrics
    }
  }

  *findAll(query, limit, offset) {
    var queryset, metric_query;
    this.clean_query(query);

    // this.validate(query);
    //
    // metric_query = {
    //   user: query.user,
    //   context: query.context,
    //   year_month: {
    //     '$gte': moment(query.from).format('YYYYMM'),
    //     '$lte': moment(query.to).format('YYYYMM')
    //   },
    // }
    metric_query = query
    return yield super.findAll(metric_query, 24, 0)
  }

  validate(query) {
    var date_from, date_to;

    if (!_.has(query, 'from')){
      throw(new Error('From date its required'))
    }
    if (!_.has(query, 'to')){
      throw(new Error('To date its required'))
    }

    date_from = moment(query.from);
    date_to = moment(query.to);
    if (date_from.isAfter(date_to)){
      throw(new Error('From must be before To date'))
    }
    return true
  }

  *delete(log) {
    var context;
    var log_negative;

    if (log instanceof (new FoodLogModel())._model){
      context = 'food'
    }else if(log instanceof (new ExerciseLogModel())._model) {
      context = 'exercise'
    }else if(log instanceof (new ProgressModel())._model) {
      context = 'progress'
    }

    try{
      log_negative = this.getSubtractMetrics(log)
      yield this.addLog(context, log_negative)
    }catch(e){
      console.log(`ADD DAILY METRIC FAIL -> USER: ${log.user} FOOD_LOG: ${log._id} DATE: ${log.created} ERROR: ${e}`)
      throw(e)
    }
  }

  getSubtractMetrics(log) {
    var metrics = log.getMetrics()
    console.log("GET NEGA METRICS: ", metrics)
    var keys, inc_metrics = {};
    keys = _.keys(metrics)
    for (var i=0; i<keys.length; i++) {
      log[`${keys[i]}`] = parseFloat(metrics[keys[i]]) * -1
    }
    return log
  }
}

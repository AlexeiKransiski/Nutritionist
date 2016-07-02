import Model from "./model"
import BaseManager from "app/base/manager"
import Metrics from 'app/metrics'


export default class ExerciseManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *create(query){
    var exercise_log;
    var metric, log;

    try{
      exercise_log = yield super.create(query)
    }catch(_error){
      console.log("error creating exercise_log")
      throw(_error)
    }
    metric = new Metrics()
    log = yield metric.create(exercise_log)
    return exercise_log
  }

  *deleteById(id) {
    var del_log = yield super.deleteById(id)
    var metric = new Metrics()

    var log = yield metric.delete(del_log)
    return del_log
  }

}

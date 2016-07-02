import Model from "./model"
import BaseManager from "app/base/manager"


export default class ExerciseManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *create(query) {
    if (!query.calories_burned){
      if (query.cardio_cal && query.cardio_cal != '') {
        query.calories_burned = query.cardio_cal
      }else if (query.strenght_cal && query.strenght_cal != ''){
        query.calories_burned = query.strenght_cal
      }
    }
    if (!query.time){
      if (query.cardio_minutes && query.cardio_minutes != '') {
        query.time = query.cardio_minutes
      }else if (query.strenght_minutes && query.strenght_minutes != ''){
        query.time = query.strenght_minutes
      }
    }
    return yield super.create(query)
  }
}

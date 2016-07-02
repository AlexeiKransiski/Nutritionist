import Model from "./model"
import BaseManager from "app/base/manager"

export default class ExerciseListTodayManager extends BaseManager{ 

  constructor(options){
    this.model = new Model()
  }

  *createTodayList(query){
  	console.log("Entro")
	try{
		yield super.createTodayList({user:query.user}, query, {upsert:true});
	}catch(err){
		console.log(err)
	}
  }

}

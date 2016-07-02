var _ = require('underscore')
// TODO: check pagination optimisation here:
// http://stackoverflow.com/questions/5539955/how-to-paginate-with-mongoose-in-node-js/23640287#23640287

var errors = {
  "MongoError": {
    "11000": {
      "title": "Duplicated",
      "message": "Object already exist.",
      "status": 409
    }
  }
}

export default class ErrorManager extends Error{
  constructor(error){
    this.error = error
    this.proccess()
  }

  proccess(){
    if (errors[this.error.name] && errors[this.error.name][this.error.code] ){
      _.extend(this, errors[this.error.name][this.error.code])
    }
  }

}

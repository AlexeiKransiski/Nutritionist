import querystring from 'querystring'

export default class BaseController{
  constructor(modelManager) {
    this.modelManager = modelManager
  }

  *findAll(request) {
    var error, result;
    var limit = parseInt(request.request.query.limit);
    var offset = parseInt(request.request.query.offset);
    try {
      if (request.request.query.offset) delete request.request.query.offset
      if (request.request.query.limit) delete request.request.query.limit
      
      result = {
        data: yield this.modelManager.findAll(request.request.query, limit, offset),
        nextHref: request.request.protocol + '://' + request.request.host + request.request.path + '?' + querystring.stringify({offset: offset+limit, limit: limit}) + '&' + querystring.stringify(request.request.query)
      }

      return request.body = result;
    } catch (_error) {
      error = _error;
      return request.body = error;
    }
  }

  *findOne(request) {
    var error, result;
    try {
      result = yield this.modelManager.findOne(request.params);
      return request.body = result;
    } catch (_error) {
      console.log("Err: ", _error)
      error = _error;
      return request.body = error;
    }
  }

  *findById(request) {
    var error, result;
    try {
      result = yield this.modelManager.findById(request.params.id);
      return request.body = result;
    } catch (_error) {
      console.log("Err: ", _error)
      error = _error;
      return request.body = error;
    }
  }

  *deleteById(request) {
    var error, result;
    try {
      result = yield this.modelManager.deleteById(request.params.id)
      return request.body = result;
    } catch (_error) {
      error = _error;
      return request.body = error;
    }
  }

  *replaceById(request) {
    var body, error, newDocument, result;
    try {
      result = yield this.modelManager.findByIdAndRemove(id);
      return request.body = result;
    } catch (_error) {
      error = _error;
      return request.body = error;
    }
  }

  *updateById(request) {
    var body, error, result;

    try {
      result = yield this.modelManager.updateById(request.params.id, request.request.body);
      request.body = result;
    } catch (_error) {
      console.log("Error update: ", _error)
      error = _error;
      if(error.name == "ValidationError"){
        request.status = 400
      }else{
        request.status = 400
      }
      request.body = error;
    }
  }

  *create(request) {
    console.log("API create")
    var error, result
    try {
      result = yield this.modelManager.create(request.request.body);
      request.status = 201;
      return request.body = result;
    } catch (_error) {
      console.log("ERR:", JSON.stringify(_error))
      error = _error;
      if (error.status) request.status = error.status;
      if (error.statusCode) request.status = error.statusCode;
      return request.body = error;
    }
  }

  *findOneAndUpdate(request) {
    console.log("API findOneAndUpdate")
    var error, result
    try {
      result = yield this.modelManager.createTodayList(request.request.body);
      request.status = 201;
      return request.body = result;
    } catch (_error) {
      console.log("ERR:", _error)
      error = _error;
      return request.body = error;
    }
  }

  // without generator
  saveFile(request) {
    var that = this;
    this.modelManager.model[`${request.params.field}FileChanged`].callback = function (doc) {
      doc.saveAsync();
    };

    this.modelManager.saveFile(request.params.id, request.params.field, request.request.body);
  }
}

import assert from "assert"
import Errors from "./errors"
var _ = require('underscore')
// TODO: check pagination optimisation here:
// http://stackoverflow.com/questions/5539955/how-to-paginate-with-mongoose-in-node-js/23640287#23640287

export default class BaseManager{
    *populateResource(resource) {
      var i, fields
      fields = _.keys(this.populate)

      for(i=0;i < fields.length - 1; i++ ){
        yield resource.populateAsync(fields[i], this.populate[fields[i]])
      }

      return yield resource.populateAsync(fields[i], this.populate[fields[i]])
    }

    *populateQueryset(queryset) {
      var i, fields
      fields = _.keys(this.populate)

      for(i=0;i < fields.length; i++ ){
        queryset.populate(fields[i], this.populate[fields[i]])
      }

      return yield queryset.execAsync()
    }

    *findAll(query, limit, offset) {
      var queryset, options;
      this.clean_query(query)
      options = {
        skip:parseInt(offset),
        limit:parseInt(limit)
      }
      if (this.sort){
        options.sort = this.sort
      }
      console.log('filter:', options)
      if (this.populate){
        queryset = this.model._model.find(query, {}, options)
        return yield this.populateQueryset(queryset)
      }else{
        return yield this.model._model.findAsync(query, {}, options)
      }
    }

    *findOne(query) {
      var resource
      if (this.populate){
        resource = yield this.model._model.findOneAsync(query)
        return yield this.populateResource(resource)
      }else{
        return yield this.model._model.findOneAsync(query)
      }
    }

    *findById(id) {
      var resource
      if (this.populate){
        resource = yield this.model._model.findByIdAsync(id)
        return yield this.populateResource(resource)
      }else{
        return yield this.model._model.findByIdAsync(id)
      }

    }

    *deleteById(id) {
      return  yield this.model._model.findByIdAndRemoveAsync(id)
    }

    *replaceById(id, newDocument) {
      yield this.model._model.findByIdAndRemoveAsync(id)
      newDocument._id = id
      return yield this.model._model.createAsync(newDocument)
    }

    *saveFiles(doc, query) {
      var fields, resource;

      try{
        fields = _.keys(query)
        if (_.has(query, 'files')){
          let files = _.keys(query.files)
          for(let j =0;j < files.length;j++){
            console.log('files:', files[j])
            try{
              yield doc.attachAsync(files[j], query.files[files[j]])
            }catch(e){
              console.log(e)
            }
          }
          resource = yield doc.saveAsync()
          doc = resource[0]
        }

        return doc
      }catch(_error){
        console.log('error')
        throw(_error)
      }
    }

    *create(query) {
      var resource;

      try{
        resource = yield this.model._model.create(query)
      }catch(e) {
        throw new Errors(e)
      }
      resource = yield this.saveFiles(resource, query)
      if (this.populate){
        return yield this.populateResource(resource)
      }else{
        return resource
      }
    }

    *updateById(id, updates) {
      var doc, fields, saved_doc, resource
      try{
        doc = yield this.model._model.findByIdAsync(id)
        fields = _.keys(updates)
        for(let i=0; i < fields.length; i++) {
          if(fields[i] != 'files'){
            if (fields[i] == '_id'){
              continue
            }else{
              doc[fields[i]] = updates[fields[i]]
            }
          }else{
            doc = yield this.saveFiles(doc, updates)
          }
        }
        saved_doc = yield doc.saveAsync()
        if (this.populate){
          resource = yield doc.saveAsync()
          return yield this.populateResource(resource[0])
        }else{
          return saved_doc[0]
        }
      }catch(_error){
        throw(_error)
      }

    }

    *createTodayList(query,newData,upsert){
      var resp = yield this.model._model.removeAsync(query);
      return yield this.model._model.create(newData);
    }

    // non generator
    saveFile(id, field, updates) {
      this.model._model.findByIdAsync(id).then(function(doc){
        doc.set(`${field}.file`, updates.files[field]);
      }).error(function(){
        console.log(arguments);
      });
    }

  clean_query(query){
    if(query.limit){
      this.limit = query.limit
      delete query.limit
    }
    if(query.offset){
      this.offset = query.offset
      delete query.offset
    }
    if(query.sort_by){
      var sort, tmp;
      this.sort = {}
      if (query.sort_by[0] == "-"){
        this.sort[query.sort_by.substring(1, query.sort_by.length)] = -1
      }else{
        this.sort[query.sort_by] = 1
      }
      delete query.sort_by
    }
    return
  }
}

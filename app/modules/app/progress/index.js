import Model from "./model"
import BaseManager from "app/base/manager"
import IM from "imagemagick"
import Promise from "bluebird"
import Metrics from 'app/metrics'

Promise.promisifyAll(IM)

var _ = require('underscore');
var moment = require('moment');

export default class ProgressManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *findAll(query, limit, offset) {
    this.clean_query(query)
    return yield this.model._model.findAsync(query, {}, {skip:parseInt(offset), limit:parseInt(limit), sort: {date: -1}})
  }

  *create(query) {
    var doc;
    var metric, log;

  	doc = yield super.create(query);
    if (query.files){
      try{
        // TODO: replace mongoose-attachment with mongoose-crate: https://github.com/achingbrain/mongoose-crate
        yield this.imConvert(doc, query)
        yield doc.attachAsync('photo', {
          path: doc.photo.original.path
        })
      }catch(e){
        throw e
      }
    }
    metric = new Metrics()
    log = yield metric.create(doc)
    return doc
  }

  *updateById(id, updates) {
    var doc, crop, metric, log;
    if (_.has(updates, 'photo')){
      delete updates.photo
    }

    // Update metrics need to delete the previus values
    // add new entre to metric with the new ones
    doc = yield super.findById(id)
    metric = new Metrics()
    log = yield metric.delete(doc)

    doc = yield super.updateById(id, updates)
    log = yield metric.create(doc)
    
    if (updates.files){
      try{
        // TODO: replace mongoose-attachment with mongoose-crate: https://github.com/achingbrain/mongoose-crate
        yield this.imConvert(doc, updates)
        yield doc.attachAsync('photo', {
          path: doc.photo.original.path
        })
        return doc
      }catch(e){
        throw e
      }
    }else{
      return doc
    }
  }

  *imConvert(doc, data) {
    // TODO: replace mongoose-attachment with mongoose-crate: https://github.com/achingbrain/mongoose-crate
    yield IM.convertAsync([
      doc.photo.original.path,
      '-gravity',
      'NorthWest',
      '-crop',
      `${data.photo_w}x${data.photo_h}+${data.photo_x}+${data.photo_y}`,
      '-resize',
      `${data.photo_sw}x${data.photo_sh}!`,
      doc.photo.original.path
    ])
  }

  *deleteById(id) {
    var del_log = yield super.deleteById(id)
    var metric = new Metrics()

    var log = yield metric.delete(del_log)
    return del_log
  }
}

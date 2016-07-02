import Model from "./model"
import BaseManager from "app/base/manager"

var _ = require('underscore')

export default class FoodManager extends BaseManager{

  constructor(options){
    this.model = new Model()
  }

  *findAll(query, limit, offset) {
    var q, exp

    if (_.has(query, 'name')) {
      
      q = query.name.split(' ');
      exp = [];
      for (var i in q) {
        let s_word = q[i].replace(/,/g, '')
        q[i] = s_word
        exp.push({description: new RegExp(`^${s_word}s*[\\W]|[\\W]${s_word}s*[\\W]|[\\W]${s_word}s*$`, 'i')})
      }
      query['$and'] = exp
      delete query.name

      var result = yield this.model._model.findAsync(query, {}, {skip: 0, limit: 999999})
      console.log(result)
      for (var i in result) {
        result[i].sort_weight = 0
        for (var j in q) {
          let regex = new RegExp(`^${q[j]}s*[\\W]|[\\W]${q[j]}s*[\\W]|[\\W]${q[j]}s*$`, 'i')
          let match = regex.exec(result[i].description);
          result[i].sort_weight += match.index
        }
      }
      result = result.sort(function(a, b) {
          var x = a.sort_weight; var y = b.sort_weight;
          return ((x < y) ? -1 : ((x > y) ? 1 : 0));
      })

      return result.slice(offset, offset + limit);
    } else {
      return yield super.findAll(query, limit, offset)
    }
  }

}

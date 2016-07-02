import colors from "colors"
var _ = require('underscore')

var makeRoutes = function(options) {
  let default_options = {
    app: null,
    modelName: null,
    controller: null,
    prefix: '',
    allow_methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    secure_methods: {}
  }
  _.extend(default_options, options)
  console.log(`[Koapi]`.blue+` resource ready`.green + ` ${default_options.prefix}/${default_options.modelName}`.yellow);

  var secure_middleware = function *(next) {
    if (this.isAuthenticated()) {
      yield next
    } else {
      this.body = {
        error: {
          code: '401',
          message: 'Forbiden'
        }
      }
      this.status = 401
    }
  }

  var async_secure_middleware = function (next) {
    if (this.isAuthenticated()) {
      if (next)
        next();
    } else {
      this.body = {
        error: {
          code: '401',
          message: 'Forbiden'
        }
      }
      this.status = 401
    }
  }

  if (default_options.hasFiles) {
    // put method
    if(default_options.secure_methods['PUT']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['PUT'] == 'default' ? secure_middleware : default_options.secure_methods['PUT'])

      default_options.app.put(default_options.prefix + ("/" + default_options.modelName + "/:id/:field"), authentication, function *() {
        default_options.controller.saveFile(this)
        this.status = 200;
      });
    }else{
      default_options.app.put(default_options.prefix + ("/" + default_options.modelName + "/:id/:field"), function *() {
        default_options.controller.saveFile(this)
        this.status = 200;
      });
    }

    // post methods
    if(default_options.secure_methods['POST']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['POST'] == 'default' ? secure_middleware : default_options.secure_methods['POST'])

      default_options.app.post(default_options.prefix + ("/" + default_options.modelName + "/:id/:field"), authentication, function *() {
        default_options.controller.saveFile(this)
        this.status = 200;
      });
    }else{
      default_options.app.post(default_options.prefix + ("/" + default_options.modelName + "/:id/:field"), function *() {
        default_options.controller.saveFile(this)
        this.status = 200;
      });
    }
  }

  //let secure_methods = _.intersection(default_options.allow_methods, default_options.secure_methods)

  // collection route
  if (_.indexOf(default_options.allow_methods, 'GET') >= 0){
    if(default_options.secure_methods['GET']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['GET'] == 'default' ? secure_middleware : default_options.secure_methods['GET'])
      default_options.app.get(default_options.prefix + ("/" + default_options.modelName), authentication, function* () {
        return yield default_options.controller.findAll(this)
      });
    }else{
      default_options.app.get(default_options.prefix + ("/" + default_options.modelName), function* () {
        return yield default_options.controller.findAll(this)
      });
    }
  }

  // detail route
  if (_.indexOf(default_options.allow_methods, 'GET') >= 0){
    if(default_options.secure_methods['GET']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['GET'] == 'default' ? secure_middleware : default_options.secure_methods['GET'])

      default_options.app.get(default_options.prefix + ("/" + default_options.modelName + "/:id"), authentication, function* () {
        return yield default_options.controller.findById(this)
      });
    }else{
      default_options.app.get(default_options.prefix + ("/" + default_options.modelName + "/:id"), function* () {
        return yield default_options.controller.findById(this)
      });
    }
  }

  // create route
  if (_.indexOf(default_options.allow_methods, 'POST') >= 0){
    if(default_options.secure_methods['POST']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['POST'] == 'default' ? secure_middleware : default_options.secure_methods['POST'])

      default_options.app.post(default_options.prefix + ("/" + default_options.modelName), authentication,function* () {
        return yield default_options.controller.create(this)
      });
    }else{
      default_options.app.post(default_options.prefix + ("/" + default_options.modelName), function* () {
        return yield default_options.controller.create(this)
      });
    }
  }

  // update with post route
  if (_.indexOf(default_options.allow_methods, 'POST') >= 0){
    if(default_options.secure_methods['POST']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['POST'] == 'default' ? secure_middleware : default_options.secure_methods['POST'])

      default_options.app.post(default_options.prefix + ("/" + default_options.modelName + "/:id"), authentication, function* () {
        return yield default_options.controller.updateById(this)
      });
    }else{
      default_options.app.post(default_options.prefix + ("/" + default_options.modelName + "/:id"), function* () {
        return yield default_options.controller.updateById(this)
      });
    }
  }

  // update  route
  if (_.indexOf(default_options.allow_methods, 'PUT') >= 0){
    if(default_options.secure_methods['PUT']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['PUT'] == 'default' ? secure_middleware : default_options.secure_methods['PUT'])

      default_options.app.put(default_options.prefix + ("/" + default_options.modelName + "/:id"), authentication, function* () {
        return yield default_options.controller.updateById(this)
      });
    }else{
      default_options.app.put(default_options.prefix + ("/" + default_options.modelName + "/:id"), function* () {
        return yield default_options.controller.updateById(this)
      });
    }
  }

  // patch route
  if (_.indexOf(default_options.allow_methods, 'PATCH') >= 0){
    if(default_options.secure_methods['PATCH']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['PATCH'] == 'default' ? secure_middleware : default_options.secure_methods['PATCH'])

      default_options.app.patch(default_options.prefix + ("/" + default_options.modelName + "/:id"), authentication, function* () {
        return yield default_options.controller.updateById(this)
      });
    }else{
      default_options.app.patch(default_options.prefix + ("/" + default_options.modelName + "/:id"), function* () {
        return yield default_options.controller.updateById(this)
      });
    }
  }

  // delete route
  if (_.indexOf(default_options.allow_methods, 'DELETE') >= 0){
    if(default_options.secure_methods['DELETE']){
      // secure the method with authentication middleware
      let authentication = (default_options.secure_methods['DELETE'] == 'default' ? secure_middleware : default_options.secure_methods['DELETE'])

      default_options.app.del(default_options.prefix + ("/" + default_options.modelName + "/:id"), authentication, function* () {
        return yield default_options.controller.deleteById(this)
      });
    }else{
      default_options.app.del(default_options.prefix + ("/" + default_options.modelName + "/:id"), function* () {
        return yield default_options.controller.deleteById(this)
      });
    }
  }

};

module.exports = makeRoutes;

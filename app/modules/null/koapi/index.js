var makeRoutes = require('./routes');
import makeController from './controller'
var _ = require('underscore')
var koapi = {}

koapi.makeResource = function(options) {
  /*
  options:
    app: koa app
    manager: resouce manager class
    controller: if null then defaul controller
                could be a class that exten the BaseController
    prefix: Url prefix path
    allow_methods: array with the name of the methods to implement
    secure_methods: object containing the list of methods that need
                    authentication with the authentication estrategy.
                    value: 'default' will use the Local estrategy
                    ej: auth is the passport intances already configured

                    secure_methods: {
                      'GET': 'default',
                      'PUT': auth.authenticate('bearer', {session: false}),
                      'DELETE': auth.authenticate('bearer', {session: false}),
                      'PATCH': auth.authenticate('bearer', {session: false})
                    },
  */

  var controller
  let default_options = {
    app: null,
    manager: null,
    controller: null,
    prefix: '',
    allow_methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    secure_methods: null,
    hasFiles: false
  }
  _.extend(default_options, options)

  if (default_options.controller == null){
    controller = new makeController(default_options.manager)
  }else{
    controller = new default_options.controller(default_options.manager)
  }

  let route_options = {
    app: default_options.app,
    modelName: default_options.manager.name || default_options.manager.model._name,
    controller: controller,
    prefix: default_options.prefix,
    allow_methods: default_options.allow_methods,
    secure_methods: default_options.secure_methods,
    hasFiles: default_options.hasFiles
  }
  makeRoutes(route_options)
};


module.exports = koapi

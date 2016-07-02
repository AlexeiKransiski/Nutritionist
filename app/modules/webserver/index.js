import colors from "colors"
import path from "path"


var _ = require('koa-route');
var koa = require('koa');
var flash = require('koa-connect-flash');
var port = process.env.PORT || 3000;
var host = process.env.HOST || 'http://localhost';

var fmt = require('util').format;

var app = koa();
require('koa-qs')(app)

app.keys = ['dY21cCR3RlacUbjXd0CAm0hDuXhZYE9zDHwXOkfHUQzAeXOCM1gSIRlsRCEqDbCY2bLR3oL5ElWTmOfS'];

// Session setup
// TODO: check koa-generic-session and koa-redis
var csrf = require('koa-csrf');
var session = require('koa-session');
app.use(session(app));
//csrf(app);
//app.use(csrf.middleware);
app.use(flash()); // use connect-flash for flash messages stored in session
// body parser
var bodyParser = require('koa-better-body');
app.use(bodyParser({
  // fieldsKey: false,
  // filesKey: false,
  multipart: true,
  //formLimit: 15,
  formidable: {
    uploadDir: path.join(__dirname, "/public/uploads")
  }
}));

// this code hacks koa-better-body to use passport, using fieldsKey: false... breaks for delete request
app.use(function * (next){
  // this.request.body should have this
  // body:
  //  fields: parsed data
  //  files: files
  //  extra data from fields copied to body as root
  if (this.request.body)
    for (var prop in this.request.body.fields) {
      if (this.request.body.fields.hasOwnProperty(prop) && ['fields', 'files'].indexOf(prop) == -1) {
        this.request.body[prop] = this.request.body.fields[prop];
      }
    }
  yield next;
});


// pagination
/*import paginate from 'koa-paginate'

app.use(paginate.middleware({
    // in case the limit is null
    defaultLimit: 20,
    // throws an error when exceeded
    maxLimit: 200
}));
*/

//Middleware: request logger
function *reqlogger(next){
  console.log('%s - %s %s',new Date().toISOString(), this.req.method, this.req.url);
  yield next;
}
app.use(reqlogger);



//auth
// import authManager from './auth'
// authManager.start(app)
require('./auth/index')
var passport = require('koa-passport')
app.use(passport.initialize())
app.use(passport.session())

//subscription middelware
var subscription_refill = require('./middlewares/subscriptions_refill')
app.use(subscription_refill)

// router
var router = require('koa-router');
app.use(router(app));

// static pages
import staticPages from './static_pages'
staticPages.start(app);
//app.use(staticPages);


// api
import api from './api'
api.start(app, passport)


function start() {
  console.log(`[null webserver 2.0]`.rainbow + ` started on`.green+` ${host}:${port}`.yellow)
  app.listen(port);

}

exports.app = app;
exports.start = start;

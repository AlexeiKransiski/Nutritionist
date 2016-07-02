import conf from "config"
import colors from "colors"
import render from "koa-swig"
import path from "path"
import passport from '../auth'

class StaticPagesManager{
  start(app){
    render(app, {
      root: path.join(__dirname, '../views'),
      autoescape: true,
      cache: (conf.get('debug')? false : 'memory'), // disable, set to false
      ext: 'html'
    });

    let root = path.join(__dirname, "../public")
    let opts = {
      hidden: false // don't trust default thist MUST be false anytime!
    }
    app.use(require('koa-static')(root, opts))

    app.get("/", function *(){
      let debug = false
      let template
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }

      var landing = false;
      var nutritionist = false;

      if(this.isAuthenticated()){
        if (this.req.user.is_nutritionist) {
          template = 'nutritionist'
          nutritionist = true
        } else if (this.req.user.profileFilled) {
          template = 'index'
        } else {
          template = 'landing'
        }
        landing = false;

      }else{
        template = 'landing'
        landing = true;
      }

      let context = {
        rootBase: '/',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug,
        user: this.req.user,
        stripe_public_key: conf.get('stripe.public_key'),
        landing: landing,
        nutritionist: nutritionist,
        // plans: conf.get('stripe.plans')
        plans: {
          trial: {
            id: conf.get('stripe.plans.trial.id'),
            amount: conf.get('stripe.plans.trial.amount'),
            name: conf.get('stripe.plans.trial.name')
          },
          monthly: {
            id: conf.get('stripe.plans.monthly.id'),
            amount: conf.get('stripe.plans.monthly.amount'),
            name: conf.get('stripe.plans.monthly.name')
          },
          yearly: {
            id: conf.get('stripe.plans.yearly.id'),
            amount: conf.get('stripe.plans.yearly.amount'),
            name: conf.get('stripe.plans.yearly.name')
          }
        }

      };
      this.body = yield this.render(template, context)

    })

    app.get("/signup", function *(){
      let debug = false
      let template
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }
      var landing = true;
      let context = {
        rootBase: '/',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        appId: conf.get("facebook.client_id"),
        debug: debug,
        landing: landing,
      };

      template = 'signup'

      if(this.isAuthenticated()){
        if (this.req.user.is_nutritionist) {
          template = 'nutritionist'
        } else if (this.req.user.profileFilled) {
          template = 'index'
        }
      }
      
      this.body = yield this.render(template, context)

    })

    app.get("/signupinfo", function *(){
      let debug = false
      let template
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }
      let context = {
        rootBase: '/',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        appId: conf.get("facebook.client_id"),
        debug: debug
      };
      template = 'signupinfo'
      this.body = yield this.render(template, context)

    })

    app.get("/signup-progress", function *(){
      let debug = false
      let template
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }

      var landing = false

      let context = {
        rootBase: '/',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug,
        user: this.req.user,
        stripe_public_key:conf.get('stripe.public_key'),
        appId: conf.get("facebook.client_id"),
        landing: landing,
        plans: {
          trial: {
            id: conf.get('stripe.plans.trial.id'),
            amount: conf.get('stripe.plans.trial.amount'),
            name: conf.get('stripe.plans.trial.name')
          },
          monthly: {
            id: conf.get('stripe.plans.monthly.id'),
            amount: conf.get('stripe.plans.monthly.amount'),
            name: conf.get('stripe.plans.monthly.name')
          },
          yearly: {
            id: conf.get('stripe.plans.yearly.id'),
            amount: conf.get('stripe.plans.yearly.amount'),
            name: conf.get('stripe.plans.yearly.name')
          }
        }
      }

      if(this.isAuthenticated()){
        if (this.req.user.profileFilled) {
          window.location = "/"
        } else {
          template = 'index'
        }
      } else {
        window.location = "/"
      }
      
      this.body = yield this.render(template, context)
    })

    app.get("/login", function *(){
      console.log("Entro para la redireccion")
      let debug = false
      let template
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }
      var landing = true;
      let context = {
        rootBase: '/',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        appId: conf.get("facebook.client_id"),
        debug: debug,
        landing: landing
      };
      template = 'login'
      console.log("Llego aca deberia entrar a ese render y devolver algo")
      this.body = yield this.render(template, context)

    })

    app.get("/logout", function *(){
      this.logout()
      let debug = false
      let template
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }
      var landing = true
      let context = {
        rootBase: '/',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        appId: conf.get("facebook.client_id"),
        debug: debug,
        landing: landing
      };
      template = 'login'
      this.cookies.set('user_id')
      this.cookies.set('auth_token')
      this.body = yield this.render(template, context)

    })

    app.get("/test-api", function *(){
      let debug = false
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }

      let context = {
        rootBase: '/test-api',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug
      };

      this.body = yield this.render('test-api', context)
    })

    app.get("/forgot_password", function *(){
      let debug = false
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }
      var landing = true;
      let context = {
        rootBase: '/forgot_password',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug,
        landing: landing
      };

      this.body = yield this.render('forgot_password', context)
    })

    app.get("/email_sent", function *(){
      let debug = false
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }

      let context = {
        rootBase: '/forgot_password',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug
      };

      this.body = yield this.render('email_sent', context)
    })

    app.get("/email_sent", function *(){
      let debug = false
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }

      let context = {
        rootBase: '/forgot_password',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug
      };

      this.body = yield this.render('email_sent', context)
    })


    app.get("/restore/:id", function *(){
      console.log("this.params.id");
      console.log(this.params.id);

      let debug = false
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }

      let context = {
        rootBase: '/reset_password',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        userId:this.params.id,
        debug: debug
      };

      this.body = yield this.render('reset_password', context)
    })

    app.get("/terms", function *(){
      let debug = false
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }
      var landing = true;
      let context = {
        rootBase: '/terms',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug,
        landing: landing
      };

      this.body = yield this.render('terms', context)
    })

    app.get("/privacy-policy", function *(){
      let debug = false
      if (this.request.query.debug){
        debug = this.request.query.debug
      }else{
        debug = conf.get('debug')
      }
      var landing = true;
      let context = {
        rootBase: '/privacy-policy',
        address: conf.get('app.baseUrl'),
        domain: conf.get('app.domain'),
        debug: debug,
        landing: landing
      };

      this.body = yield this.render('privacy-policy', context)
    })

  }
}

// TODO: Is a singleton needed??
export default new StaticPagesManager()

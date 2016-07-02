import raven from "raven"
import colors from "colors"
import conf from "config"
import assert from "assert"

//let conf = new confman("staging").load("./config/config.yaml")

export default class Logger{
  constructor(options){
    let user = conf.get('sentry.user')
    let password = conf.get('sentry.password')
    let url = conf.get('sentry.url')

    console.log('[Logger]'.blue+' connection success to '.green+`${url}`.yellow)
    this.client = new raven.Client('https://' + `${user}:${password}@${url}`)
  }
}

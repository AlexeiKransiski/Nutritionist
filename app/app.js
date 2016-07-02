/*
 This app is composed of several servers

   - db: Simplified by onw. Is one db connector
   - webserver: HTTP loop for handling API requests and serve static pages if any.
 */

import webserver from 'webserver'
import db from './lib/db'
import Logger from 'app/logger'


class WebApp{
  constructor(){
    this.db = db
    this.webserver = webserver
  }

  run(){
    this.db.connect()
    this.log = new Logger().client
    this.webserver.start()
  }
}

let webapp = new WebApp()
webapp.run()

export default webapp

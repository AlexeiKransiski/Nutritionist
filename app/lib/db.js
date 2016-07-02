import mongoose from 'mongoose'
import colors from "colors"
import conf from "config"

// connect to mongodb database
class DB{
  connect(cb){
    let ip = conf.get("mongo.ip")
    let port = conf.get("mongo.port")
    let database = conf.get("mongo.database")
    let mongouri = conf.get("mongo.uri")
    let connString
    if (mongouri == undefined) {
      connString = `${ip}:${port}/${database}`
    } else {
      connString = mongouri
    }
    console.log("connString: " + connString)
    mongoose.connect(connString)
    var db = mongoose.connection
    db.on('error', (error) => console.log("[Mongo]".blue+" connection error: ".red, error) )
    db.once('open', function () {
      console.log("[Mongo]".blue+" connection success ".green + connString.yellow)
      if (cb != undefined && typeof cb == "function"){
        cb()
      }
    })
  }
}


export default new DB()

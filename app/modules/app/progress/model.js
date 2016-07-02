import BaseModel from "app/base/model"
import Promise from "bluebird"
import path from 'path'

var attachments = Promise.promisifyAll(require('mongoose-attachments-localfs'));
var moment = require('moment')
var mongoose = Promise.promisifyAll(require('mongoose'));
var _ = require('underscore')

var uploads_base = path.join(__dirname, "../../webserver/public/");
var rel_path = "/uploads/u/progress"
var uploads = path.join(uploads_base, rel_path);

let schema = {
  created: { type: Date, default: Date.now },
  modified: { type: Date, default: Date.now },

  chest: { type: Number, default: 0.0 },
  upperArmRight: { type: Number, default: 0.0 },
  hips: { type: Number, default: 0.0 },
  forearmRight: { type: Number, default: 0.0 },
  thighRight: { type: Number, default: 0.0 },
  calfRight: { type: Number, default: 0.0 },
  neck: { type: Number, default: 0.0 },
  upperArmLeft: { type: Number, default: 0.0 },
  waist: { type: Number, default: 0.0 },
  forearmLeft: { type: Number, default: 0.0 },
  thighLeft: { type: Number, default: 0.0 },
  calfLeft: { type: Number, default: 0.0 },

  title: { type: String, default: "" },
  observations: { type: String },

  height: { type: Number, default: 0.0 },
  weight: { type: Number, default: 0.0 },
  bmi: { type: Number },
  date: { type: Date },

  // References
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'users' }
}


export default class Progress extends BaseModel{
  constructor(options){
    var that = this;
    this._name = "progress"; //TODO: Use introspection to not need this
    this._schema = new mongoose.Schema(schema);
    this._schema.index({ user: 1,  date: 1}, {unique: true})
    this._schema.pre('save', this.preSave)
    this._schema.methods.getMetrics = this.getMetrics

    this._schema.set('toObject', {
      getters: true,
      virtuals: true
    })
    this._schema.set('toJSON', {
      virtuals: true
    })

    // TODO: replace mongoose-attachment with mongoose-crate: https://github.com/achingbrain/mongoose-crate
    this._schema.plugin(attachments, {
      directory: uploads,
      storage : {
        providerName: 'localfs'
      },
      properties: {
        photo: {
          styles: {
            original: {
              // keep the original file
            },
            thumb: {
              thumbnail: '100x100^',
              gravity: 'center',
              extent: '100x100',
              '$format': 'jpg'
            }
          }
        }
      }
    });

    this._schema.virtual('photo_src').get(function() {
        return `${path.join(`${rel_path}/original`, path.basename(this.photo.original.path))}?t=${moment(this.modified).unix()}`;
    });
    this._schema.virtual('photo_thumb').get(function() {
        return `${path.join(`${rel_path}/thumb`, path.basename(this.photo.thumb.path))}?t=${moment(this.modified).unix()}`;
    });

    this.photoFileChanged = function() {
      that.photoFileChanged.callback(this);
    };

    this.createModel();
    super(options);
  }

  preSave(next) {
    this.modified = Date.now()
    next()
  }

  postSave(){
    console.log("progress post save example");
  }

  getMetrics() {
    return _.omit(this.toJSON(), ['_id', 'id', '__v', 'modified', 'title', 'created', 'user', 'observations', 'date', 'photo', 'photo_src', 'photo_thumb'])
  }
}

class App.Models.WaterLog extends Null.Models.Base
  urlRoot: '/api/v1/water_log'
  defaults:
    date: moment(),
    glasses: 0

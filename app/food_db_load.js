/*
 This app is composed of several servers

   - db: Simplified by onw. Is one db connector
   - webserver: HTTP loop for handling API requests and serve static pages if any.
 */

import db from './lib/db'
var fs = require('fs');
var parse = require('csv-parse');
var transform = require('stream-transform');
var csv = require("fast-csv");
var async = require("async");
var _ = require("underscore");
//
// var User;
// var Exercise;
import User from 'app/users'
import Food from 'app/food'

function LoadDB () {
  var output = [];
  var parser = parse({delimiter: ','})
  var stream = fs.createReadStream('../food_db/food_db.csv');



  var csvStream = csv()
  .on("data", function (data){
    //console.log(data[1]);
    return Addfood(data)
  })
  .on("end", function(){
    console.log('CSV Completed')
  });

  stream.pipe(csvStream);
}

function Addfood(data) {
  var keys, num_keys;
  var exercises_types = {
    'cardio': 1,
    'strenght': 2
  }


  /* Full array map
      Alpha_Carot_(µg): 35
      Ash_(g): 6
      Beta_Carot_(µg): 36
      Beta_Crypt_(µg): 37
      Calcium_(mg): 10
      Carbohydrt_(g): 7
      Cholestrl_(mg): 47
      Choline_Tot_ (mg): 30
      Copper_mg): 17
      Energ_Kcal: 3
      FA_Mono_(g): 45
      FA_Poly_(g): 46
      FA_Sat_(g): 44
      Fiber_TD_(g): 8
      Folate_DFE_(µg): 29
      Folate_Tot_(µg): 26
      Folic_Acid_(µg): 27
      Food_Folate_(µg): 28
      GmWt_1: 48
      GmWt_2: 50
      GmWt_Desc1: 49
      GmWt_Desc2: 51
      Iron_(mg): 11
      Lipid_Tot_(g): 5
      Lut+Zea_ (µg): 39
      Lycopene_(µg): 38
      Magnesium_(mg): 12
      Manganese_(mg): 18
      NDB_No: 0
      Niacin_(mg): 23
      Panto_Acid_mg): 24
      Phosphorus_(mg): 13
      Potassium_(mg): 14
      Protein_(g): 4
      Refuse_Pct: 52
      Retinol_(µg): 34
      Riboflavin_(mg): 22
      Selenium_(µg): 19
      Shrt_Desc: 1
      Sodium_(mg): 15
      Sugar_Tot_(g): 9
      Thiamin_(mg): 21
      Vit_A_IU: 32
      Vit_A_RAE: 33
      Vit_B6_(mg): 25
      Vit_B12_(µg): 31
      Vit_C_(mg): 20
      Vit_D_IU: 42
      Vit_D_µg: 41
      Vit_E_(mg): 40
      Vit_K_(µg): 43
      Water_(g): 2
      Zinc_(mg): 16
  */

  var map = {
    ndb_no: 0,
    name: 1,
    description: 53
  }

  var num_map = {
    calcium: 10,
    calories: 3,
    fat: 5,
    carbs: 7,
    cholesterol: 47,
    dietary_fiber: 8,
    iron: 11,
    monounsaturated: 45,
    polyunsaturated: 46,
    potassium: 14,
    protein: 4,
    satured: 44,
    sodium: 15,
    sugars: 9,
    vitamin_a: 33,
    vitamin_c: 20,
    trans: 5
  }

  var serving_factor = function(gr) {
    return parseFloat(gr)/100
  }

  var addServings = function () {
    var servings = []
    var factor = 48
    var name = 49
    for (var i = 0; i < 17; i++){
      var serving;
      if (i == 2){
        factor += 2
        name += 2
      }
      if (!isNaN(serving_factor(data[factor]))){
        serving = {
          name: data[name],
          factor: serving_factor(data[factor])
        }
        servings.push(serving)
      }

      factor += 2
      name += 2
    }
    return servings
  }
  var food_data = {
    type: 'generic',
    serving_types: addServings()
  }
  keys = _.keys(map)
  for (var i = 0; i< keys.length; i++){
    food_data[keys[i]] = data[map[keys[i]]]
  }

  num_keys = _.keys(num_map)
  for (var i = 0; i< num_keys.length; i++){
    if (data[num_map[num_keys[i]]] == '' || data[num_map[num_keys[i]]] == undefined){
      food_data[num_keys[i]] = 0
    }else{
      food_data[num_keys[i]] = data[num_map[num_keys[i]]]
    }
  }

  var food = new Food()

  var item =  new food.model._model(food_data)
  item.save(function(err) {
    if (err){
      console.log("ERROR CREATING FOOD: ", item.toJSON())
    }
  })
  return
}


db.connect(LoadDB)

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
//
// var User;
// var Exercise;
import User from 'app/users'
import Exercise from 'app/exercise'

var exercise_data_list = []
var exercise_index = 0

function LoadDB () {
  var output = [];
  var parser = parse({delimiter: ','})
  var stream = fs.createReadStream('../exercises_db/exercises_with_type_cardio_20160311.csv');

  var csvStream = csv()
  .on("data", function (data){
    //console.log(data[1]);
    exercise_data_list.push(data)
  })
  .on("end", function(){
    AddExercise(exercise_data_list[exercise_index])
  });

  stream.pipe(csvStream);
}

function AddExercise(data) {
  var exercises_types = {
    'cardio': 1,
    'strenght': 2
  }

  var exercise_data = {
    met: parseFloat(data[0].replace(',', '.')),
    exercise_type: 1,
    name: data[2],
    description: data[1],
    type: 'generic'
  }

  var exercises = new Exercise()

  var exercise =  new exercises.model._model(exercise_data)
  exercise.save(function(err) {
    if (err){
      console.log("ERROR CREATING EXERCISE: ", exercise.toJSON())
    }
    exercise_index++;
    if (exercise_index < exercise_data_list.length) {
      AddExercise(exercise_data_list[exercise_index])
    } else {
      console.log('CSV Completed')
      process.exit(0)
    }
  })
}


db.connect(LoadDB)

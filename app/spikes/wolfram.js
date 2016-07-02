var wolfram = require('wolfram').createClient("2PGKW5-4GYVAT26PQ")

wolfram.query("calories burned walking 29yr, 34 min", function(err, result) {
  if(err) throw err
  console.log("Result: %j", result)
})

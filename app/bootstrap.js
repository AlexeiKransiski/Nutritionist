var traceur = require('traceur');
traceur.require.makeDefault(function(filename) {
        // Any modules that needs to be loaded with traceur goes here
        if (filename.indexOf('koa') !== -1) {
            return true;
        }

        // don't transpile our dependencies, just our app
        return filename.indexOf('node_modules') === -1;
    },
    // Set traceur options
    {
        annotations: true, // Enable annotations and async-functions feature
        asyncFunctions: true
    });

var app = './app'
console.log("asdasd",process.argv[2])
if(process.argv[2]){
  app = './' + process.argv[2]
}


console.log("Bootstrap.js running: " + app)
require(app);

var nesh = require('nesh');
var colors = require('colors')

var opts = {
  welcome: 'Welcome to Qalorie console! type ' + '.help'.blue + ' to know more',
  prompt: 'qalorie> '
};

// Load user configuration
nesh.config.load();

// Load CoffeeScript
//nesh.loadLanguage('js');

// Start the REPL
nesh.start(opts, function (err) {
    if (err) {
        nesh.log.error(err);
    }
});

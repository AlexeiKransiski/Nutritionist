/*global require*/
'use strict';

require.config({
    shim: {
        lodash: {
            exports: '_'
        },
        backbone: {
            deps: [
                'underscore',
                'jquery'
            ],
            exports: 'Backbone'
        },
        bootstrap: {
            deps: [
                'query'
            ],
            exports: 'query'
        }
    },
    paths: {
        jquery: '../bower_components/jquery/dist/jquery',
        backbone: '../bower_components/backbone/backbone',
        underscore: '../bower_components/underscore/underscore',
        bootstrap: 'vendor/bootstrap',
        'backbone-validation': '../bower_components/backbone-validation/dist/backbone-validation',
        handlebars: '../bower_components/handlebars/handlebars',
        'bootstrap-sass': '../bower_components/bootstrap-sass/assets/javascripts/bootstrap',
        lodash: '../bower_components/lodash/lodash',
        modernizr: '../bower_components/modernizr/modernizr',
        'requirejs-text': '../bower_components/requirejs-text/text',
        requirejs: '../bower_components/requirejs/require',
    }
});

require([
    'backbone'
], function (Backbone) {
    Backbone.history.start({ pushState: true })
    console.log('Hello from Backbone!');
});

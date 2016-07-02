class App.Models.XMPP.Contact extends Backbone.Model

  parse: (data, opt) =>
    data.id = data.bare
    data

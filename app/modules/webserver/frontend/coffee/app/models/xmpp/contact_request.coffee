class App.Models.XMPP.ContactRequest extends Backbone.Model
  parse: (data, opt) =>
    data.id = data.from.bare
    data

class App.Models.XMPP.RosterItem extends Backbone.Model
  parse: (data, opt) =>
    data.id = data.jid.bare
    data

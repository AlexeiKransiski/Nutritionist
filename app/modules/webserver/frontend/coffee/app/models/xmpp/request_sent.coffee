class App.Models.XMPP.RequestSent extends Backbone.Model
  initialize: (opt) =>
    opt.id = opt.bare
    super

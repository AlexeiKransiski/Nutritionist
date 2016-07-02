class App.Models.XMPP.Message extends Null.Models.Base
  urlRoot: '/api/v1/messages'
  parse: (data, opt) =>
    data.from_jid = data.from.bare if data.from?.bare?
    data.to_jid = data.to.bare if data.to?.bare?
    data.from = data.from.bare if data.from?.bare?
    data.to = data.to.bare if data.to?.bare?
    return data

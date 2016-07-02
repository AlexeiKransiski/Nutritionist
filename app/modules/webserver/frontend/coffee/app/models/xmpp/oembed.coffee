class App.Models.XMPP.Oembed extends Null.Models.Base
  urlRoot: '/api/v1/oembed'
  url: () =>
    return "#{@urlRoot}?url=#{@get('link')}"

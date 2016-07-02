class App.XMPP.Client
  constructor: (opt) ->
    @initialize(opt)

  initialize: (opt) =>
    @connected = false
    # @username = opt.username
    # @token = opt.token
    console.log opt

    @xmpp = XMPP.createClient(
      jid: app.me.jid
      password: $.cookies.get("auth_token")
      wsURL: "ws://#{imConfig.host}:#{imConfig.port}/xmpp-websocket"
      #boshURL: boshURL
      transports: ['old-websocket']
    )

    @xmpp.once "session:started", @onSessionStarted

    # manage subscirpts
    @xmpp.on "subscribe", @onSubscribe
    @xmpp.on "subscribed", @onSubscribed
    @xmpp.on "message:sent", @onMessageSent
    @xmpp.on "message:error", @onMessageError
    @xmpp.on "chat", @onChat

    @connect()

  # Methods
  connect: () =>
    return if @connected
    @xmpp.connect()

  sendSubscription: (username) =>
    console.log "Sending subscribe"
    jid = "#{username}@#{imConfig.host}"
    @xmpp.subscribe(jid)


  acceptSubscription: (username, JID, status) =>
    console.log "Accepeting subscirpt"

    jid = "#{username}@#{imConfig.host}"
    @xmpp.acceptSubscription(jid)
    @sendSubscription(username)

    JID.subscription = status
    app.me.addContact JID

  rejectSubscription: (username) =>
    console.log "Rejecting subscirpt"

    jid = "#{username}@#{imConfig.host}"
    @xmpp.denySubscription(jid)

  sendMessage: (username, message) =>
    to = "#{username}@#{imConfig.host}"
    @xmpp.sendMessage({
      to: to
      body: message
    })


  # Events
  onSessionStarted: () =>
    console.log "session started"
    @connected  = true
    @xmpp.enableCarbons (err) =>
      console.log "Server does not support carbons"  if err
      return

    @xmpp.getRoster (err, resp) =>
      console.log "ROSTER: ", resp
      app.me.loadRoster(resp)
      @xmpp.updateCaps()
      @xmpp.sendPresence caps: @xmpp.disco.caps
      return

    return

  onSubscribe: (data) =>
    # call when the user receive a subscibe
    if app.me.checkContactRequestSent(data.from.local)
      @acceptSubscription(data.from.local, data.from, "both")
    else
      app.me.addContactRequest(data)

  onSubscribed: (data) =>
    # when someone accept a subscrition
    @acceptSubscription(data.from.local, data.from, "both")


  onChat: (msg) =>
    msg = msg.toJSON() if msg.toJSON?
    app.me.addMessage(msg)


  onMessageSent: (data) =>
    data.from.bare = app.me.jid
    app.me.addMessage(data)

  onMessageError: (data) =>
    console.log "Message error: ", data

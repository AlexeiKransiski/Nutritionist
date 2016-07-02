class Null.Authorization.Index

  _adapters: {}

  default_policy: no
  constructor: (options) ->
    @initialize(options)

  initialize: (options) =>
    @permissions = new Null.Authorization.Permissions()

  use: (name, adapter) =>
    unless adapter?
      adapter = name
      name = adapter.name

    throw new Error('Authorization adapter must have a name') unless name

    @_adapters[name] = adapter
    return @

  isAuthorized: (permission, subject, resource, options, callback) =>
    # 1. Default: Deny
    # 2. Evaluate applicable policies
    #      Match on: resource and action
    # 3. Does policy exist for resource and action?
    #      If no: Deny
    # 4. Do any rules resolve to Deny?
    #      If yes, Deny
    #      If no, Do any rules resolve to Allow?
    #      If yes, Allow
    #      Else: Deny
    if typeof options == "function" and callback == undefined
      callback = options
      options = {}

    @permissions.find @, permission, (err, res) =>
      return callback(false) unless res
      acl = new Null.Authorization.ACL({subject: subject, resource: resource, options: options})

      acl.validate(@, res, (result) =>
        callback(result)
      )

  loadSubjectPermissions: (subject, options, callback) =>
    if typeof options == "function" and callback == undefined
      callback = options
      options = {}

    subject = new Null.Authorization.Subject({subject: subject, options: options})
    subject.permissions @, (result) =>
      callback(result) if typeof callback == "function"

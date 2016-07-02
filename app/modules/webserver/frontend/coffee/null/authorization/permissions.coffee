permissions = {
  "User:read": [{
    access: "all"
    allow:
      "$or": ["is_admin", "is_owner"]
    deny: "user_deny"
  },
  {
    access: "email username"
    allow:
      "$or": ["is_auth"]
    deny: "is_anonimous"
  },
  {
    access: "-password"
    allow: ["is_user"]
    deny: "is_anonimous"
  }]
}

class Null.Authorization.Permissions

  find: (ensure, perm, cb) =>
    @ensure = ensure
    #policy = permissions[perm]
    policy = @_getFromAdapters(perm)
    return cb( null, policy) if policy?
    return cb(null, false)

  _getFromAdapters: (perm) =>
    for name, adapter of @ensure._adapters
      permission = adapter.findPermission(perm)
      if permission?
        return permission

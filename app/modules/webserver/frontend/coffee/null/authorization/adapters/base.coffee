class Null.Authorization.Adapters.Base
  constructor: (options) ->
    @initialize(options)

  initialize: (options) =>
    @options = options

    @_subjects = {}
    @_resources = {}
    @_permissions = {}
    @_acls = {}

  loadSubjects: (subjects) =>
    # something like this:
    # @_subjects = subjects
    # @
    throw new Error('Adapter#loadSubjects must be overridden by subclass')

  loadResources: (resources) =>
    # something like this:
    # @_resource = resources
    # @
    throw new Error('Adapter#loadResource must be overridden by subclass')

  loadPermissions: (permissions) =>
    # something like this:
    # @_permissions = permissions
    # @
    throw new Error('Adapter#loadPermissions must be overridden by subclass')


  loadACLs: (acls) =>
    # something like this
    # @_acls = acls
    # @
    throw new Error('Adapter#loadACLs must be overridden by subclass')

  findSubject: (name) =>
    # something like this
    # return @_resource[name]
    throw new Error('Adapter#findSubject must be overridden by subclass')

  findResource: (name) =>
    # something like this
    # return @_resource[name]
    throw new Error('Adapter#findResource must be overridden by subclass')


  findPermission: (permission) =>
    # something like this
    # return @_permissions[permission]
    throw new Error('Adapter#findPermission must be overridden by subclass')


  findACL: (acl) =>
    # something like this
    # return @_acls[acl]
    throw new Error('Adapter#findACL must be overridden by subclass')

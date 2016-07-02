subjects =
  "internal":
    acls: ["is_admin"]
    permissions: [".*:.*"]

  "user":
    acls: ["is_user"]
    permissions: ['.*:.*']

  "nutricionist":
    acls:
      '$or': ["is_nutricionist"]
    permissions: ['.*:.*']

resources = ["User"]

permissions = {
  # User acls
  "User:read": [
    {
      access: "all"
      allow:
        "$or": ["is_user"]
    }
  ]
  "User:create": [
    {
      access: "all"
      allow: "is_admin"
      deny: "user_deny"
    },
  ]

  "User:update": [
    {
      access: "all"
      allow:
        "$or": ["is_admin", "is_me"]
    }
  ]

  "User:delete": [
    {
      access: "all"
      allow: ["is_admin", "is_me"]
    }
  ]

  # Appointments acls
  "Appointment:read": [
    {
      access: "all"
      allow:
        "$or": ["is_user"]
    }
  ]
  "Appointment:create": [
    {
      access: "all"
      allow: "is_user"
    },
  ]

  "Appointment:update": [
    {
      access: "all"
      allow:
        "$or": ["is_admin", "is_user"]
    }
  ]

  "Appointment:delete": [
    {
      access: "all"
      allow: ["is_admin", "is_user"]
    }
  ]

  # Food acls
  "Food:read": [
    {
      access: "all"
      allow:
        "$or": ["is_user"]
    }
  ]
  "Food:create": [
    {
      access: "all"
      allow: "is_user"
    },
  ]

  "Food:update": [
    {
      access: "all"
      allow:
        "$or": ["is_admin", "is_user"]
    }
  ]

  "Food:delete": [
    {
      access: "all"
      allow: ["is_admin", "is_user"]
    }
  ]


  # Exercises acls
  "Exercise:read": [
    {
      access: "all"
      allow:
        "$or": ["is_user"]
    }
  ]
  "Exercise:create": [
    {
      access: "all"
      allow: "is_user"
    },
  ]

  "Exercise:update": [
    {
      access: "all"
      allow:
        "$or": ["is_admin", "is_user"]
    }
  ]

  "Exercise:delete": [
    {
      access: "all"
      allow: ["is_admin", "is_user"]
    }
  ]
}

acls =
  "is_admin": "subject.is_admin == true"
  "is_user": "subject.is_active == true"
  "is_nutricionist": "subject.is_nutricionist == true && subject.is_active == true"
  "is_me": "subject._id == resource._id"


window.authorization_object = {
  subjects: subjects
  resources: resources
  permissions: permissions
  acls: acls
}

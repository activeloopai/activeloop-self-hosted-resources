#!/usr/bin/env bash

CONFIG_DIR="$HOME/.local/deeplake"
COMPOSE_BASE_URL="https://raw.githubusercontent.com/activeloopai/activeloop-self-hosted-resources/refs/heads/main/docker-compose/deeplake-platform/compose"
SUPPORTED_STORAGE_TYPES=(alarik garage aws azure external-s3)
OPENFGA_MODEL='{
  "schema_version": "1.1",
  "type_definitions": [
    {
      "type": "user",
      "relations": {},
      "metadata": null
    },
    {
      "type": "workload_identity",
      "relations": {
        "can_delete": {
          "tupleToUserset": {
            "tupleset": {
              "object": "",
              "relation": "parent"
            },
            "computedUserset": {
              "object": "",
              "relation": "admin"
            }
          }
        },
        "can_update": {
          "tupleToUserset": {
            "tupleset": {
              "object": "",
              "relation": "parent"
            },
            "computedUserset": {
              "object": "",
              "relation": "admin"
            }
          }
        },
        "can_view": {
          "union": {
            "child": [
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "viewer"
                  }
                }
              },
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "contributor"
                  }
                }
              }
            ]
          }
        },
        "parent": {
          "this": {}
        }
      },
      "metadata": {
        "relations": {
          "can_delete": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_update": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_view": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "parent": {
            "directly_related_user_types": [
              {
                "type": "organization",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          }
        },
        "module": "",
        "source_info": null
      }
    },
    {
      "type": "managed_credential",
      "relations": {
        "can_delete": {
          "tupleToUserset": {
            "tupleset": {
              "object": "",
              "relation": "parent"
            },
            "computedUserset": {
              "object": "",
              "relation": "admin"
            }
          }
        },
        "can_update": {
          "tupleToUserset": {
            "tupleset": {
              "object": "",
              "relation": "parent"
            },
            "computedUserset": {
              "object": "",
              "relation": "admin"
            }
          }
        },
        "can_view": {
          "union": {
            "child": [
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "viewer"
                  }
                }
              },
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "contributor"
                  }
                }
              }
            ]
          }
        },
        "parent": {
          "this": {}
        }
      },
      "metadata": {
        "relations": {
          "can_delete": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_update": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_view": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "parent": {
            "directly_related_user_types": [
              {
                "type": "organization",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          }
        },
        "module": "",
        "source_info": null
      }
    },
    {
      "type": "dataset",
      "relations": {
        "admin": {
          "union": {
            "child": [
              {
                "this": {}
              },
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "admin"
                  }
                }
              }
            ]
          }
        },
        "can_delete": {
          "computedUserset": {
            "object": "",
            "relation": "writer"
          }
        },
        "can_modify_readme": {
          "computedUserset": {
            "object": "",
            "relation": "writer"
          }
        },
        "can_save_query": {
          "computedUserset": {
            "object": "",
            "relation": "writer"
          }
        },
        "can_update": {
          "computedUserset": {
            "object": "",
            "relation": "writer"
          }
        },
        "can_update_user_access": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_view": {
          "computedUserset": {
            "object": "",
            "relation": "viewer"
          }
        },
        "parent": {
          "this": {}
        },
        "viewer": {
          "union": {
            "child": [
              {
                "this": {}
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "writer"
                }
              },
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "viewer"
                  }
                }
              }
            ]
          }
        },
        "writer": {
          "union": {
            "child": [
              {
                "this": {}
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "admin"
                }
              },
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "writer"
                  }
                }
              }
            ]
          }
        }
      },
      "metadata": {
        "relations": {
          "admin": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "can_delete": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_modify_readme": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_save_query": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_update": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_update_user_access": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_view": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "parent": {
            "directly_related_user_types": [
              {
                "type": "organization",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "viewer": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              },
              {
                "type": "user",
                "wildcard": {},
                "condition": ""
              },
              {
                "type": "workload_identity",
                "condition": ""
              },
              {
                "type": "workload_identity",
                "wildcard": {},
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "writer": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              },
              {
                "type": "workload_identity",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          }
        },
        "module": "",
        "source_info": null
      }
    },
    {
      "type": "organization",
      "relations": {
        "admin": {
          "this": {}
        },
        "can_access_ai_knowledge_agent": {
          "computedUserset": {
            "object": "",
            "relation": "can_create_datasets"
          }
        },
        "can_access_assets": {
          "union": {
            "child": [
              {
                "computedUserset": {
                  "object": "",
                  "relation": "admin"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "writer"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "viewer"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "contributor"
                }
              }
            ]
          }
        },
        "can_access_members": {
          "union": {
            "child": [
              {
                "computedUserset": {
                  "object": "",
                  "relation": "admin"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "writer"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "viewer"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "contributor"
                }
              }
            ]
          }
        },
        "can_create_datasets": {
          "union": {
            "child": [
              {
                "computedUserset": {
                  "object": "",
                  "relation": "contributor"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "writer"
                }
              }
            ]
          }
        },
        "can_create_managed_credentials": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_create_workload_identities": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_create_workspace": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_delete": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_delete_workspace": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_invite_admin_users": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_invite_non_admin_users": {
          "computedUserset": {
            "object": "",
            "relation": "writer"
          }
        },
        "can_make_admin": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_modify_assets": {
          "union": {
            "child": [
              {
                "computedUserset": {
                  "object": "",
                  "relation": "admin"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "writer"
                }
              }
            ]
          }
        },
        "can_modify_billing": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_modify_members": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_modify_storage": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_remove_admin": {
          "this": {}
        },
        "can_update": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_update_organization": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_update_user_access": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_update_workspace": {
          "computedUserset": {
            "object": "",
            "relation": "admin"
          }
        },
        "can_view": {
          "union": {
            "child": [
              {
                "computedUserset": {
                  "object": "",
                  "relation": "viewer"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "contributor"
                }
              }
            ]
          }
        },
        "can_view_users": {
          "union": {
            "child": [
              {
                "computedUserset": {
                  "object": "",
                  "relation": "viewer"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "contributor"
                }
              }
            ]
          }
        },
        "contributor": {
          "this": {}
        },
        "member": {
          "union": {
            "child": [
              {
                "computedUserset": {
                  "object": "",
                  "relation": "viewer"
                }
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "contributor"
                }
              }
            ]
          }
        },
        "viewer": {
          "union": {
            "child": [
              {
                "this": {}
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "writer"
                }
              }
            ]
          }
        },
        "writer": {
          "union": {
            "child": [
              {
                "this": {}
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "admin"
                }
              }
            ]
          }
        }
      },
      "metadata": {
        "relations": {
          "admin": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "can_access_ai_knowledge_agent": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_access_assets": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_access_members": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_create_datasets": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_create_managed_credentials": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_create_workload_identities": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_create_workspace": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_delete": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_delete_workspace": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_invite_admin_users": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_invite_non_admin_users": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_make_admin": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_modify_assets": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_modify_billing": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_modify_members": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_modify_storage": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_remove_admin": {
            "directly_related_user_types": [
              {
                "type": "organization",
                "relation": "admin",
                "condition": "at_least_two_admins"
              }
            ],
            "module": "",
            "source_info": null
          },
          "can_update": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_update_organization": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_update_user_access": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_update_workspace": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_view": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "can_view_users": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "contributor": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              },
              {
                "type": "workload_identity",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "member": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "viewer": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              },
              {
                "type": "workload_identity",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "writer": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              },
              {
                "type": "workload_identity",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          }
        },
        "module": "",
        "source_info": null
      }
    },
    {
      "type": "workspace",
      "relations": {
        "admin": {
          "union": {
            "child": [
              {
                "this": {}
              },
              {
                "tupleToUserset": {
                  "tupleset": {
                    "object": "",
                    "relation": "parent"
                  },
                  "computedUserset": {
                    "object": "",
                    "relation": "admin"
                  }
                }
              }
            ]
          }
        },
        "blocked": {
          "this": {}
        },
        "parent": {
          "this": {}
        },
        "viewer": {
          "difference": {
            "base": {
              "union": {
                "child": [
                  {
                    "this": {}
                  },
                  {
                    "tupleToUserset": {
                      "tupleset": {
                        "object": "",
                        "relation": "parent"
                      },
                      "computedUserset": {
                        "object": "",
                        "relation": "viewer"
                      }
                    }
                  },
                  {
                    "computedUserset": {
                      "object": "",
                      "relation": "writer"
                    }
                  }
                ]
              }
            },
            "subtract": {
              "computedUserset": {
                "object": "",
                "relation": "blocked"
              }
            }
          }
        },
        "writer": {
          "difference": {
            "base": {
              "union": {
                "child": [
                  {
                    "this": {}
                  },
                  {
                    "tupleToUserset": {
                      "tupleset": {
                        "object": "",
                        "relation": "parent"
                      },
                      "computedUserset": {
                        "object": "",
                        "relation": "writer"
                      }
                    }
                  },
                  {
                    "computedUserset": {
                      "object": "",
                      "relation": "admin"
                    }
                  }
                ]
              }
            },
            "subtract": {
              "computedUserset": {
                "object": "",
                "relation": "blocked"
              }
            }
          }
        }
      },
      "metadata": {
        "relations": {
          "admin": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "blocked": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "parent": {
            "directly_related_user_types": [
              {
                "type": "organization",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "viewer": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "writer": {
            "directly_related_user_types": [
              {
                "type": "user",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          }
        },
        "module": "",
        "source_info": null
      }
    },
    {
      "type": "feature",
      "relations": {
        "associated_plan": {
          "this": {}
        },
        "can_access": {
          "tupleToUserset": {
            "tupleset": {
              "object": "",
              "relation": "associated_plan"
            },
            "computedUserset": {
              "object": "",
              "relation": "subscriber"
            }
          }
        }
      },
      "metadata": {
        "relations": {
          "associated_plan": {
            "directly_related_user_types": [
              {
                "type": "plan",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "can_access": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          }
        },
        "module": "",
        "source_info": null
      }
    },
    {
      "type": "plan",
      "relations": {
        "_extends_features_from_plan": {
          "tupleToUserset": {
            "tupleset": {
              "object": "",
              "relation": "parent"
            },
            "computedUserset": {
              "object": "",
              "relation": "subscriber"
            }
          }
        },
        "parent": {
          "this": {}
        },
        "subscriber": {
          "union": {
            "child": [
              {
                "this": {}
              },
              {
                "computedUserset": {
                  "object": "",
                  "relation": "_extends_features_from_plan"
                }
              }
            ]
          }
        }
      },
      "metadata": {
        "relations": {
          "_extends_features_from_plan": {
            "directly_related_user_types": [],
            "module": "",
            "source_info": null
          },
          "parent": {
            "directly_related_user_types": [
              {
                "type": "plan",
                "condition": ""
              }
            ],
            "module": "",
            "source_info": null
          },
          "subscriber": {
            "directly_related_user_types": [
              {
                "type": "organization",
                "wildcard": {},
                "condition": ""
              },
              {
                "type": "organization",
                "condition": "non_expired_grant"
              }
            ],
            "module": "",
            "source_info": null
          }
        },
        "module": "",
        "source_info": null
      }
    }
  ],
  "conditions": {
    "at_least_two_admins": {
      "name": "at_least_two_admins",
      "expression": "1 < current_admin_count",
      "parameters": {
        "current_admin_count": {
          "type_name": "TYPE_NAME_INT",
          "generic_types": []
        }
      },
      "metadata": null
    },
    "non_expired_grant": {
      "name": "non_expired_grant",
      "expression": "grant_time < current_time && current_time < grant_time + grant_duration",
      "parameters": {
        "current_time": {
          "type_name": "TYPE_NAME_TIMESTAMP",
          "generic_types": []
        },
        "grant_duration": {
          "type_name": "TYPE_NAME_DURATION",
          "generic_types": []
        },
        "grant_time": {
          "type_name": "TYPE_NAME_TIMESTAMP",
          "generic_types": []
        }
      },
      "metadata": null
    }
  }
}'
set -eE

help() {
  echo "
$0: manage local deeplake stack
  setup: configure the stack, re-running this will reintialize the stack
  start: start the stack, if setup is not done it will setup first
  stop:  stop the stack
  restart: stop the stack and start it again, picking up edits to the
           rendered compose file and already pulled images
         start, stop and restart accept service names to act on those
         services only, e.g. '$0 restart deeplake-api keycloak'
  status: show the state and health of every service, or of the given
          services only, exits 1 unless everything is up and healthy
  scale: change how many deeplake-stateless nodes the stack runs,
         e.g. '$0 scale 2', applies immediately when the stack is up
  set-tag: point a service at a different image tag, e.g.
           '$0 set-tag pg-proxy 1.2.3', recreates the service when it is running,
           any deeplake-stateless-N or deeplake-indexer retags all of them
  upgrade-fga: write the authorization model this script ships to the running
           OpenFGA store, point the compose file at it and recreate the services
           that use it. run it before rolling out a deeplake-api that needs a
           newer model, '$0 start' does it automatically when the model is stale
  creds: print the credentials and endpoints setup printed at the end, read
         back from the rendered compose file
  add-user: create a login in the stack's keycloak realm, keycloak has to be
            running. e.g. '$0 add-user --email jane@example.com --org <org id> --role writer'
              --email EMAIL         required, also the username unless --username is given
              --username NAME       login name, defaults to the email
              --first-name NAME, --last-name NAME
              --password PASSWORD   omit it to get a random one printed once,
                                    a value given here shows in the process list
              --temporary           the default, the password has to be changed on first login
              --no-temporary        keep the password as given
            organization access, optional, needs an org admin's api token:
              --org ORG_ID          invite the user to this organization (its uuid)
              --role ROLE           viewer, writer or admin in the organization, default viewer
              --workspace ID[:ROLE] repeatable, a workspace role, defaulting to --role.
                                    a workspace admin is made an organization admin
              --token TOKEN         an api token from Settings -> API tokens in the ui,
                                    DEEPLAKE_API_TOKEN keeps it out of the process list
            the invite is applied on the user's first sign-in and always grants an
            organization role, workspace only access is set in the ui after that.
            without --first-name and --last-name keycloak asks for them on first login
  destroy: stop the stack and remove all docker volumes, e.g. wipe the data
           pass --force to skip the confirmation prompt (for non-interactive use)
  pull: pull the container images the stack runs, run '$0 start'
        afterwards to recreate the containers on the new images
  completion: print shell completion for this script, '$0 completion bash'
              or '$0 completion zsh', load it with 'source <($0 completion bash)'
              or redirect it into a file your shell picks up
  "
}

check_prerequisites() {
  local fail
  fail=0
  if ! docker --version &>/dev/null; then
    echo "[ERROR] docker is not available, refer to https://docs.docker.com/engine/install/"
    fail=1
  fi
  if ! docker compose ls --quiet &>/dev/null; then
    echo "[ERROR] docker compose is not available, refer to https://docs.docker.com/compose/install/linux/"
    fail=1
  fi
  if ! envsubst --version &>/dev/null; then
    echo "[ERROR] envsubst is not available "
    fail=1
  fi
  if [ "$fail" -eq 1 ]; then
    exit 1
  fi
}

yes_or_no() {
  local answer
  while :; do
    if ! read -rp "$1 [yes/no]: " answer; then
      # stdin is closed (CI, systemd, piped input). Without this the loop
      # would re-read EOF forever; answer 'no' so callers take the safe path.
      echo "[WARNING] no interactive terminal, assuming 'no'" 1>&2
      echo 'no'
      return 0
    fi
    if [ "${answer,,}" == 'yes' ] || [ "${answer,,}" == 'no' ]; then
      break
    else
      echo "[WARNING] only 'yes' or 'no' are allowed as answer" 1>&2
    fi
  done
  echo "${answer,,}"
}

prompt_var() {
  # prompt_var <variable> <prompt> <plain|secret|optional|optional-secret> [regex]
  # keeps whatever the environment already provided, otherwise asks until the
  # answer is non-empty and matches the regex. an optional variable accepts an
  # empty answer, and stays empty when there is no terminal to ask at
  local name="$1" prompt="$2" mode="$3" pattern="${4:-}" value asked='' silent='' required=1
  case "${mode}" in
  secret) silent=1 ;;
  optional) required='' ;;
  optional-secret)
    silent=1
    required=''
    ;;
  esac
  value="${!name}"
  while :; do
    if [ -n "${value}" ]; then
      if [ -z "${pattern}" ] || [[ "${value}" =~ ${pattern} ]]; then
        break
      fi
      echo "[WARNING] ${name} must match ${pattern}" 1>&2
      value=''
    elif [ -n "${asked}" ] && [ -z "${required}" ]; then
      break
    fi
    if [ -n "${silent}" ]; then
      if ! read -rsp "${prompt}: " value; then
        echo
        [ -z "${required}" ] && break
        echo "[ERROR] no interactive terminal, set ${name} in the environment" 1>&2
        exit 1
      fi
      echo
    else
      if ! read -rp "${prompt}: " value; then
        [ -z "${required}" ] && break
        echo "[ERROR] no interactive terminal, set ${name} in the environment" 1>&2
        exit 1
      fi
    fi
    asked=1
  done
  printf -v "${name}" '%s' "${value}"
}

# storage backends
#
# every entry of SUPPORTED_STORAGE_TYPES is backed by an overlay named
# storage-<type>.yaml in this repository, merged over the shared
# compose-base.yaml, and may implement these optional hooks:
#   gen_vars_<type>     generate/prompt and export the storage specific variables
#   print_vars_<type>   print the storage credentials and endpoints
#   edit_compose_<type> adjust ${COMPOSE_BASE_FILE} / ${COMPOSE_OVERLAY_FILE}
#                       before they are merged into the rendered compose file
# with any dash in <type> written as an underscore in the function name
# hooks are invoked through storage_hook, so a backend that needs neither can
# ship with the compose template alone.
storage_hook() {
  local hook="${1}_${STORAGE_TYPE//-/_}"
  if declare -F "${hook}" >/dev/null; then
    "${hook}"
  fi
}

select_storage_type() {
  local type
  if [ -n "${STORAGE_TYPE}" ]; then
    for type in "${SUPPORTED_STORAGE_TYPES[@]}"; do
      if [ "${STORAGE_TYPE}" == "${type}" ]; then
        export STORAGE_TYPE
        return 0
      fi
    done
    echo "[ERROR] unsupported storage type '${STORAGE_TYPE}', supported: ${SUPPORTED_STORAGE_TYPES[*]}"
    exit 1
  fi
  PS3='select the storage type: '
  select type in "${SUPPORTED_STORAGE_TYPES[@]}"; do
    if [ -n "${type}" ]; then
      STORAGE_TYPE="${type}"
      break
    fi
    echo "[WARNING] invalid selection, pick a number from the list above" 1>&2
  done
  if [ -z "${STORAGE_TYPE}" ]; then
    # select returns with an unset reply on EOF (CI, systemd, piped input)
    echo "[ERROR] no storage type selected, set STORAGE_TYPE to one of: ${SUPPORTED_STORAGE_TYPES[*]}"
    exit 1
  fi
  echo "[INFO] using storage type: ${STORAGE_TYPE}"
  export STORAGE_TYPE
}

gen_vars_alarik() {
  STORAGE_ACCESS_KEY=AKIA
  STORAGE_ACCESS_KEY+="$(cat /dev/urandom | tr -dc '[:upper:]' | head -c 15)"
  STORAGE_SECRET_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9/' | head -c 40)"
  STORAGE_JWT_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9/' | head -c 64)"
  STORAGE_USER_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
  export \
    STORAGE_ACCESS_KEY \
    STORAGE_SECRET_KEY \
    STORAGE_JWT_KEY \
    STORAGE_USER_PASSWORD
}

print_vars_alarik() {
  echo "
storage credentials:
  storage s3 access key: ${STORAGE_ACCESS_KEY}
  storage s3 secret key: ${STORAGE_SECRET_KEY}
  storage ui username: alarik
  storage ui password: ${STORAGE_USER_PASSWORD}
storage endpoints:
  storage ui: https://storage.${BASE_HOST}
  storage api: https://storage-api.${BASE_HOST}
"
}

gen_vars_garage() {
  # garage wants its key id as GK + hex and its secret key and rpc secret as
  # plain hex, so these cannot share the alphabet the other secrets use
  STORAGE_ACCESS_KEY=GK
  STORAGE_ACCESS_KEY+="$(cat /dev/urandom | tr -dc 'A-F0-9' | head -c 32)"
  STORAGE_SECRET_KEY="$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 64)"
  STORAGE_RPC_SECRET="$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 64)"
  export \
    STORAGE_ACCESS_KEY \
    STORAGE_SECRET_KEY \
    STORAGE_RPC_SECRET
}

print_vars_garage() {
  echo "
storage credentials:
  storage s3 access key: ${STORAGE_ACCESS_KEY}
  storage s3 secret key: ${STORAGE_SECRET_KEY}
storage endpoints:
  storage api: https://storage-api.${BASE_HOST}
"
}

gen_vars_aws() {
  # s3 lives outside the stack, so nothing is generated here: the bucket and the
  # credentials that reach it come from the user. note that AWS_REGION,
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are picked up from the
  # environment like every other variable, including a shell that already has
  # them exported. the key pair is optional: left empty, the containers get no
  # static credentials and the aws sdk resolves them itself, from an ec2
  # instance profile or whatever else the host provides. edit_compose_aws then
  # drops the two keys from the rendered file
  prompt_var DEEPLAKE_ROOT_PATH 'deeplake root path (s3://<bucket>/<prefix>)' plain '^s3://'
  prompt_var AWS_REGION 'aws region' plain
  prompt_var AWS_ACCESS_KEY_ID 'aws access key id (hit enter if this environment already has access to s3)' optional
  if [ -n "${AWS_ACCESS_KEY_ID}" ]; then
    prompt_var AWS_SECRET_ACCESS_KEY 'aws secret access key' secret
  elif [ -n "${AWS_SECRET_ACCESS_KEY}" ]; then
    echo "[ERROR] AWS_SECRET_ACCESS_KEY is set but AWS_ACCESS_KEY_ID is not, set both or neither" 1>&2
    exit 1
  fi
  export \
    DEEPLAKE_ROOT_PATH \
    AWS_REGION \
    AWS_ACCESS_KEY_ID \
    AWS_SECRET_ACCESS_KEY
}

print_vars_aws() {
  echo "
storage:
  deeplake root path: ${DEEPLAKE_ROOT_PATH}
  aws region: ${AWS_REGION}
  aws access key id: ${AWS_ACCESS_KEY_ID:-none, resolved by the aws sdk}
"
}

gen_vars_external_s3() {
  # an s3 compatible store outside the stack (minio, ceph, wasabi, ...). the two
  # env blocks name the same settings differently, and each pair must hold the
  # same value or deeplake-api and pg-deeplake would read and write different
  # buckets. so every pair is asked for once, under the name on the left, and
  # the twin on the right is derived from it and never read from the
  # environment:
  #   DEEPLAKE_ROOT_PATH -> DEEPLAKE_ROOT_DIR
  #   S3_ENDPOINT_URL    -> AWS_ENDPOINT_URL
  #   S3_REGION          -> AWS_REGION
  #   S3_ACCESS_KEY      -> S3_ACCESS_KEY_ID, AWS_ACCESS_KEY_ID
  #   S3_SECRET_KEY      -> S3_SECRET_ACCESS_KEY, AWS_SECRET_ACCESS_KEY
  # none of the names read here is one docker, the aws cli or an aws sdk would
  # already have in the operator's shell, so an unrelated aws login cannot leak
  # into a storage endpoint that is not amazon's
  prompt_var DEEPLAKE_ROOT_PATH 'deeplake root path (s3://<bucket>/<prefix>)' plain '^s3://'
  prompt_var S3_ENDPOINT_URL 's3 endpoint url (https://<host>)' plain '^https?://'
  prompt_var S3_REGION 's3 region' plain
  prompt_var S3_ACCESS_KEY 's3 access key' plain
  prompt_var S3_SECRET_KEY 's3 secret key' secret
  DEEPLAKE_ROOT_DIR="${DEEPLAKE_ROOT_PATH}"
  S3_ACCESS_KEY_ID="${S3_ACCESS_KEY}"
  S3_SECRET_ACCESS_KEY="${S3_SECRET_KEY}"
  AWS_ENDPOINT_URL="${S3_ENDPOINT_URL}"
  AWS_REGION="${S3_REGION}"
  AWS_ACCESS_KEY_ID="${S3_ACCESS_KEY}"
  AWS_SECRET_ACCESS_KEY="${S3_SECRET_KEY}"
  export \
    DEEPLAKE_ROOT_PATH \
    DEEPLAKE_ROOT_DIR \
    S3_ENDPOINT_URL \
    S3_REGION \
    S3_ACCESS_KEY_ID \
    S3_SECRET_ACCESS_KEY \
    AWS_ENDPOINT_URL \
    AWS_REGION \
    AWS_ACCESS_KEY_ID \
    AWS_SECRET_ACCESS_KEY
}

print_vars_external_s3() {
  echo "
storage:
  deeplake root path: ${DEEPLAKE_ROOT_PATH}
  s3 endpoint url: ${S3_ENDPOINT_URL}
  s3 region: ${S3_REGION}
  s3 access key: ${S3_ACCESS_KEY}
"
}

gen_vars_azure() {
  # azure blob storage lives outside the stack, so nothing is generated here:
  # the container and the service principal that reaches it come from the user
  prompt_var DEEPLAKE_ROOT_PATH 'deeplake root path (az://<account>/<container>/<prefix>)' plain '^az://'
  prompt_var AZURE_TENANT_ID 'azure tenant id' plain
  prompt_var AZURE_CLIENT_ID 'azure client id' plain
  prompt_var AZURE_CLIENT_SECRET 'azure client secret' secret
  export \
    DEEPLAKE_ROOT_PATH \
    AZURE_TENANT_ID \
    AZURE_CLIENT_ID \
    AZURE_CLIENT_SECRET
}

edit_compose_aws() {
  # an empty AWS_ACCESS_KEY_ID rendered as an empty env value would override the
  # sdk's own credential lookup instead of falling back to it, so remove the
  # pair outright and let the sdk find an instance profile or a task role
  if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
    sed -i '/AWS_ACCESS_KEY_ID:/d;/AWS_SECRET_ACCESS_KEY:/d' "${COMPOSE_OVERLAY_FILE}"
    echo "[INFO] no static aws credentials given, the containers will resolve them from the environment"
  fi
}

print_vars_azure() {
  echo "
storage:
  deeplake root path: ${DEEPLAKE_ROOT_PATH}
  azure tenant id: ${AZURE_TENANT_ID}
  azure client id: ${AZURE_CLIENT_ID}
"
}

stateless_count() {
  # one pg-deeplake-stateless node per cpu core less one, so the host keeps a
  # core for everything else. DEEPLAKE_STATELESS_COUNT overrides the detection
  local count
  if [ -n "${DEEPLAKE_STATELESS_COUNT}" ]; then
    if ! [[ "${DEEPLAKE_STATELESS_COUNT}" =~ ^[1-9][0-9]*$ ]]; then
      echo "[ERROR] DEEPLAKE_STATELESS_COUNT must be a positive integer, got '${DEEPLAKE_STATELESS_COUNT}'" 1>&2
      exit 1
    fi
    echo "${DEEPLAKE_STATELESS_COUNT}"
    return 0
  fi
  # nproc honours cpu affinity, /proc/cpuinfo is the fallback when coreutils is
  # not around. neither reflects a cgroup cpu quota, so a host capped with
  # --cpus still reports every core: set DEEPLAKE_STATELESS_COUNT there
  count="$(nproc 2>/dev/null || grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo 0)"
  if [ "${count}" -lt 1 ]; then
    echo "[WARNING] could not detect the cpu count, using a single deeplake-stateless node, set DEEPLAKE_STATELESS_COUNT to override" 1>&2
    count=2
  fi
  count=$((count - 1))
  [ "${count}" -lt 1 ] && count=1
  echo "${count}"
}

gen_vars() {
  local answer
  DEEPLAKE_JWT_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9/' | head -c 64)"
  DEEPLAKE_CREDS_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9/' | head -c 64)"
  PG_ROOT_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
  PG_DEEPLAKE_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
  PG_KEYCLOAK_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
  PG_OPENFGA_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
  DLPG_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
  OPENFGA_AUTH_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32)"
  KEYCLOAK_ADMIN_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
  if [ -z "${BASE_HOST}" ]; then
    read -rp "provide the base hostname: " BASE_HOST
  fi
  if [ -z "${TLS_METHOD}" ]; then
    answer="$(yes_or_no "installation requires to work with TLS enabled, is port 80 accessible from the internet?")"
    if [ "${answer,,}" == 'no' ]; then
      answer="$(yes_or_no "can you provide tls certificate and key file paths to read from? (certificate must be valid for *.${BASE_HOST})")"
      if [ "${answer,,}" == 'no' ]; then
        echo "[ERROR] unable to proceed without TLS, either ensure port 80 is accessible from internet or provide file paths with next run"
        exit 1
      fi
      TLS_METHOD=from_file
    else
      TLS_METHOD=http01
    fi
  fi
  export \
    PG_ROOT_PASSWORD \
    PG_DEEPLAKE_PASSWORD \
    PG_KEYCLOAK_PASSWORD \
    PG_OPENFGA_PASSWORD \
    DLPG_PASSWORD \
    DEEPLAKE_JWT_KEY \
    DEEPLAKE_CREDS_KEY \
    OPENFGA_AUTH_KEY \
    KEYCLOAK_ADMIN_PASSWORD \
    BASE_HOST \
    TLS_KEY_PATH \
    TLS_CERT_PATH \
    TLS_METHOD
  DEEPLAKE_STATELESS_COUNT="$(stateless_count)"
  DEEPLAKE_STATELESS_PODS=''
  for i in $(seq 1 "${DEEPLAKE_STATELESS_COUNT}"); do
    DEEPLAKE_STATELESS_PODS+="${DEEPLAKE_STATELESS_PODS:+,}deeplake-stateless-${i}:5432"
  done
  echo "[INFO] using ${DEEPLAKE_STATELESS_COUNT} pg-deeplake-stateless node(s)"
  export DEEPLAKE_STATELESS_COUNT DEEPLAKE_STATELESS_PODS
  gen_vars_openai
  storage_hook gen_vars
}

gen_vars_openai() {
  # optional: deeplake-api uses an openai key for the 'query with AI' ui
  # feature. a key already in the environment is offered first; without a
  # terminal to ask at, an environment key is used and a missing one is skipped
  local hint="it is used by the 'query with AI' ui feature"
  if [ -n "${OPENAI_API_KEY}" ]; then
    if [ -t 0 ] && [ "$(yes_or_no "OPENAI_API_KEY is set in the environment, pass it to deeplake-api? (${hint})")" == 'no' ]; then
      OPENAI_API_KEY=''
    fi
  elif [ -t 0 ] && [ "$(yes_or_no "would you like to provide an OpenAI API key for deeplake-api? (${hint})")" == 'yes' ]; then
    prompt_var OPENAI_API_KEY 'openai api key' secret
  fi
  # the key lands in a yaml file that compose interpolates, so keep it to the
  # characters openai keys are made of
  if [ -n "${OPENAI_API_KEY}" ] && ! [[ "${OPENAI_API_KEY}" =~ ^[A-Za-z0-9_-]+$ ]]; then
    echo "[ERROR] OPENAI_API_KEY may only contain letters, digits, '-' and '_'" 1>&2
    exit 1
  fi
  export OPENAI_API_KEY
}

print_vars() {
  # the key itself is never printed, only whether deeplake-api has one
  local openai_status="not set, 'query with AI' is disabled"
  [ -n "${OPENAI_API_KEY}" ] && openai_status='set for deeplake-api'
  echo "
credentials:
  keycloak admin username: admin
  keycloak admin password: ${KEYCLOAK_ADMIN_PASSWORD}
endpoints:
  deeplake ui: https://app.${BASE_HOST}
  deeplake api: https://api.${BASE_HOST}
  keycloak: https://kc.${BASE_HOST}
openai:
  api key: ${openai_status}
"
  storage_hook print_vars
}

fetch_template() {
  # fetch_template <name> <destination>, substituting the environment on the way
  local template
  if ! template="$(curl -fsSL "${COMPOSE_BASE_URL}/${1}")"; then
    echo "[ERROR] failed to fetch ${1} for storage type '${STORAGE_TYPE}'"
    exit 1
  fi
  printf '%s\n' "${template}" | envsubst >"${2}"
  chmod 600 "${2}"
}

expand_stateless() {
  # node 1 is in the templates; this writes nodes 2..n at the markers they
  # leave behind. done before the merge, while the anchors the extra services
  # reference are still in the file
  local i services volumes stubs snippet
  [ "${DEEPLAKE_STATELESS_COUNT}" -le 1 ] && return 0
  services='' volumes='' stubs=''
  for i in $(seq 2 "${DEEPLAKE_STATELESS_COUNT}"); do
    services+="  deeplake-stateless-${i}:
    <<: *deeplake-stateless
    hostname: deeplake-stateless-${i}
    container_name: dl-deeplake-stateless-${i}
    volumes:
      - deeplake_stateless_${i}:/var/lib/postgresql
"
    volumes+="  deeplake_stateless_${i}:
    driver: local
    name: dl_deeplake_stateless_${i}
"
    stubs+="  deeplake-stateless-${i}:
    <<: *storage-env
"
  done
  snippet="${CONFIG_DIR}/.stateless-snippet"
  printf '%s' "${services}" >"${snippet}"
  sed -i "/# dl-stack.sh: additional deeplake-stateless services/r ${snippet}" "${COMPOSE_BASE_FILE}"
  printf '%s' "${volumes}" >"${snippet}"
  sed -i "/# dl-stack.sh: additional deeplake-stateless volumes/r ${snippet}" "${COMPOSE_BASE_FILE}"
  printf '%s' "${stubs}" >"${snippet}"
  sed -i "/# dl-stack.sh: additional deeplake-stateless services/r ${snippet}" "${COMPOSE_OVERLAY_FILE}"
  rm -f "${snippet}"
}

ensure_compose_file() {
  mkdir -p "${CONFIG_DIR}"
  if [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    return 0
  fi
  # the stack is one shared compose-base.yaml plus a per storage type overlay.
  # both are edited while they are still separate, because compose normalizes
  # the merged output (environment mappings become lists, anchors are expanded)
  # and these edits match on the source shape
  COMPOSE_BASE_FILE="${CONFIG_DIR}/.compose-base.yaml"
  COMPOSE_OVERLAY_FILE="${CONFIG_DIR}/.storage-${STORAGE_TYPE}.yaml"
  fetch_template 'compose-base.yaml' "${COMPOSE_BASE_FILE}"
  fetch_template "storage-${STORAGE_TYPE}.yaml" "${COMPOSE_OVERLAY_FILE}"
  expand_stateless
  if [ "${TLS_METHOD}" == 'http01' ]; then
    # the overlay carries its own caddy config for the storage vhosts, so the
    # tls directives have to go from both files
    sed -i '/\/certs/d;/caddy_public_key/d;/caddy_private_key/d' \
      "${COMPOSE_BASE_FILE}" "${COMPOSE_OVERLAY_FILE}"
  else
    if [ -z "${TLS_CERT_PATH}" ]; then
      read -rp "tls certificate file path: " TLS_CERT_PATH
    fi
    if [ -z "${TLS_KEY_PATH}" ]; then
      read -rp "tls key file path: " TLS_KEY_PATH
    fi
    sed -i "s|caddy_public_key_file|${TLS_CERT_PATH}|;s|caddy_private_key_file|${TLS_KEY_PATH}|" \
      "${COMPOSE_BASE_FILE}" "${COMPOSE_OVERLAY_FILE}"
  fi
  storage_hook edit_compose
  # the openai key goes to deeplake-api alone, so it rides in a small overlay of
  # its own instead of the env anchor shared with the worker and setup jobs
  local overlays=(-f "${COMPOSE_BASE_FILE}" -f "${COMPOSE_OVERLAY_FILE}")
  local openai_file="${CONFIG_DIR}/.openai.yaml"
  if [ -n "${OPENAI_API_KEY}" ]; then
    (
      umask 077
      printf 'services:\n  deeplake-api:\n    environment:\n      OPENAI_API_KEY: "%s"\n' \
        "${OPENAI_API_KEY}" >"${openai_file}"
    )
    overlays+=(-f "${openai_file}")
  fi
  if ! docker compose --project-name "$(basename "${CONFIG_DIR}")" \
    "${overlays[@]}" \
    config --no-interpolate --no-path-resolution >"${CONFIG_DIR}/compose.yaml"; then
    echo "[ERROR] failed to merge compose-base.yaml with storage-${STORAGE_TYPE}.yaml"
    rm -f "${CONFIG_DIR}/compose.yaml" "${COMPOSE_BASE_FILE}" "${COMPOSE_OVERLAY_FILE}" "${openai_file}"
    exit 1
  fi
  chmod 600 "${CONFIG_DIR}/compose.yaml"
  rm -f "${COMPOSE_BASE_FILE}" "${COMPOSE_OVERLAY_FILE}" "${openai_file}"
  FRESH_SETUP=1
}

setup() {
  local fga_url i
  local curl_tls=()
  check_prerequisites
  if [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[WARNING] compose file alredy exists at ${CONFIG_DIR}/compose.yaml, for fresh setup run ./dl-stack.sh destroy first, otherwise edit existing compose file directly"
    exit 1
  fi
  select_storage_type
  gen_vars
  ensure_compose_file
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d openfga
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d caddy
  fga_url="https://openfga.$BASE_HOST"
  if [ "${TLS_METHOD}" != 'http01' ]; then
    # a from_file certificate may be self-signed or issued by a private CA, so
    # the system trust store cannot verify it. pin the certificate itself as
    # the trust anchor rather than skipping verification: these calls carry
    # OPENFGA_AUTH_KEY, and an unverified connection hands it to whoever
    # answers for openfga.${BASE_HOST}
    curl_tls=(--cacert "${TLS_CERT_PATH}")
  fi
  echo "[INFO] waiting for OpenFGA at ${fga_url}"
  i=0
  until curl -sf "${curl_tls[@]}" -m 5 "${fga_url}/healthz" >/dev/null 2>&1; do
    i=$((i + 1))
    [ $i -gt 60 ] && {
      echo "openfga not ready after 5m"
      exit 1
    }
    sleep 5
  done
  STORE=$(curl -sf "${curl_tls[@]}" -m 30 -X POST "${fga_url}/stores" \
    -H "Authorization: Bearer ${OPENFGA_AUTH_KEY}" \
    -H 'Content-Type: application/json' -d '{"name":"deeplake"}' |
    sed -n 's/.*"id"[ ]*:[ ]*"\([^"]*\)".*/\1/p')
  if [ -z "$STORE" ]; then
    echo "[ERROR] failed to create openfga store"
    destroy --force
    exit 1
  fi
  echo "[INFO] openfga store initialized: $STORE"
  sed -i "s/fga_store_id/${STORE}/" "${CONFIG_DIR}/compose.yaml"
  MODEL=$(curl -sf "${curl_tls[@]}" -m 60 -X POST "${fga_url}/stores/$STORE/authorization-models" \
    -H "Authorization: Bearer ${OPENFGA_AUTH_KEY}" \
    -H 'Content-Type: application/json' --data "${OPENFGA_MODEL}" |
    sed -n 's/.*"authorization_model_id"[ ]*:[ ]*"\([^"]*\)".*/\1/p')
  if [ -z "$MODEL" ]; then
    echo "[ERROR] failed to create openfga model"
    destroy --force
    exit 1
  fi
  echo "[INFO] openfga model initialized: $MODEL"
  sed -i "s/fga_authorization_model_id/${MODEL}/" "${CONFIG_DIR}/compose.yaml"
  record_fga_model "${MODEL}"
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d deeplake-setup
  stop
  if [ "${FRESH_SETUP}" -eq 1 ]; then
    print_vars
  fi
}

scale() {
  # rewrites the rendered compose file for a different number of
  # deeplake-stateless nodes. node 1 is the template every other node is
  # generated from, so nodes 2..n are always regenerated and the same code path
  # serves both scaling up and scaling down
  local target current pods i new dropped vol
  target="${1:-}"
  if ! [[ "${target}" =~ ^[1-9][0-9]*$ ]]; then
    echo "[ERROR] scale needs a positive integer, e.g. ./dl-stack.sh scale 2"
    exit 1
  fi
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] nothing to scale, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first"
    exit 1
  fi
  check_prerequisites
  current="$(grep -cE '^  deeplake-stateless-[0-9]+:$' "${CONFIG_DIR}/compose.yaml" || true)"
  if [ "${current}" -eq 0 ]; then
    echo "[ERROR] no deeplake-stateless services found in ${CONFIG_DIR}/compose.yaml"
    exit 1
  fi
  if ! grep -qE '^  deeplake-stateless-1:$' "${CONFIG_DIR}/compose.yaml"; then
    # every other node is generated from node 1, so without it there is nothing
    # to copy and the rewrite would silently drop the rest
    echo "[ERROR] deeplake-stateless-1 is missing from ${CONFIG_DIR}/compose.yaml, cannot scale from it"
    exit 1
  fi
  if [ "${target}" -eq "${current}" ]; then
    echo "[INFO] already at ${current} deeplake-stateless node(s), nothing to do"
    return 0
  fi
  pods=''
  for i in $(seq 1 "${target}"); do
    pods+="${pods:+,}deeplake-stateless-${i}:5432"
  done
  dropped=''
  if [ "${target}" -lt "${current}" ]; then
    dropped="$(awk -v target="${target}" '
      /^volumes:$/                     { invol = 1; next }
      invol && /^[^ ]/                  { invol = 0 }
      invol && /^  deeplake_stateless_[0-9]+:$/ {
        n = $0; gsub(/[^0-9]/, "", n)
        want = (n + 0 > target); next
      }
      invol && want && /^    name: /    { print $2; want = 0 }
    ' "${CONFIG_DIR}/compose.yaml")"
  fi
  new="${CONFIG_DIR}/.compose.yaml.new"
  awk -v target="${target}" -v pods="${pods}" '
    function emit_services(   i, j, line) {
      for (i = 2; i <= target; i++)
        for (j = 1; j <= nb; j++) {
          line = blk[j]
          gsub(/deeplake-stateless-1/, "deeplake-stateless-" i, line)
          gsub(/deeplake_stateless_1/, "deeplake_stateless_" i, line)
          print line
        }
    }
    function emit_volumes(   i) {
      for (i = 2; i <= target; i++) {
        print "  deeplake_stateless_" i ":"
        print "    driver: local"
        print "    name: dl_deeplake_stateless_" i
      }
    }
    function is_key() { return ($0 ~ /^  [^ ]/ || $0 ~ /^[^ ]/) }
    /^  deeplake-stateless-1:$/ { in1 = 1; nb = 0; blk[++nb] = $0; print; next }
    in1 && !is_key()            { blk[++nb] = $0; print; next }
    in1                         { in1 = 0; emit_services() }
    /^  deeplake-stateless-[0-9]+:$/ { n = $0; gsub(/[^0-9]/, "", n); if (n + 0 >= 2) { sk = 1; next } }
    sk && !is_key()             { next }
    sk                          { sk = 0 }
    /^  deeplake_stateless_1:$/ { v1 = 1; print; next }
    v1 && !is_key()             { print; next }
    v1                          { v1 = 0; emit_volumes() }
    /^  deeplake_stateless_[0-9]+:$/ { n = $0; gsub(/[^0-9]/, "", n); if (n + 0 >= 2) { sv = 1; next } }
    sv && !is_key()             { next }
    sv                          { sv = 0 }
    /^      LOCAL_PODS: /       { print "      LOCAL_PODS: " pods; next }
    /^      - LOCAL_PODS=/      { print "      - LOCAL_PODS=" pods; next }
                                { print }
    # a block that runs to the end of the file never meets a following key
    END                         { if (in1) emit_services(); if (v1) emit_volumes() }
  ' "${CONFIG_DIR}/compose.yaml" >"${new}"
  chmod 600 "${new}"
  if ! docker compose -f "${new}" config --quiet; then
    echo "[ERROR] the rewritten compose file did not validate, ${CONFIG_DIR}/compose.yaml is unchanged"
    rm -f "${new}"
    exit 1
  fi
  mv "${new}" "${CONFIG_DIR}/compose.yaml"
  echo "[INFO] deeplake-stateless scaled from ${current} to ${target} node(s)"
  if [ -n "$(docker compose -f "${CONFIG_DIR}/compose.yaml" ps -q 2>/dev/null)" ]; then
    # --remove-orphans is what takes away the containers of nodes that are gone
    docker compose -f "${CONFIG_DIR}/compose.yaml" up -d --remove-orphans
  else
    echo "[INFO] the stack is not running, the new node count applies on the next ./dl-stack.sh start"
  fi
  # the containers are gone by now, so their volumes can be dropped. only names
  # this file listed for a node above the new count are touched, which never
  # includes node 1
  for vol in ${dropped}; do
    if ! docker volume inspect "${vol}" >/dev/null 2>&1; then
      continue
    fi
    if docker volume rm "${vol}" >/dev/null 2>&1; then
      echo "[INFO] removed volume ${vol}"
    else
      echo "[WARNING] could not remove volume ${vol}, something is still using it" 1>&2
    fi
  done
}

set_tag() {
  # set_tag <service> <tag>: points the service's image at a different tag in
  # the rendered compose file. that file is 'docker compose config' output, so
  # a service is a two space indented key and its image a four space indented
  # 'image:' line inside it
  local svc tag image repo last new changed name old
  local targets=() running=()
  svc="${1:-}"
  tag="${2:-}"
  if [ -z "${svc}" ] || [ -z "${tag}" ]; then
    echo "[ERROR] set-tag needs a service and a tag, e.g. ./dl-stack.sh set-tag pg-proxy 1.2.3" 1>&2
    exit 1
  fi
  # the docker reference grammar for a tag
  if ! [[ "${tag}" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$ ]]; then
    echo "[ERROR] '${tag}' is not a valid image tag" 1>&2
    exit 1
  fi
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] nothing to change, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first" 1>&2
    exit 1
  fi
  check_prerequisites
  check_services "${svc}"
  # the deeplake-stateless nodes and deeplake-indexer run the same postgres
  # image and have to stay on the same version, so naming any of them retags
  # all of them
  targets=("${svc}")
  if [[ "${svc}" =~ ^deeplake-(stateless-[0-9]+|indexer)$ ]]; then
    mapfile -t targets < <(grep -oE '^  deeplake-(stateless-[0-9]+|indexer):$' "${CONFIG_DIR}/compose.yaml" | tr -d ' :')
  fi
  image="$(awk -v svc="${svc}" '
    /^  [^ ]/ || /^[^ ]/       { in_svc = ($0 == "  " svc ":"); next }
    in_svc && /^    image: /  { sub(/^    image: /, ""); gsub(/["'\'']/, ""); print; exit }
  ' "${CONFIG_DIR}/compose.yaml")"
  if [ -z "${image}" ]; then
    echo "[ERROR] service '${svc}' has no image in ${CONFIG_DIR}/compose.yaml" 1>&2
    exit 1
  fi
  # drop a digest, then the tag. a ':' only starts the tag when it comes after
  # the last '/', otherwise it is a registry port, e.g. registry:5000/repo
  repo="${image%%@*}"
  last="${repo##*/}"
  if [[ "${last}" == *:* ]]; then
    repo="${repo%:*}"
  fi
  new="${repo}:${tag}"
  # prints '<service> <old image>' for every target whose image changes
  changed="$(awk -v names="${targets[*]}" -v img="${new}" -v out="${CONFIG_DIR}/.compose.yaml.new" '
    BEGIN                     { n = split(names, a, " "); for (i = 1; i <= n; i++) want[a[i]] = 1 }
    /^  [^ ]/ || /^[^ ]/       { cur = $0; sub(/^  /, "", cur); sub(/:$/, "", cur); in_svc = (cur in want) }
    in_svc && /^    image: /  {
      old = $0; sub(/^    image: /, "", old); gsub(/["'\'']/, "", old)
      if (old != img) print cur " " old
      print "    image: " img > out; in_svc = 0; next
    }
                              { print > out }
  ' "${CONFIG_DIR}/compose.yaml")"
  if [ -z "${changed}" ]; then
    rm -f "${CONFIG_DIR}/.compose.yaml.new"
    echo "[INFO] ${targets[*]} already on ${new}, nothing to do"
    return 0
  fi
  chmod 600 "${CONFIG_DIR}/.compose.yaml.new"
  if ! docker compose -f "${CONFIG_DIR}/.compose.yaml.new" config --quiet; then
    echo "[ERROR] the rewritten compose file did not validate, ${CONFIG_DIR}/compose.yaml is unchanged" 1>&2
    rm -f "${CONFIG_DIR}/.compose.yaml.new"
    exit 1
  fi
  mv "${CONFIG_DIR}/.compose.yaml.new" "${CONFIG_DIR}/compose.yaml"
  running=()
  while read -r name old; do
    echo "[INFO] ${name}: ${old} -> ${new}"
    if [ -n "$(docker compose -f "${CONFIG_DIR}/compose.yaml" ps -q --status running "${name}" 2>/dev/null)" ]; then
      running+=("${name}")
    else
      echo "[INFO] ${name} is not running, the new tag applies on the next ./dl-stack.sh start"
    fi
  done <<<"${changed}"
  if [ "${#running[@]}" -gt 0 ]; then
    # up pulls the new image when it is not local yet and recreates only these
    # containers, --no-deps leaves the services they depend on alone
    docker compose -f "${CONFIG_DIR}/compose.yaml" up -d --no-deps "${running[@]}"
  fi
}

fga_model_sha() {
  # sha256 of the model this script ships
  if command -v sha256sum >/dev/null 2>&1; then
    printf '%s' "${OPENFGA_MODEL}" | sha256sum | cut -d' ' -f1
  else
    printf '%s' "${OPENFGA_MODEL}" | shasum -a 256 | cut -d' ' -f1
  fi
}

record_fga_model() {
  # record_fga_model <model id>: remembers which model content the id in the
  # compose file was written from, so an unchanged model is never rewritten
  printf '%s %s\n' "$(fga_model_sha)" "$1" >"${CONFIG_DIR}/.openfga-model"
}

compose_values() {
  # compose_values <KEY>: the distinct values of KEY in the rendered compose
  # file (one per line, quotes stripped). The x- anchors hold it as
  # '  KEY: value', the services as '  - KEY=value'.
  sed -n "s/^ *\(- *\)\{0,1\}$1[:=] *[\"']\{0,1\}\([^\"' ]*\)[\"']\{0,1\} *$/\2/p" "${CONFIG_DIR}/compose.yaml" | sort -u
}

compose_tls_cert() {
  # the certificate file caddy serves for a from_file setup, empty for http01,
  # where the system trust store verifies the public certificate on its own
  awk '/^  caddy_public_key:/ { in_cfg = 1; next }
       /^  [^ ]/ || /^[^ ]/ { in_cfg = 0 }
       in_cfg && /^    file: / { sub(/^    file: /, ""); print; exit }' "${CONFIG_DIR}/compose.yaml"
}

fga_model_current() {
  # succeeds when the model id in the compose file was written from the model
  # this script ships (or when there is no stack to upgrade yet)
  local old
  [ -f "${CONFIG_DIR}/compose.yaml" ] || return 0
  old="$(compose_values FGA_AUTHORIZATION_MODEL_ID)"
  [ -n "${old}" ] && [ "$(cat "${CONFIG_DIR}/.openfga-model" 2>/dev/null)" == "$(fga_model_sha) ${old}" ]
}

upgrade_fga() {
  # writes the shipped authorization model as a new model of the existing
  # OpenFGA store, replaces the model id in the rendered compose file and
  # recreates the services that read it. a new model is only an addition, the
  # tuples already in the store stay valid, and an older deeplake-api keeps
  # working on it, so this is safe to run before the api itself is upgraded
  local store old new key host cert fga_url i changed tmp name
  local curl_tls=() running=()
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] nothing to upgrade, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first" 1>&2
    exit 1
  fi
  check_prerequisites
  store="$(compose_values FGA_STORE_ID)"
  old="$(compose_values FGA_AUTHORIZATION_MODEL_ID)"
  key="$(compose_values FGA_API_TOKEN)"
  host="$(compose_values APP_BASE_URL | sed -n 's#^https://app\.##p')"
  # several model ids are possible: an earlier upgrade-fga only rewrote the
  # anchor form, all of them get replaced below
  if [ -z "${old}" ]; then
    echo "[ERROR] cannot read the OpenFGA model id from ${CONFIG_DIR}/compose.yaml, was setup completed?" 1>&2
    exit 1
  fi
  for i in "${store}" "${key}" "${host}"; do
    if [ -z "${i}" ] || [ "$(printf '%s\n' "${i}" | wc -l)" -ne 1 ]; then
      echo "[ERROR] cannot read a single OpenFGA store id, model id, token and host from ${CONFIG_DIR}/compose.yaml, was setup completed?" 1>&2
      exit 1
    fi
  done
  if [ "${store}" == 'fga_store_id' ] || grep -qx 'fga_authorization_model_id' <<<"${old}"; then
    echo "[ERROR] ${CONFIG_DIR}/compose.yaml still has the OpenFGA placeholders, setup did not finish" 1>&2
    exit 1
  fi
  if fga_model_current; then
    echo "[INFO] openfga model ${old} is already the model this script ships, nothing to do"
    return 0
  fi
  # same trust handling as setup: a from_file certificate is pinned as the
  # trust anchor because these calls carry the OpenFGA token
  cert="$(compose_tls_cert)"
  if [ -n "${cert}" ]; then
    curl_tls=(--cacert "${cert}")
  fi
  fga_url="https://openfga.${host}"
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d openfga caddy
  echo "[INFO] waiting for OpenFGA at ${fga_url}"
  i=0
  until curl -sf "${curl_tls[@]}" -m 5 "${fga_url}/healthz" >/dev/null 2>&1; do
    i=$((i + 1))
    [ $i -gt 60 ] && {
      echo "[ERROR] openfga not ready after 5m" 1>&2
      exit 1
    }
    sleep 5
  done
  new=$(curl -sf "${curl_tls[@]}" -m 60 -X POST "${fga_url}/stores/${store}/authorization-models" \
    -H "Authorization: Bearer ${key}" \
    -H 'Content-Type: application/json' --data "${OPENFGA_MODEL}" |
    sed -n 's/.*"authorization_model_id"[ ]*:[ ]*"\([^"]*\)".*/\1/p')
  if [ -z "${new}" ]; then
    echo "[ERROR] failed to write the authorization model to store ${store}, ${CONFIG_DIR}/compose.yaml is unchanged" 1>&2
    exit 1
  fi
  echo "[INFO] openfga model written: ${new}"
  tmp="${CONFIG_DIR}/.compose.yaml.new"
  sed -e "s/^\( *FGA_AUTHORIZATION_MODEL_ID: *\).*$/\1${new}/" \
    -e "s/^\( *- *FGA_AUTHORIZATION_MODEL_ID=\).*$/\1${new}/" "${CONFIG_DIR}/compose.yaml" >"${tmp}"
  chmod 600 "${tmp}"
  if ! docker compose -f "${tmp}" config --quiet; then
    echo "[ERROR] the rewritten compose file did not validate, ${CONFIG_DIR}/compose.yaml is unchanged" 1>&2
    rm -f "${tmp}"
    exit 1
  fi
  mv "${tmp}" "${CONFIG_DIR}/compose.yaml"
  record_fga_model "${new}"
  echo "[INFO] model id in ${CONFIG_DIR}/compose.yaml: $(tr '\n' ' ' <<<"${old}")-> ${new}"
  # every service that carries the model id, e.g. deeplake-api, deeplake-worker
  # and the one-shot deeplake-setup
  changed="$(awk '/^  [^ ]/ || /^[^ ]/ { cur = $0; sub(/^  /, "", cur); sub(/:$/, "", cur); seen = 0 }
                  /^      (- *)?FGA_AUTHORIZATION_MODEL_ID[:=]/ && !seen { print cur; seen = 1 }' "${CONFIG_DIR}/compose.yaml")"
  while read -r name; do
    [ -n "${name}" ] || continue
    if [ -n "$(docker compose -f "${CONFIG_DIR}/compose.yaml" ps -q --status running "${name}" 2>/dev/null)" ]; then
      running+=("${name}")
    else
      echo "[INFO] ${name} is not running, the new model applies on the next ./dl-stack.sh start"
    fi
  done <<<"${changed}"
  if [ "${#running[@]}" -gt 0 ]; then
    echo "[INFO] recreating ${running[*]}"
    # --no-deps leaves the services they depend on alone
    docker compose -f "${CONFIG_DIR}/compose.yaml" up -d --no-deps "${running[@]}"
  fi
}

check_services() {
  # every argument has to be a service of the rendered compose file, otherwise
  # docker compose fails half way through with a less helpful message
  local known svc
  if [ "$#" -eq 0 ]; then
    return
  fi
  known="$(docker compose -f "${CONFIG_DIR}/compose.yaml" config --services 2>/dev/null)"
  for svc in "$@"; do
    if ! grep -qxF -- "${svc}" <<<"${known}"; then
      echo "[ERROR] unknown service '${svc}', the stack runs:" 1>&2
      sed 's/^/  /' <<<"${known}" 1>&2
      exit 1
    fi
  done
}

start() {
  # with no arguments the whole stack comes up, otherwise only the named
  # services (and whatever they depend on)
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    setup
  fi
  check_services "$@"
  # an existing stack may carry an older authorization model than the one this
  # script ships, and a newer deeplake-api fails every request against it, so
  # bring the model up to date before any service is (re)created
  if ! fga_model_current; then
    upgrade_fga
  fi
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d "$@"
}

stop() {
  # with no arguments the whole stack is torn down (containers and network
  # removed, volumes kept), otherwise only the named containers are stopped
  if [ "$#" -eq 0 ]; then
    docker compose -f "${CONFIG_DIR}/compose.yaml" down
    return
  fi
  check_services "$@"
  docker compose -f "${CONFIG_DIR}/compose.yaml" stop "$@"
}

restart() {
  check_prerequisites
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] nothing to restart, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first"
    exit 1
  fi
  check_services "$@"
  stop "$@"
  start "$@"
}

destroy() {
  local answer
  if [ "${1:-}" != '--force' ]; then
    answer="$(yes_or_no "all the data will be removed and generated compose file will deleted, do ou want to proceed? ")"
    if [ "${answer}" != 'yes' ]; then
      echo "[INFO] destroy aborted, nothing was removed"
      return 0
    fi
  fi
  docker compose -f "${CONFIG_DIR}/compose.yaml" down -v
  rm -f "${CONFIG_DIR}/compose.yaml" "${CONFIG_DIR}/.compose.yaml.new" "${CONFIG_DIR}/.openfga-model"
}

pull() {
  check_prerequisites
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] nothing to pull, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first"
    exit 1
  fi
  docker compose -f "${CONFIG_DIR}/compose.yaml" pull
}

status() {
  # one line per service of the rendered compose file, including the ones
  # without a container (never started, or removed by stop), so a stopped
  # stack is visible as such instead of printing nothing. exits 1 when any
  # service is not fully up, so it doubles as a readiness probe: a service is
  # fine when it is running and healthy (or has no healthcheck), or when it is
  # a one-shot job that exited 0
  local services=() ps svc line state health exit_code detail rc
  check_prerequisites
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] nothing to show, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first"
    exit 1
  fi
  check_services "$@"
  if [ "$#" -eq 0 ]; then
    mapfile -t services < <(docker compose -f "${CONFIG_DIR}/compose.yaml" config --services | sort)
  else
    services=("$@")
  fi
  # '|' rather than a tab as the field separator: health is empty for services
  # without a healthcheck and read collapses runs of whitespace separators,
  # which would shift the columns
  ps="$(docker compose -f "${CONFIG_DIR}/compose.yaml" ps -a \
    --format '{{.Service}}|{{.State}}|{{.Health}}|{{.ExitCode}}|{{.Status}}')"
  rc=0
  printf '%-24s %-10s %-10s %s\n' SERVICE STATE HEALTH DETAIL
  for svc in "${services[@]}"; do
    line="$(grep -m1 "^${svc}|" <<<"${ps}" || true)"
    if [ -z "${line}" ]; then
      printf '%-24s %-10s %-10s %s\n' "${svc}" absent - "no container, run ./dl-stack.sh start"
      rc=1
      continue
    fi
    IFS='|' read -r _ state health exit_code detail <<<"${line}"
    case "${state}:${health:--}" in
    running:healthy | running:-) ;;
    exited:*)
      if [ "${exit_code}" != '0' ]; then
        rc=1
      fi
      ;;
    *) rc=1 ;;
    esac
    printf '%-24s %-10s %-10s %s\n' "${svc}" "${state}" "${health:--}" "${detail}"
  done
  return "${rc}"
}

creds() {
  # reprints what setup prints at the end. nothing but the rendered compose
  # file outlives setup, so every value, and the storage type itself, is read
  # back from it. no docker needed, the stack does not have to be running
  local kc_host
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] no credentials to show, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first" 1>&2
    exit 1
  fi
  kc_host="$(compose_values KC_HOSTNAME | head -n1)"
  BASE_HOST="${kc_host#kc.}"
  KEYCLOAK_ADMIN_PASSWORD="$(compose_values KC_BOOTSTRAP_ADMIN_PASSWORD | head -n1)"
  OPENAI_API_KEY="$(compose_values OPENAI_API_KEY | head -n1)"
  if [ -z "${BASE_HOST}" ] || [ -z "${KEYCLOAK_ADMIN_PASSWORD}" ]; then
    echo "[ERROR] cannot read the base host and keycloak admin password from ${CONFIG_DIR}/compose.yaml" 1>&2
    exit 1
  fi
  # each storage type leaves a key no other type has: alarik and garage their
  # own service settings, azure the service principal, external-s3 an endpoint
  # outside the stack. aws is what remains
  if [ -n "$(compose_values GARAGE_DEFAULT_ACCESS_KEY)" ]; then
    STORAGE_TYPE=garage
    STORAGE_ACCESS_KEY="$(compose_values GARAGE_DEFAULT_ACCESS_KEY | head -n1)"
    STORAGE_SECRET_KEY="$(compose_values GARAGE_DEFAULT_SECRET_KEY | head -n1)"
  elif [ -n "$(compose_values DEFAULT_ACCESS_KEY)" ]; then
    STORAGE_TYPE=alarik
    STORAGE_ACCESS_KEY="$(compose_values DEFAULT_ACCESS_KEY | head -n1)"
    STORAGE_SECRET_KEY="$(compose_values DEFAULT_SECRET_KEY | head -n1)"
    STORAGE_USER_PASSWORD="$(compose_values ADMIN_PASSWORD | head -n1)"
  elif [ -n "$(compose_values AZURE_TENANT_ID)" ]; then
    STORAGE_TYPE=azure
    AZURE_TENANT_ID="$(compose_values AZURE_TENANT_ID | head -n1)"
    AZURE_CLIENT_ID="$(compose_values AZURE_CLIENT_ID | head -n1)"
  elif [ -n "$(compose_values S3_ENDPOINT_URL)" ]; then
    STORAGE_TYPE=external-s3
    S3_ENDPOINT_URL="$(compose_values S3_ENDPOINT_URL | head -n1)"
    S3_REGION="$(compose_values S3_REGION | head -n1)"
    S3_ACCESS_KEY="$(compose_values S3_ACCESS_KEY_ID | head -n1)"
  else
    STORAGE_TYPE=aws
    AWS_REGION="$(compose_values AWS_REGION | head -n1)"
    AWS_ACCESS_KEY_ID="$(compose_values AWS_ACCESS_KEY_ID | head -n1)"
  fi
  DEEPLAKE_ROOT_PATH="$(compose_values DEEPLAKE_ROOT_PATH | head -n1)"
  echo "storage type: ${STORAGE_TYPE}"
  print_vars
}

json_str() {
  # json_str <value>: the value as a json string literal. callers reject
  # control characters first, so only the backslash and the quote need escaping
  local s="${1//\\/\\\\}"
  printf '"%s"' "${s//\"/\\\"}"
}

kc_admin() {
  # kc_admin <kcadm.sh arguments>: one admin cli call inside the keycloak
  # container, logged in to the master realm as the bootstrap admin. the
  # password reaches kcadm.sh through KC_CLI_PASSWORD, handed to docker exec by
  # name only, so it is on no command line, and --no-config leaves no cached
  # token behind in the container. stdin is passed through for request bodies,
  # stderr is folded into the output minus kcadm's own 'Logging into' line
  local out rc=0
  out="$(KC_CLI_PASSWORD="${KC_ADMIN_PASSWORD}" docker exec -i -e KC_CLI_PASSWORD "${KC_CONTAINER}" \
    /opt/keycloak/bin/kcadm.sh "$@" --no-config --server http://localhost:8080 --realm master --user admin 2>&1)" || rc=$?
  grep -v '^Logging into ' <<<"${out}" || true
  return "${rc}"
}

print_indented() {
  # print_indented <text>: the text on stderr, every line indented under the
  # [ERROR] line before it
  local line
  while IFS= read -r line; do
    echo "  ${line}" 1>&2
  done <<<"$1"
}

add_user() {
  # creates a login in the keycloak realm the stack signs in with and, with
  # --org, invites it to an organization through the deeplake api. deeplake
  # itself only learns about the user on their first sign-in, which is also
  # when the pending invite is applied
  local email='' first_name='' last_name='' username='' password='' temporary=1
  local org='' role='' token="${DEEPLAKE_API_TOKEN:-}" generated='' i ws ws_id ws_role access_mode
  local issuer realm base_host api_url cert out body user_id grants='' invite_body code
  local workspaces=() curl_tls=()
  local ctrl='[[:cntrl:]]' name_bad='[]<>&"$%!#?;*~/\\|^=[{}()]'
  while [ "$#" -gt 0 ]; do
    case "$1" in
    --email | --first-name | --last-name | --username | --password | --org | --role | --workspace | --token)
      if [ "$#" -lt 2 ]; then
        echo "[ERROR] $1 needs a value" 1>&2
        exit 1
      fi
      case "$1" in
      --email) email="$2" ;;
      --first-name) first_name="$2" ;;
      --last-name) last_name="$2" ;;
      --username) username="$2" ;;
      --password) password="$2" ;;
      --org) org="$2" ;;
      --role) role="$2" ;;
      --workspace) workspaces+=("$2") ;;
      --token) token="$2" ;;
      esac
      shift
      ;;
    --temporary) temporary=1 ;;
    --no-temporary) temporary='' ;;
    *)
      echo "[ERROR] unknown add-user option '$1'" 1>&2
      help
      exit 1
      ;;
    esac
    shift
  done

  # everything is checked before keycloak is touched, so a typo never leaves a
  # half created user behind. keycloak stores usernames and emails lowercased
  if [ -z "${email}" ]; then
    echo "[ERROR] add-user needs --email, e.g. ./dl-stack.sh add-user --email jane@example.com" 1>&2
    exit 1
  fi
  email="${email,,}"
  if ! [[ "${email}" =~ ^[a-z0-9._%+-]+@[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,}$ ]]; then
    echo "[ERROR] '${email}' is not an email address" 1>&2
    exit 1
  fi
  username="${username:-${email}}"
  username="${username,,}"
  if ! [[ "${username}" =~ ^[a-z0-9._@+-]+$ ]]; then
    echo "[ERROR] --username may only contain letters, digits and . _ @ + -" 1>&2
    exit 1
  fi
  # keycloak's user profile refuses these in a person name with a bare 400
  if [[ "${first_name}${last_name}" =~ ${ctrl} ]] || [[ "${first_name}${last_name}" =~ ${name_bad} ]]; then
    echo "[ERROR] --first-name and --last-name may not contain control characters or any of <>&\"\$%!#?;*~/\\|^=[]{}()" 1>&2
    exit 1
  fi
  if [ -z "${password}" ]; then
    password="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
    generated=1
  elif [[ "${password}" =~ ${ctrl} ]]; then
    echo "[ERROR] --password may not contain control characters" 1>&2
    exit 1
  fi
  # organization access is all or nothing: --org turns it on, and the options
  # that shape it mean nothing without it
  if [ -z "${org}" ]; then
    if [ -n "${role}" ] || [ "${#workspaces[@]}" -gt 0 ]; then
      echo "[ERROR] --role and --workspace need --org" 1>&2
      exit 1
    fi
  else
    if ! [[ "${org}" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]; then
      echo "[ERROR] --org takes the organization id, a uuid, got '${org}'" 1>&2
      exit 1
    fi
    role="${role:-viewer}"
    if ! [[ "${role}" =~ ^(viewer|writer|admin)$ ]]; then
      echo "[ERROR] --role must be viewer, writer or admin, got '${role}'" 1>&2
      exit 1
    fi
    if [ -z "${token}" ]; then
      echo "[ERROR] --org needs the api token of an organization admin, pass --token or set DEEPLAKE_API_TOKEN (create one in the ui under Settings -> API tokens)" 1>&2
      exit 1
    fi
    # the token is written into a curl config below, keep it to token characters
    if ! [[ "${token}" =~ ^[A-Za-z0-9._~+/=-]+$ ]]; then
      echo "[ERROR] the api token contains characters an api token does not have" 1>&2
      exit 1
    fi
    for ws in "${workspaces[@]}"; do
      if ! [[ "${ws}" =~ ^[A-Za-z0-9._-]+(:(viewer|writer|admin))?$ ]]; then
        echo "[ERROR] --workspace takes <id> or <id>:viewer|writer|admin, got '${ws}'" 1>&2
        exit 1
      fi
    done
  fi

  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[ERROR] no stack to add a user to, ${CONFIG_DIR}/compose.yaml does not exist, run ./dl-stack.sh setup first" 1>&2
    exit 1
  fi
  check_prerequisites
  # the realm comes from the issuer the services validate tokens against, the
  # container from the keycloak service, both read back from the compose file
  issuer="$(compose_values OIDC_ISSUER | head -n1)"
  realm="${issuer##*/realms/}"
  base_host="$(compose_values KC_HOSTNAME | head -n1)"
  base_host="${base_host#kc.}"
  api_url="$(compose_values API_BASE_URL | head -n1)"
  KC_ADMIN_PASSWORD="$(compose_values KC_BOOTSTRAP_ADMIN_PASSWORD | head -n1)"
  KC_CONTAINER="$(awk '/^  keycloak:$/ { in_svc = 1; next }
                       /^  [^ ]/ || /^[^ ]/ { in_svc = 0 }
                       in_svc && /^    container_name: / { sub(/^    container_name: /, ""); print; exit }' "${CONFIG_DIR}/compose.yaml")"
  KC_CONTAINER="${KC_CONTAINER:-dl-keycloak}"
  if [ -z "${issuer}" ] || [ "${realm}" == "${issuer}" ] || [ -z "${base_host}" ] || [ -z "${KC_ADMIN_PASSWORD}" ]; then
    echo "[ERROR] cannot read the keycloak realm, base host and admin password from ${CONFIG_DIR}/compose.yaml" 1>&2
    exit 1
  fi
  if [ -n "${org}" ] && [ -z "${api_url}" ]; then
    echo "[ERROR] cannot read the deeplake api url from ${CONFIG_DIR}/compose.yaml" 1>&2
    exit 1
  fi
  if [ "$(docker inspect -f '{{.State.Running}}' "${KC_CONTAINER}" 2>/dev/null)" != 'true' ]; then
    echo "[ERROR] keycloak (${KC_CONTAINER}) is not running, start it with ./dl-stack.sh start keycloak" 1>&2
    exit 1
  fi

  if ! out="$(kc_admin get "realms/${realm}" --fields realm </dev/null)"; then
    echo "[ERROR] cannot read realm '${realm}' as the keycloak admin:" 1>&2
    print_indented "${out}"
    exit 1
  fi
  # create would refuse a duplicate too, checking first gives the clearer error
  for i in "username=${username}" "email=${email}"; do
    if ! out="$(kc_admin get users -r "${realm}" -q "${i}" -q exact=true --fields id </dev/null)"; then
      echo "[ERROR] cannot look up users in realm '${realm}':" 1>&2
      print_indented "${out}"
      exit 1
    fi
    if grep -q '"id"' <<<"${out}"; then
      echo "[ERROR] realm '${realm}' already has a user with ${i/=/ }, nothing was changed" 1>&2
      exit 1
    fi
  done

  # the admin creates the user, so the email counts as verified. the password
  # rides in the request body on stdin rather than on a command line, and a
  # temporary one makes keycloak ask for a new password on the first login
  body="{\"username\":$(json_str "${username}"),\"email\":$(json_str "${email}"),\"enabled\":true,\"emailVerified\":true"
  [ -n "${first_name}" ] && body+=",\"firstName\":$(json_str "${first_name}")"
  [ -n "${last_name}" ] && body+=",\"lastName\":$(json_str "${last_name}")"
  body+=",\"credentials\":[{\"type\":\"password\",\"value\":$(json_str "${password}"),\"temporary\":$([ -n "${temporary}" ] && echo true || echo false)}]}"
  if ! out="$(printf '%s' "${body}" | kc_admin create users -r "${realm}" -f - -i)" || [ -z "${out}" ]; then
    echo "[ERROR] keycloak did not create the user:" 1>&2
    print_indented "${out}"
    exit 1
  fi
  user_id="$(tail -n1 <<<"${out}")"
  echo "[INFO] created ${username} in keycloak realm '${realm}' (id ${user_id})"

  code=0
  if [ -n "${org}" ]; then
    # the invite grants the organization role and any workspace roles, and the
    # api applies it on the user's first sign-in
    case "${role}" in
    viewer) access_mode=READ ;;
    writer) access_mode=WRITE ;;
    admin) access_mode=ADMIN ;;
    esac
    invite_body="{\"username\":$(json_str "${email}"),\"access_mode\":\"${access_mode}\""
    if [ "${#workspaces[@]}" -gt 0 ]; then
      invite_body+=',"workspaces":['
      for ws in "${workspaces[@]}"; do
        ws_id="${ws%%:*}"
        ws_role="${role}"
        [[ "${ws}" == *:* ]] && ws_role="${ws#*:}"
        invite_body+="{\"workspace_id\":$(json_str "${ws_id}"),\"role\":\"${ws_role}\"},"
        grants+="${grants:+, }${ws_id} (${ws_role})"
      done
      invite_body="${invite_body%,}]"
    fi
    invite_body+='}'
    # same trust handling as upgrade-fga, and the token goes to curl through a
    # config on stdin so it stays off the command line
    cert="$(compose_tls_cert)"
    [ -n "${cert}" ] && curl_tls=(--cacert "${cert}")
    out="$(printf 'header = "Authorization: Bearer %s"\n' "${token}" |
      curl -sS "${curl_tls[@]}" -m 30 -K - -X POST "${api_url}/organizations/${org}/members/invite" \
        -H 'Content-Type: application/json' --data-binary "${invite_body}" \
        -w '\n%{http_code}' 2>&1)" || true
    if [ "$(tail -n1 <<<"${out}")" == '200' ]; then
      echo "[INFO] invited ${email} to organization ${org} as ${role}"
    else
      echo "[ERROR] the keycloak user was created, but the organization invite failed:" 1>&2
      print_indented "$(sed '$d' <<<"${out}")"
      echo "[ERROR] the user can sign in but has no organization access yet, retry the invite with:" 1>&2
      echo "  curl -X POST '${api_url}/organizations/${org}/members/invite' -H \"Authorization: Bearer \${DEEPLAKE_API_TOKEN}\" -H 'Content-Type: application/json' -d '${invite_body}'" 1>&2
      code=1
    fi
  fi

  echo "
user:
  login url: https://app.${base_host}
  username: ${username}
  email: ${email}"
  if [ -n "${generated}" ]; then
    echo "  password: ${password} (generated, shown only now)"
  fi
  if [ -n "${temporary}" ]; then
    echo "  password change: required on first login"
  else
    echo "  password change: not required"
  fi
  if [ -n "${org}" ]; then
    echo "  organization: ${org} as ${role}$([ "${code}" -ne 0 ] && echo ', invite failed')"
    [ -n "${grants}" ] && echo "  workspaces: ${grants}"
  fi
  echo
  return "${code}"
}

completion() {
  # prints a completion script for the given shell to stdout, the caller
  # decides whether to source it or install it to a file. the scripts do not
  # call back into dl-stack.sh or docker, the service names come straight from
  # the rendered compose file, which is 'docker compose config' output, so
  # every service is a two space indented key under 'services:'. the compose
  # path is spelled out instead of using CONFIG_DIR so the output stays valid
  # for whichever user ends up loading it, keep it in sync with CONFIG_DIR
  local shell
  shell="${1:-}"
  case "${shell}" in
  bash)
    cat <<'EOF'
# bash completion for dl-stack.sh, generated by './dl-stack.sh completion bash'
#
# load it in the current shell (or from ~/.bashrc):
#   source <(/path/to/dl-stack.sh completion bash)
# or install it for bash-completion to load on demand:
#   /path/to/dl-stack.sh completion bash > ~/.local/share/bash-completion/completions/dl-stack.sh

_dl_stack_services() {
  local file="${HOME}/.local/deeplake/compose.yaml"
  [ -f "${file}" ] || return 0
  awk '/^services:/ { in_services = 1; next }
       /^[^ ]/ { in_services = 0 }
       in_services && /^  [^ ]/ { sub(/:.*/, ""); print $1 }' "${file}"
}

_dl_stack() {
  local cur cmd
  cur="${COMP_WORDS[COMP_CWORD]}"
  cmd="${COMP_WORDS[1]}"
  COMPREPLY=()
  if [ "${COMP_CWORD}" -eq 1 ]; then
    mapfile -t COMPREPLY < <(compgen -W 'setup start stop restart status creds add-user scale set-tag upgrade-fga destroy pull completion' -- "${cur}")
    return
  fi
  case "${cmd}" in
  start | stop | restart | status)
    mapfile -t COMPREPLY < <(compgen -W "$(_dl_stack_services)" -- "${cur}")
    ;;
  set-tag)
    if [ "${COMP_CWORD}" -eq 2 ]; then
      mapfile -t COMPREPLY < <(compgen -W "$(_dl_stack_services)" -- "${cur}")
    fi
    ;;
  add-user)
    case "${COMP_WORDS[COMP_CWORD - 1]}" in
    --role)
      mapfile -t COMPREPLY < <(compgen -W 'viewer writer admin' -- "${cur}")
      ;;
    --email | --username | --first-name | --last-name | --password | --org | --workspace | --token) ;;
    *)
      mapfile -t COMPREPLY < <(compgen -W '--email --username --first-name --last-name --password --temporary --no-temporary --org --role --workspace --token' -- "${cur}")
      ;;
    esac
    ;;
  destroy)
    if [ "${COMP_CWORD}" -eq 2 ]; then
      mapfile -t COMPREPLY < <(compgen -W '--force' -- "${cur}")
    fi
    ;;
  completion)
    if [ "${COMP_CWORD}" -eq 2 ]; then
      mapfile -t COMPREPLY < <(compgen -W 'bash zsh' -- "${cur}")
    fi
    ;;
  esac
}

# bash falls back to the basename when the command is given as a path, so this
# also covers ./dl-stack.sh and /opt/deeplake/dl-stack.sh
complete -F _dl_stack dl-stack.sh dl-stack
EOF
    ;;
  zsh)
    cat <<'EOF'
#compdef dl-stack.sh dl-stack
# zsh completion for dl-stack.sh, generated by './dl-stack.sh completion zsh'
#
# load it in the current shell (or from ~/.zshrc, after 'compinit'):
#   source <(/path/to/dl-stack.sh completion zsh)
# or install it as a function file in a directory that is on $fpath before
# 'compinit' runs, the file name has to be _dl_stack:
#   /path/to/dl-stack.sh completion zsh > ~/.zsh/completions/_dl_stack

_dl_stack_services() {
  local file="${HOME}/.local/deeplake/compose.yaml"
  [[ -f "${file}" ]] || return 0
  awk '/^services:/ { in_services = 1; next }
       /^[^ ]/ { in_services = 0 }
       in_services && /^  [^ ]/ { sub(/:.*/, ""); print $1 }' "${file}"
}

_dl_stack() {
  local -a commands services options shells
  commands=(
    'setup:configure the stack, re-running this reinitializes it'
    'start:start the stack or only the given services'
    'stop:stop the stack or only the given services'
    'restart:stop and start the stack or only the given services'
    'status:show the state and health of the services'
    'creds:print the credentials and endpoints setup printed'
    'add-user:create a keycloak login and optionally invite it to an organization'
    'scale:change how many deeplake-stateless nodes the stack runs'
    'set-tag:point a service at a different image tag'
    'upgrade-fga:write the shipped OpenFGA model and point the services at it'
    'destroy:stop the stack and remove all docker volumes'
    'pull:pull the container images the stack runs'
    'completion:print shell completion for bash or zsh'
  )
  if (( CURRENT == 2 )); then
    _describe -t commands 'dl-stack command' commands
    return
  fi
  case "${words[2]}" in
  start | stop | restart | status)
    services=(${(f)"$(_dl_stack_services)"})
    _describe -t services 'service' services
    ;;
  set-tag)
    if (( CURRENT == 3 )); then
      services=(${(f)"$(_dl_stack_services)"})
      _describe -t services 'service' services
    fi
    ;;
  add-user)
    case "${words[CURRENT-1]}" in
    --role)
      options=('viewer' 'writer' 'admin')
      _describe -t roles 'role' options
      ;;
    --email | --username | --first-name | --last-name | --password | --org | --workspace | --token) ;;
    *)
      options=(
        '--email:the email address, required'
        '--username:the login name, defaults to the email'
        '--first-name:first name'
        '--last-name:last name'
        '--password:the password, generated when omitted'
        '--temporary:require a password change on first login (default)'
        '--no-temporary:keep the password as given'
        '--org:the organization id to invite the user to'
        '--role:the organization role, viewer, writer or admin'
        '--workspace:a workspace id, optionally with :viewer, :writer or :admin'
        '--token:an organization admin api token'
      )
      _describe -t options 'option' options
      ;;
    esac
    ;;
  destroy)
    options=('--force:skip the confirmation prompt')
    (( CURRENT == 3 )) && _describe -t options 'option' options
    ;;
  completion)
    shells=('bash' 'zsh')
    (( CURRENT == 3 )) && _describe -t shells 'shell' shells
    ;;
  esac
}

# when autoloaded from $fpath this file is the body of _dl_stack and has to
# run the completion, when sourced it only has to register the function
if [[ "${funcstack[1]}" == '_dl_stack' ]]; then
  _dl_stack "$@"
else
  compdef _dl_stack dl-stack.sh dl-stack
fi
EOF
    ;;
  '')
    echo "[ERROR] completion needs the shell to generate for, e.g. ./dl-stack.sh completion bash" 1>&2
    exit 1
    ;;
  *)
    echo "[ERROR] unsupported shell '${shell}', supported: bash zsh" 1>&2
    exit 1
    ;;
  esac
}

case "$1" in
start) start "${@:2}" ;;
scale) scale "${2:-}" ;;
set-tag) set_tag "${2:-}" "${3:-}" ;;
upgrade-fga) upgrade_fga ;;
stop) stop "${@:2}" ;;
restart) restart "${@:2}" ;;
status) status "${@:2}" ;;
creds) creds ;;
add-user) add_user "${@:2}" ;;
setup) setup ;;
destroy) destroy "${2:-}" ;;
pull) pull ;;
completion) completion "${2:-}" ;;
*)
  if [ -z "$1" ]; then
    echo "[ERROR] command not specified"
  else
    echo "[ERROR] wrong command: ${1}"
  fi
  help
  exit 1
  ;;
esac

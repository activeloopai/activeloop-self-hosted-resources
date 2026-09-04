#!/usr/bin/env bash

CONFIG_DIR="$HOME/.local/deeplake"
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
        }
      },
      "metadata": {
        "relations": {
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
  destroy: stop the stack and remove all docker volumes, e.g. wipe the data
           pass --force to skip the confirmation prompt (for non-interactive use)
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

gen_vars() {
  local answer
  STORAGE_ACCESS_KEY=AKIA
  STORAGE_ACCESS_KEY+="$(cat /dev/urandom | tr -dc '[:upper:]' | head -c 15)"
  STORAGE_SECRET_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9/' | head -c 40)"
  STORAGE_JWT_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9/' | head -c 64)"
  STORAGE_USER_PASSWORD="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20)"
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
    STORAGE_ACCESS_KEY \
    STORAGE_SECRET_KEY \
    STORAGE_JWT_KEY \
    STORAGE_USER_PASSWORD \
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

}

print_vars() {
  echo "
credentials:
  storage s3 access key: ${STORAGE_ACCESS_KEY}
  storage s3 secret key: ${STORAGE_SECRET_KEY}
  storage ui username: alarik
  storage ui password: ${STORAGE_USER_PASSWORD}
  keycloak admin username: admin
  keycloak admin password: ${KEYCLOAK_ADMIN_PASSWORD}
endpoints:
  deeplake ui: https://app.${BASE_HOST}
  deeplake api: https://api.${BASE_HOST}
  storage ui: https://storage.${BASE_HOST}
  storage api: https://storage-api.${BASE_HOST}
  keycloak: https://kc.${BASE_HOST}
"
}

ensure_compose_file() {
  local answer
  mkdir -p "${CONFIG_DIR}"
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    cat ./compose.yaml | envsubst >"${CONFIG_DIR}/compose.yaml"
    chmod 600 "${CONFIG_DIR}/compose.yaml"
    FRESH_SETUP=1
  fi
  if [ "${TLS_METHOD}" == 'http01' ]; then
    sed -i '/\/certs/d' "${CONFIG_DIR}/compose.yaml"
    sed -i '/caddy_public_key/d' "${CONFIG_DIR}/compose.yaml"
    sed -i '/caddy_private_key/d' "${CONFIG_DIR}/compose.yaml"
  else
    if [ -z "${TLS_CERT_PATH}" ]; then
      read -rp "tls certificate file path: " TLS_CERT_PATH
    fi
    if [ -z "${TLS_KEY_PATH}" ]; then
      read -rp "tls key file path: " TLS_KEY_PATH
    fi
    sed -i "s|caddy_public_key_file|${TLS_CERT_PATH}|" "${CONFIG_DIR}/compose.yaml"
    sed -i "s|caddy_private_key_file|${TLS_KEY_PATH}|" "${CONFIG_DIR}/compose.yaml"
  fi
}

setup() {
  local fga_url i
  check_prerequisites
  if [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    echo "[WARNING] compose file alredy exists at ${CONFIG_DIR}/compose.yaml, for fresh setup run ./dl-stack.sh destroy first, otherwise edit existing compose file directly"
    exit 1
  fi
  gen_vars
  ensure_compose_file
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d openfga
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d caddy
  fga_url="https://openfga.$BASE_HOST"
  echo "[INFO] waiting for OpenFGA at ${fga_url}"
  i=0
  until curl -sf -m 5 "${fga_url}/healthz" >/dev/null 2>&1; do
    i=$((i + 1))
    [ $i -gt 60 ] && {
      echo "openfga not ready after 5m"
      exit 1
    }
    sleep 5
  done
  STORE=$(curl -sf -m 30 -X POST "${fga_url}/stores" \
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
  MODEL=$(curl -sf -m 60 -X POST "${fga_url}/stores/$STORE/authorization-models" \
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
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d deeplake-setup
  stop
  if [ "${FRESH_SETUP}" -eq 1 ]; then
    print_vars
  fi
}

start() {
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    setup
  fi
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d deeplake-setup || docker compose -f "${CONFIG_DIR}/compose.yaml" up -d deeplake-setup
  docker compose -f "${CONFIG_DIR}/compose.yaml" up -d
}

stop() {
  docker compose -f "${CONFIG_DIR}/compose.yaml" down
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
  rm -f "${CONFIG_DIR}/compose.yaml"
}

case "$1" in
start) start ;;
stop) stop ;;
setup) setup ;;
destroy) destroy "${2:-}" ;;
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

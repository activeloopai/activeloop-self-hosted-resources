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

set STORAGE_TYPE to pick the object storage backend non-interactively,
supported values: ${SUPPORTED_STORAGE_TYPES[*]}. When unset, setup asks for it.
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
  # prompt_var <variable> <prompt> <plain|secret> [regex]
  # keeps whatever the environment already provided, otherwise asks until the
  # answer is non-empty and matches the regex
  local name="$1" prompt="$2" mode="$3" pattern="${4:-}" value
  value="${!name}"
  while :; do
    if [ -n "${value}" ]; then
      if [ -z "${pattern}" ] || [[ "${value}" =~ ${pattern} ]]; then
        break
      fi
      echo "[WARNING] ${name} must match ${pattern}" 1>&2
      value=''
    fi
    if [ "${mode}" == 'secret' ]; then
      if ! read -rsp "${prompt}: " value; then
        echo
        echo "[ERROR] no interactive terminal, set ${name} in the environment" 1>&2
        exit 1
      fi
      echo
    else
      if ! read -rp "${prompt}: " value; then
        echo "[ERROR] no interactive terminal, set ${name} in the environment" 1>&2
        exit 1
      fi
    fi
  done
  printf -v "${name}" '%s' "${value}"
}

# storage backends
#
# every entry of SUPPORTED_STORAGE_TYPES is backed by a compose template named
# compose-<type>.yaml in this repository, and may implement these optional hooks:
#   gen_vars_<type>   generate/prompt and export the storage specific variables
#   print_vars_<type> print the storage credentials and endpoints
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
  # them exported
  prompt_var DEEPLAKE_ROOT_PATH 'deeplake root path (s3://<bucket>/<prefix>)' plain '^s3://'
  prompt_var AWS_REGION 'aws region' plain
  prompt_var AWS_ACCESS_KEY_ID 'aws access key id' plain
  prompt_var AWS_SECRET_ACCESS_KEY 'aws secret access key' secret
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
  aws access key id: ${AWS_ACCESS_KEY_ID}
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

print_vars_azure() {
  echo "
storage:
  deeplake root path: ${DEEPLAKE_ROOT_PATH}
  azure tenant id: ${AZURE_TENANT_ID}
  azure client id: ${AZURE_CLIENT_ID}
"
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
  storage_hook gen_vars
}

print_vars() {
  echo "
credentials:
  keycloak admin username: admin
  keycloak admin password: ${KEYCLOAK_ADMIN_PASSWORD}
endpoints:
  deeplake ui: https://app.${BASE_HOST}
  deeplake api: https://api.${BASE_HOST}
  keycloak: https://kc.${BASE_HOST}
"
  storage_hook print_vars
}

ensure_compose_file() {
  local answer template
  mkdir -p "${CONFIG_DIR}"
  if ! [ -f "${CONFIG_DIR}/compose.yaml" ]; then
    if ! template="$(curl -fsSL "${COMPOSE_BASE_URL}/compose-${STORAGE_TYPE}.yaml")"; then
      echo "[ERROR] failed to fetch compose template for storage type '${STORAGE_TYPE}'"
      exit 1
    fi
    printf '%s\n' "${template}" | envsubst >"${CONFIG_DIR}/compose.yaml"
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
  select_storage_type
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

{{/*
Protocol mapper that puts the identity provider alias of a brokered login
(Google, the customer's SSO) into the tokens. Keycloak stores it as the
user session note `identity_provider`; password logins have no such note, so
the claim is absent for them. deeplake-ui reads the claim (OIDC_IDP_CLAIM) to
tell SSO users from password users and to hide "Change password" from SSO users.

Shared by the realm import (keycloak-realm.yaml) and the reconcile Job
(keycloak-realm-reconcile.yaml), so both apply the same definition. Returns
JSON; callers `fromJson` it.
*/}}
{{- define "deeplake.keycloakIdpMapper" -}}
{{- $claim := .Values.global.auth.oidc.idpClaim | default "identity_provider" -}}
{{- dict
      "name" "identity-provider"
      "protocol" "openid-connect"
      "protocolMapper" "oidc-usersessionmodel-note-mapper"
      "config" (dict
        "user.session.note" "identity_provider"
        "claim.name" $claim
        "jsonType.label" "String"
        "id.token.claim" "true"
        "access.token.claim" "true"
        "userinfo.token.claim" "true"
        "introspection.token.claim" "true")
    | toJson -}}
{{- end -}}

{{- define "deeplake-api.env" -}}
{{- $g := .Values.global -}}
{{- $v := .Values -}}
- name: ENVIRONMENT
  value: production
- name: PORT
  value: "8080"
- name: LOG_LEVEL
  value: {{ $v.logLevel | quote }}
- name: LOG_FORMAT
  value: {{ $v.logFormat | quote }}

# --- Control-plane database ---
- name: DB_HOST
  value: {{ required "global.database.host is required" $g.database.host | quote }}
- name: DB_PORT
  value: {{ $g.database.port | quote }}
- name: DB_NAME
  value: {{ $g.database.name | quote }}
- name: DB_USER
  value: {{ $g.database.user | quote }}
- name: DB_SSLMODE
  value: {{ $g.database.sslMode | quote }}

# --- pg-deeplake data plane (reached through pg-proxy) ---
- name: SHARED_DLPG_HOST
  value: {{ printf "%s-pg-proxy.%s.svc.cluster.local" (include "deeplake.fullname" .) .Release.Namespace | quote }}
- name: SHARED_DLPG_PORT
  value: "5432"
- name: SHARED_DLPG_USER
  value: "postgres"
# Same secret the pool uses, so the two can never drift apart.
- name: SHARED_DLPG_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ required "global.secrets.dlpg is required" $g.secrets.dlpg }}
      key: password
- name: SHARED_DLPG_SSLMODE
  value: "require"
{{- if $g.dlpgExternalHost }}
# Address SDK clients get back from /db-credentials. Must be resolvable from
# outside the cluster; the in-cluster service DNS above is not.
- name: SHARED_DLPG_EXTERNAL_HOST
  value: {{ $g.dlpgExternalHost | quote }}
{{- end }}

# --- Object storage ---
- name: DEEPLAKE_ROOT_PATH
  value: {{ $g.storage.rootPath | quote }}
- name: DEEPLAKE_ROOT_DIR
  value: {{ $g.storage.rootPath | quote }}

# --- OIDC ---
- name: OIDC_ISSUER
  value: {{ include "deeplake.issuerUrl" . | quote }}
- name: OIDC_AUDIENCE
  value: {{ $g.auth.audience | quote }}
- name: OIDC_CLI_CLIENT_ID
  value: {{ $g.auth.cliClientId | quote }}
- name: JWT_DECODE_LEEWAY
  value: "30"
{{- if $g.auth.disableDiscovery }}
# Air-gapped: never call the discovery endpoint. Every endpoint below must be
# supplied explicitly or startup fails.
- name: OIDC_DISABLE_DISCOVERY
  value: "true"
- name: OIDC_JWKS_URL
  value: {{ required "global.auth.jwksUrl is required when discovery is disabled" $g.auth.jwksUrl | quote }}
- name: OIDC_DEVICE_AUTH_URL
  value: {{ required "global.auth.deviceAuthUrl is required when discovery is disabled" $g.auth.deviceAuthUrl | quote }}
- name: OIDC_TOKEN_URL
  value: {{ required "global.auth.tokenUrl is required when discovery is disabled" $g.auth.tokenUrl | quote }}
{{- end }}

# --- Authorization ---
- name: FGA_API_URL
  value: {{ include "deeplake.openfgaUrl" . | quote }}
- name: FGA_AUTHN_METHOD
  value: {{ ternary "api_token" "none" (ne $g.openfga.tokenSecret "") | quote }}
{{- with $g.openfga.tokenSecret }}
- name: FGA_API_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ . }}
      key: token
{{- end }}


- name: APP_BASE_URL
  value: {{ printf "http%s://%s" (ternary "s" "" $g.ingress.tls.enabled) $g.domain | quote }}
- name: CORS_ALLOW_ORIGINS
  value: {{ printf "http%s://%s" (ternary "s" "" $g.ingress.tls.enabled) $g.domain | quote }}

# --- Billing ---
- name: BILLING_ENABLED
  value: {{ $v.features.billing.enabled | quote }}

# --- Email ---
{{- if $v.features.email.enabled }}
- name: EMAIL_FROM_ADDRESS
  value: {{ $v.features.email.fromAddress | quote }}
{{- end }}

# --- Telemetry ---
- name: OTEL_ENABLED
  value: {{ $v.features.telemetry.enabled | quote }}
{{- if $v.features.telemetry.enabled }}
- name: OTEL_SERVICE_NAME
  value: "deeplake-api"
- name: OTEL_EXPORTER_TYPE
  value: "otlp"
- name: OTEL_EXPORTER_ENDPOINT
  value: {{ required "telemetry.endpoint is required when telemetry is enabled" $v.features.telemetry.endpoint | quote }}
- name: OTEL_SAMPLE_RATE
  value: {{ $v.features.telemetry.sampleRate | quote }}
{{- end }}

# --- Embedding ---
{{- if $v.embedding.url }}
- name: EMBEDDING_PROVIDER
  value: {{ $v.embedding.provider | quote }}
- name: EMBEDDING_HTTP_URL
  value: {{ $v.embedding.url | quote }}
- name: EMBEDDING_MODEL
  value: {{ $v.embedding.model | quote }}
- name: EMBEDDING_TIMEOUT
  value: {{ $v.embedding.timeout | quote }}
{{- end }}

# --- Vision / OCR ---
{{- if $v.vision.enabled }}
- name: VISION_PROVIDER
  value: {{ $v.vision.provider | quote }}
{{- with $v.vision.model }}
- name: VISION_MODEL
  value: {{ . | quote }}
{{- end }}
{{- with $v.vision.baseUrl }}
- name: VISION_BASE_URL
  value: {{ . | quote }}
{{- end }}
- name: VISION_TIMEOUT
  value: {{ $v.vision.timeout | quote }}
{{- end }}

# --- Public tables (optional read-only showcase workspace) ---
{{- if $v.publicTables.enabled }}
- name: PUBLIC_TABLES_ORG_ID
  value: {{ required "publicTables.orgId is required when public tables are enabled" $v.publicTables.orgId | quote }}
- name: PUBLIC_TABLES_WORKSPACE_ID
  value: {{ $v.publicTables.workspaceId | quote }}
- name: PUBLIC_TABLES_RATE_LIMIT_RPM
  value: {{ $v.publicTables.rateLimitRPM | quote }}
- name: PUBLIC_TABLES_QUERY_TIMEOUT
  value: {{ $v.publicTables.queryTimeout | quote }}
{{- end }}

{{- with $v.extraEnv }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "deeplake-api.fgaEnv" -}}
{{- $g := .Values.global -}}
{{- if $g.openfga.bootstrap.enabled }}
- name: FGA_STORE_ID
  valueFrom:
    secretKeyRef:
      name: {{ $g.openfga.bootstrap.secretName }}
      key: FGA_STORE_ID
- name: FGA_AUTHORIZATION_MODEL_ID
  valueFrom:
    secretKeyRef:
      name: {{ $g.openfga.bootstrap.secretName }}
      key: FGA_AUTHORIZATION_MODEL_ID
{{- end }}
{{- end -}}

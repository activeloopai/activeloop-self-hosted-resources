
{{- define "deeplake.fullname" -}}
{{- if .Values.global.fullnameOverride -}}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "deeplake.componentName" -}}
{{- printf "%s-%s" (include "deeplake.fullname" .ctx) .component | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "deeplake.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/name: deeplake
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: deeplake-platform
{{- end -}}

{{- define "deeplake.selectorLabels" -}}
app.kubernetes.io/name: deeplake
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{- define "deeplake.image" -}}
{{- $registry := .image.registry | default .ctx.Values.global.imageRegistry -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry .image.repository (.image.tag | default .ctx.Chart.AppVersion) -}}
{{- else -}}
{{- printf "%s:%s" .image.repository (.image.tag | default .ctx.Chart.AppVersion) -}}
{{- end -}}
{{- end -}}

{{- define "deeplake.imagePullSecrets" -}}
{{- $secrets := .Values.global.imagePullSecrets | default list -}}
{{- if $secrets }}
imagePullSecrets:
{{- range $secrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "deeplake.serviceAccountName" -}}
{{- .Values.global.serviceAccount.name | default (printf "%s-workload" (include "deeplake.fullname" .)) -}}
{{- end -}}

{{- define "deeplake.keycloakHost" -}}
{{- $kc := .Values.global.keycloak -}}
{{- $kc.hostname | default (printf "kc.%s" .Values.global.domain) -}}
{{- end -}}

{{/* Resolved OIDC issuer; an explicit value always wins. */}}
{{- define "deeplake.issuerUrl" -}}
{{- if .Values.global.auth.issuerUrl -}}
{{- .Values.global.auth.issuerUrl -}}
{{- else if .Values.global.keycloak.enabled -}}
{{- $scheme := ternary "https" "http" .Values.global.ingress.tls.enabled -}}
{{- printf "%s://%s/realms/%s" $scheme (include "deeplake.keycloakHost" .) .Values.global.keycloak.realm -}}
{{- else -}}
{{- fail "global.auth.issuerUrl is required (or set global.keycloak.enabled=true to bundle one)" -}}
{{- end -}}
{{- end -}}

{{- define "deeplake.openfgaUrl" -}}
{{- if .Values.global.openfga.url -}}
{{- .Values.global.openfga.url -}}
{{- else -}}
{{- printf "http://%s-openfga:8080" .Release.Name -}}
{{- end -}}
{{- end -}}

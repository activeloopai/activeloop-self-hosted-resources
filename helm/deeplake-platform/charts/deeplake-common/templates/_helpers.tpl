{{/*
Shared naming / labelling helpers.

Every template here takes the ROOT context (`.`) unless documented otherwise,
so subcharts can call them directly — Helm merges all template definitions into
one namespace across the umbrella and its subcharts.
*/}}

{{- define "deeplake.fullname" -}}
{{- if .Values.global.fullnameOverride -}}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Component name: deeplake.componentName (dict "ctx" $ "component" "api-server")
*/}}
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

{{/*
Selector labels: deeplake.selectorLabels (dict "ctx" $ "component" "api-server")
Immutable across upgrades — never add anything version-dependent here.
*/}}
{{- define "deeplake.selectorLabels" -}}
app.kubernetes.io/name: deeplake
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{/*
Image reference: deeplake.image (dict "ctx" $ "image" .Values.image)

Resolves registry in this order: per-image registry -> global.imageRegistry.
A single global override is what makes air-gapped mirroring one flag:
  --set global.imageRegistry=myregistry.azurecr.io
*/}}
{{- define "deeplake.image" -}}
{{- $registry := .image.registry | default .ctx.Values.global.imageRegistry -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry .image.repository (.image.tag | default .ctx.Chart.AppVersion) -}}
{{- else -}}
{{- printf "%s:%s" .image.repository (.image.tag | default .ctx.Chart.AppVersion) -}}
{{- end -}}
{{- end -}}

{{/*
Pull secrets. Takes root context. Merges global and per-component lists.
*/}}
{{- define "deeplake.imagePullSecrets" -}}
{{- $secrets := .Values.global.imagePullSecrets | default list -}}
{{- if $secrets }}
imagePullSecrets:
{{- range $secrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Service account name shared by every workload that needs cloud storage access.
Created once, at the umbrella level, and referenced by name everywhere else —
this is the fix for the duplicate-ServiceAccount problem that shows up when
several subcharts each declare `serviceAccount.create: true`.
*/}}
{{- define "deeplake.serviceAccountName" -}}
{{- .Values.global.serviceAccount.name | default (printf "%s-workload" (include "deeplake.fullname" .)) -}}
{{- end -}}

{{- define "deeplake.openfgaUrl" -}}
{{- if .Values.global.openfga.url -}}
{{- .Values.global.openfga.url -}}
{{- else -}}
{{- printf "http://%s-openfga:8080" .Release.Name -}}
{{- end -}}
{{- end -}}

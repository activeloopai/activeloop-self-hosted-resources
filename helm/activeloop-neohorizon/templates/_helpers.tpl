{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "activeloop-neohorizon.name" -}}
{{ include "chart.name" . }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "activeloop-neohorizon.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "activeloop-neohorizon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "activeloop-neohorizon.labels" -}}
helm.sh/chart: {{ include "activeloop-neohorizon.chart" . }}
{{ include "activeloop-neohorizon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "activeloop-neohorizon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "activeloop-neohorizon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "activeloop-neohorizon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "activeloop-neohorizon.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Return RabbitMQ connection string */}}
{{- define "activeloop-neohorizon.rabbitmqConnection" -}}
{{- if .Values.global.config.rabbitmq_url }}
{{ .Values.global.config.rabbitmq_url }}
{{- else if .Values.rabbitmq.create }}
amqp://{{ .Values.rabbitmq.auth.username }}:{{ .Values.rabbitmq.auth.password }}@{{ .Release.Name }}-rabbitmq.{{ $.Release.Namespace }}:5672
{{- else }}
{{ fail "rabbitmq_url is required or rabbitmq.create is true" }}
{{- end }}
{{- end }}

{{/* Return PostgreSQL connection string */}}
{{- define "activeloop-neohorizon.postgresqlHost" -}}
{{- if .Values.global.config.postgres_host }}
{{ .Values.global.config.postgres_host }}
{{- else if .Values.postgresql.create }}
{{ .Release.Name }}-postgresql.{{ $.Release.Namespace }}
{{- else }}
{{ fail "postgresql_host is required or postgresql.create is true" }}
{{- end }}
{{- end }}


{{- define "deeplake.validateCloud" -}}
{{- $g := .Values.global -}}
{{- $cloud := $g.cloud -}}
{{- if not (has $cloud (list "azure" "aws" "gcp" "s3")) -}}
{{- fail (printf "global.cloud must be one of azure|aws|gcp|s3, got %q" $cloud) -}}
{{- end -}}
{{- $root := $g.storage.rootPath -}}
{{- if not $root -}}
{{- fail "global.storage.rootPath is required (az://account/container/prefix, s3://bucket/prefix, or gs://bucket/prefix)" -}}
{{- end -}}
{{- $expected := dict "azure" "az://" "aws" "s3://" "gcp" "gs://" "s3" "s3://" -}}
{{- $prefix := get $expected $cloud -}}
{{- if not (hasPrefix $prefix $root) -}}
{{- fail (printf "global.storage.rootPath %q does not match global.cloud=%s (expected prefix %q)" $root $cloud $prefix) -}}
{{- end -}}
{{- if eq $cloud "s3" -}}
{{- $s3 := $g.storage.s3 -}}
{{- if not (or (hasPrefix "http://" $s3.endpoint) (hasPrefix "https://" $s3.endpoint)) -}}
{{- fail (printf "global.storage.s3.endpoint must be an http(s) URL when global.cloud=s3, got %q" $s3.endpoint) -}}
{{- end -}}
{{- if not $s3.credentialsSecret -}}
{{- fail "global.storage.s3.credentialsSecret is required when global.cloud=s3 (Secret keys: accessKeyId, secretAccessKey)" -}}
{{- end -}}
{{- if $g.workloadIdentity.enabled -}}
{{- fail "global.workloadIdentity.enabled must be false when global.cloud=s3; the endpoint is reached with the static key in global.storage.s3.credentialsSecret" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "deeplake.serviceAccountAnnotations" -}}
{{- $wi := .Values.global.workloadIdentity -}}
{{- if $wi.enabled -}}
{{- if eq .Values.global.cloud "azure" }}
azure.workload.identity/client-id: {{ required "global.workloadIdentity.azure.clientId is required when workload identity is enabled on Azure" $wi.azure.clientId | quote }}
azure.workload.identity/tenant-id: {{ required "global.workloadIdentity.azure.tenantId is required when workload identity is enabled on Azure" $wi.azure.tenantId | quote }}
{{- else if eq .Values.global.cloud "aws" }}
eks.amazonaws.com/role-arn: {{ required "global.workloadIdentity.aws.roleArn is required when workload identity is enabled on AWS" $wi.aws.roleArn | quote }}
{{- else if eq .Values.global.cloud "gcp" }}
iam.gke.io/gcp-service-account: {{ required "global.workloadIdentity.gcp.serviceAccount is required when workload identity is enabled on GCP" $wi.gcp.serviceAccount | quote }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "deeplake.workloadIdentityPodLabels" -}}
{{- if and .Values.global.workloadIdentity.enabled (eq .Values.global.cloud "azure") }}
azure.workload.identity/use: "true"
{{- end }}
{{- end -}}

{{/*
Static credentials for an S3-compatible endpoint (global.cloud=s3). The
pg-deeplake pods read the AWS SDK names; deeplake-api reads the S3_* names.
Both render empty on the other clouds, where storage access comes from the
workload identity.
*/}}
{{- define "deeplake.s3StorageEnv" -}}
{{- $g := .Values.global -}}
{{- if eq $g.cloud "s3" }}
- name: AWS_ENDPOINT_URL
  value: {{ $g.storage.s3.endpoint | quote }}
- name: AWS_REGION
  value: {{ $g.storage.s3.region | quote }}
- name: AWS_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ $g.storage.s3.credentialsSecret }}
      key: accessKeyId
- name: AWS_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $g.storage.s3.credentialsSecret }}
      key: secretAccessKey
{{- end }}
{{- end -}}

{{- define "deeplake.s3ApiEnv" -}}
{{- $g := .Values.global -}}
{{- if eq $g.cloud "s3" }}
- name: S3_ENDPOINT_URL
  value: {{ $g.storage.s3.endpoint | quote }}
- name: S3_REGION
  value: {{ $g.storage.s3.region | quote }}
- name: S3_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ $g.storage.s3.credentialsSecret }}
      key: accessKeyId
- name: S3_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ $g.storage.s3.credentialsSecret }}
      key: secretAccessKey
{{- end }}
{{- end -}}

{{- define "deeplake.ingressClassName" -}}
{{- if .Values.global.ingress.className -}}
{{- .Values.global.ingress.className -}}
{{- else if eq .Values.global.cloud "aws" -}}
alb
{{- else if eq .Values.global.cloud "azure" -}}
webapprouting.kubernetes.azure.com
{{- else if eq .Values.global.cloud "s3" -}}
{{- fail "global.ingress.className is required when global.cloud=s3: there is no default ingress controller for a generic cluster" -}}
{{- else -}}
gce
{{- end -}}
{{- end -}}

{{/* Empty means the cluster's default StorageClass; postgres.yaml omits the field then. */}}
{{- define "deeplake.storageClassName" -}}
{{- if .Values.global.storageClass -}}
{{- .Values.global.storageClass -}}
{{- else if eq .Values.global.cloud "aws" -}}
gp3
{{- else if eq .Values.global.cloud "azure" -}}
managed-csi
{{- else if eq .Values.global.cloud "gcp" -}}
pd-balanced
{{- end -}}
{{- end -}}

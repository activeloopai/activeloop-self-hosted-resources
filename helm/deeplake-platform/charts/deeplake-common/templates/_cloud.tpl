
{{- define "deeplake.validateCloud" -}}
{{- $cloud := .Values.global.cloud -}}
{{- if not (has $cloud (list "azure" "aws" "gcp")) -}}
{{- fail (printf "global.cloud must be one of azure|aws|gcp, got %q" $cloud) -}}
{{- end -}}
{{- $root := .Values.global.storage.rootPath -}}
{{- if not $root -}}
{{- fail "global.storage.rootPath is required (az://account/container/prefix, s3://bucket/prefix, or gs://bucket/prefix)" -}}
{{- end -}}
{{- $expected := dict "azure" "az://" "aws" "s3://" "gcp" "gs://" -}}
{{- $prefix := get $expected $cloud -}}
{{- if not (hasPrefix $prefix $root) -}}
{{- fail (printf "global.storage.rootPath %q does not match global.cloud=%s (expected prefix %q)" $root $cloud $prefix) -}}
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

{{- define "deeplake.ingressClassName" -}}
{{- if .Values.global.ingress.className -}}
{{- .Values.global.ingress.className -}}
{{- else if eq .Values.global.cloud "aws" -}}
alb
{{- else if eq .Values.global.cloud "azure" -}}
webapprouting.kubernetes.azure.com
{{- else -}}
gce
{{- end -}}
{{- end -}}

{{- define "deeplake.storageClassName" -}}
{{- if .Values.global.storageClass -}}
{{- .Values.global.storageClass -}}
{{- else if eq .Values.global.cloud "aws" -}}
gp3
{{- else if eq .Values.global.cloud "azure" -}}
managed-csi
{{- else -}}
pd-balanced
{{- end -}}
{{- end -}}

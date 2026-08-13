{{/*
Cloud portability layer.

The entire AWS/Azure/GCP delta for this platform lives in this file plus the
values-<cloud>.yaml overlays. Resist adding per-cloud subcharts — the
difference is four things: workload-identity wiring, object-storage URL scheme,
ingress/cert plumbing, and StorageClass names.
*/}}

{{/*
Fail fast on an unsupported or unset cloud, and on a storage root that doesn't
match it. A typo'd scheme here surfaces as a confusing pg_deeplake runtime
error hours later, so it's worth catching at template time.
*/}}
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

{{/*
ServiceAccount annotations that bind the pod to a cloud identity.
Takes root context. Emits nothing when workload identity is disabled — which is
the right default for kind/minikube trials using static credentials.
*/}}
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

{{/*
Pod labels required by the cloud's identity webhook.

Azure is the only one that needs a pod-level opt-in: the AKS workload-identity
webhook only injects AZURE_CLIENT_ID / AZURE_TENANT_ID /
AZURE_FEDERATED_TOKEN_FILE into pods carrying this label. pg_deeplake's
credential chain (cpp/platform/common/storage/azure_utils.hpp) probes exactly
those three env vars to select WorkloadIdentityCredential, so without this label
the pool pods silently fall back to failing anonymous blob access.
*/}}
{{- define "deeplake.workloadIdentityPodLabels" -}}
{{- if and .Values.global.workloadIdentity.enabled (eq .Values.global.cloud "azure") }}
azure.workload.identity/use: "true"
{{- end }}
{{- end -}}

{{/*
Ingress class. Explicit value wins; otherwise a sane per-cloud default.
*/}}
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

{{/*
Storage class for any PVC the platform creates. The stateless pool uses
emptyDir by design, so today this only affects bundled Postgres/Keycloak.
*/}}
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

# Activeloop Neohorizon

Activeloop NeoHorizon Deployment Chart

**Homepage:** <https://activeloop.ai>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Activeloop SRE | <sre@activeloop.dev> |  |

## Source Code

* <https://github.com/activeloopai/activeloop-helm-charts>

## Requirements

Kubernetes: `>= 1.24.0-0`

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.7.16 |
| oci://registry-1.docker.io/bitnamicharts | rabbitmq | 16.0.10 |

## Deployment

### Add helm repo

```bash
helm repo add activeloop https://charts.activeloop.ai
helm repo update activeloop
```

### Install neohoriozn

```bash
helm upgrade -i -n activeloop neohorizon activeloop/activeloop-neohorizon
```

## Parameters

### Global parameters

| Name                      | Description                                              | Value                          |
| ------------------------- | -------------------------------------------------------- | ------------------------------ |
| `global.image.registry`   | Global Docker image registry                             | `quay.io`                      |
| `global.image.repository` | Global Docker image repository                           | `activeloopai/neohorizon-main` |
| `global.image.tag`        | Global Docker image tag (immutable tags are recommended) | `v0.1.2`                       |
| `global.nodeSelector`     | Global node selector for all pods                        | `{}`                           |
| `global.tolerations`      | Global tolerations for all pods                          | `[]`                           |
| `global.affinity`         | Global affinity for all pods                             | `{}`                           |

### Global configuration parameters

| Name                                | Description                                                                              | Value |
| ----------------------------------- | ---------------------------------------------------------------------------------------- | ----- |
| `global.config.postgres_database`   | PostgreSQL database name (default: see `postgresql.auth.database`)                       | `""`  |
| `global.config.postgres_host`       | PostgreSQL host address (default: see `postgresql.primary.persistence.host`)             | `""`  |
| `global.config.postgres_password`   | PostgreSQL password (default: see `postgresql.auth.password`)                            | `""`  |
| `global.config.postgres_port`       | PostgreSQL port (default: see `postgresql.primary.persistence.port`)                     | `""`  |
| `global.config.postgres_user`       | PostgreSQL username (default: see `postgresql.auth.username`)                            | `""`  |
| `global.config.rabbitmq_url`        | RabbitMQ connection URL, default is generated from rabbitmq.auth.url                     | `""`  |
| `global.config.visual_model_url`    | Visual model service URL, default is generated from models.visual_model if enabled       | `""`  |
| `global.config.embedding_model_url` | Embedding model service URL, default is generated from models.embedding_model if enabled | `""`  |
| `global.config.api_key`             | API key for api authentication                                                           | `""`  |
| `global.config.gemini_api_key`      | Gemini API key for gemini model                                                          | `""`  |
| `global.config.openai_api_key`      | OpenAI API key for openai model                                                          | `""`  |

### Ingress parameters

| Name                  | Description                                                                 | Value             |
| --------------------- | --------------------------------------------------------------------------- | ----------------- |
| `ingress.enabled`     | Enable ingress record generation for the application                        | `false`           |
| `ingress.className`   | IngressClass that will be used to implement the Ingress                     | `""`              |
| `ingress.annotations` | Additional custom annotations for the ingress record                        | `{}`              |
| `ingress.labels`      | Additional custom labels for the ingress record                             | `{}`              |
| `ingress.host`        | Default host for the ingress record                                         | `api.example.com` |
| `ingress.tls`         | Enable TLS configuration for the hostname defined at ingress.host parameter | `[]`              |

### API Services parameters

| Name                                                  | Description                                           | Value                           |
| ----------------------------------------------------- | ----------------------------------------------------- | ------------------------------- |
| `apis.lightweight_service.enabled`                    | Enable lightweight service deployment                 | `true`                          |
| `apis.lightweight_service.replicas`                   | Number of lightweight service replicas to deploy      | `2`                             |
| `apis.lightweight_service.port`                       | Port for the lightweight service                      | `8000`                          |
| `apis.lightweight_service.annotations`                | Annotations for the lightweight service deployment    | `{}`                            |
| `apis.lightweight_service.strategy.type`              | Deployment strategy type                              | `RollingUpdate`                 |
| `apis.lightweight_service.scaling`                    | Horizontal Pod Autoscaler configuration               | `{}`                            |
| `apis.lightweight_service.command`                    | Override default container command                    | `[]`                            |
| `apis.lightweight_service.args`                       | Override default container args                       | `[]`                            |
| `apis.lightweight_service.service.type`               | Kubernetes service type                               | `ClusterIP`                     |
| `apis.lightweight_service.service.port`               | Service port                                          | `80`                            |
| `apis.lightweight_service.env`                        | Environment variables for the lightweight service     | `{}`                            |
| `apis.lightweight_service.envFrom`                    | Environment variables from ConfigMap/Secret           | `[]`                            |
| `apis.lightweight_service.serviceAccount.create`      | Specifies whether a service account should be created | `false`                         |
| `apis.lightweight_service.serviceAccount.name`        | The name of the service account to use                | `""`                            |
| `apis.lightweight_service.serviceAccount.labels`      | Additional labels for the service account             | `{}`                            |
| `apis.lightweight_service.serviceAccount.annotations` | Additional annotations for the service account        | `{}`                            |
| `apis.lightweight_service.enableHealthProbes`         | Enable health probes for the lightweight service      | `true`                          |
| `apis.lightweight_service.nodeSelector`               | Node selector for lightweight service pods            | `{}`                            |
| `apis.lightweight_service.tolerations`                | Tolerations for lightweight service pods              | `[]`                            |
| `apis.lightweight_service.affinity`                   | Affinity for lightweight service pods                 | `{}`                            |
| `apis.files_service.enabled`                          | Enable files service deployment                       | `true`                          |
| `apis.files_service.replicas`                         | Number of files service replicas to deploy            | `3`                             |
| `apis.files_service.port`                             | Port for the files service                            | `8000`                          |
| `apis.files_service.strategy.type`                    | Deployment strategy type                              | `RollingUpdate`                 |
| `apis.files_service.scaling`                          | Horizontal Pod Autoscaler configuration               | `{}`                            |
| `apis.files_service.image.repository`                 | Docker image repository for files service             | `activeloopai/neohorizon-files` |
| `apis.files_service.command`                          | Override default container command                    | `[]`                            |
| `apis.files_service.args`                             | Override default container args                       | `[]`                            |
| `apis.files_service.service.type`                     | Kubernetes service type                               | `ClusterIP`                     |
| `apis.files_service.service.port`                     | Service port                                          | `80`                            |
| `apis.files_service.env`                              | Environment variables for the files service           | `{}`                            |
| `apis.files_service.envFrom`                          | Environment variables from ConfigMap/Secret           | `[]`                            |
| `apis.files_service.serviceAccount.create`            | Specifies whether a service account should be created | `false`                         |
| `apis.files_service.serviceAccount.name`              | The name of the service account to use                | `""`                            |
| `apis.files_service.serviceAccount.labels`            | Additional labels for the service account             | `{}`                            |
| `apis.files_service.serviceAccount.annotations`       | Additional annotations for the service account        | `{}`                            |
| `apis.files_service.enableHealthProbes`               | Enable health probes for the files service            | `true`                          |
| `apis.files_service.nodeSelector`                     | Node selector for files service pods                  | `{}`                            |
| `apis.files_service.tolerations`                      | Tolerations for files service pods                    | `[]`                            |
| `apis.files_service.affinity`                         | Affinity for files service pods                       | `{}`                            |

### Workers parameters

| Name                                                           | Description                                              | Value           |
| -------------------------------------------------------------- | -------------------------------------------------------- | --------------- |
| `workers.vector_search_worker.enabled`                         | Enable vector search worker deployment                   | `true`          |
| `workers.vector_search_worker.replicas`                        | Number of vector search worker replicas to deploy        | `2`             |
| `workers.vector_search_worker.annotations`                     | Annotations for the vector search worker deployment      | `{}`            |
| `workers.vector_search_worker.strategy.type`                   | Deployment strategy type                                 | `RollingUpdate` |
| `workers.vector_search_worker.scaling`                         | Horizontal Pod Autoscaler configuration                  | `{}`            |
| `workers.vector_search_worker.env`                             | Environment variables for the vector search worker       | `{}`            |
| `workers.vector_search_worker.envFrom`                         | Environment variables from ConfigMap/Secret              | `[]`            |
| `workers.vector_search_worker.serviceAccount.create`           | Specifies whether a service account should be created    | `false`         |
| `workers.vector_search_worker.serviceAccount.name`             | The name of the service account to use                   | `""`            |
| `workers.vector_search_worker.serviceAccount.labels`           | Additional labels for the service account                | `{}`            |
| `workers.vector_search_worker.serviceAccount.annotations`      | Additional annotations for the service account           | `{}`            |
| `workers.vector_search_worker.enableHealthProbes`              | Enable health probes for the vector search worker        | `true`          |
| `workers.vector_search_worker.nodeSelector`                    | Node selector for vector search worker pods              | `{}`            |
| `workers.vector_search_worker.tolerations`                     | Tolerations for vector search worker pods                | `[]`            |
| `workers.vector_search_worker.affinity`                        | Affinity for vector search worker pods                   | `{}`            |
| `workers.file_processor_worker.enabled`                        | Enable file processor worker deployment                  | `true`          |
| `workers.file_processor_worker.replicas`                       | Number of file processor worker replicas to deploy       | `1`             |
| `workers.file_processor_worker.annotations`                    | Annotations for the file processor worker deployment     | `{}`            |
| `workers.file_processor_worker.strategy.type`                  | Deployment strategy type                                 | `RollingUpdate` |
| `workers.file_processor_worker.scaling`                        | Horizontal Pod Autoscaler configuration                  | `{}`            |
| `workers.file_processor_worker.env`                            | Environment variables for the file processor worker      | `{}`            |
| `workers.file_processor_worker.envFrom`                        | Environment variables from ConfigMap/Secret              | `[]`            |
| `workers.file_processor_worker.serviceAccount.create`          | Specifies whether a service account should be created    | `false`         |
| `workers.file_processor_worker.serviceAccount.name`            | The name of the service account to use                   | `""`            |
| `workers.file_processor_worker.serviceAccount.labels`          | Additional labels for the service account                | `{}`            |
| `workers.file_processor_worker.serviceAccount.annotations`     | Additional annotations for the service account           | `{}`            |
| `workers.file_processor_worker.enableHealthProbes`             | Enable health probes for the file processor worker       | `true`          |
| `workers.file_processor_worker.nodeSelector`                   | Node selector for file processor worker pods             | `{}`            |
| `workers.file_processor_worker.tolerations`                    | Tolerations for file processor worker pods               | `[]`            |
| `workers.file_processor_worker.affinity`                       | Affinity for file processor worker pods                  | `{}`            |
| `workers.embedding_worker.enabled`                             | Enable embedding worker deployment                       | `true`          |
| `workers.embedding_worker.replicas`                            | Number of embedding worker replicas to deploy            | `1`             |
| `workers.embedding_worker.annotations`                         | Annotations for the embedding worker deployment          | `{}`            |
| `workers.embedding_worker.strategy.type`                       | Deployment strategy type                                 | `RollingUpdate` |
| `workers.embedding_worker.scaling`                             | Horizontal Pod Autoscaler configuration                  | `{}`            |
| `workers.embedding_worker.env`                                 | Environment variables for the embedding worker           | `{}`            |
| `workers.embedding_worker.envFrom`                             | Environment variables from ConfigMap/Secret              | `[]`            |
| `workers.embedding_worker.serviceAccount.create`               | Specifies whether a service account should be created    | `false`         |
| `workers.embedding_worker.serviceAccount.name`                 | The name of the service account to use                   | `""`            |
| `workers.embedding_worker.serviceAccount.labels`               | Additional labels for the service account                | `{}`            |
| `workers.embedding_worker.serviceAccount.annotations`          | Additional annotations for the service account           | `{}`            |
| `workers.embedding_worker.enableHealthProbes`                  | Enable health probes for the embedding worker            | `true`          |
| `workers.embedding_worker.nodeSelector`                        | Node selector for embedding worker pods                  | `{}`            |
| `workers.embedding_worker.tolerations`                         | Tolerations for embedding worker pods                    | `[]`            |
| `workers.embedding_worker.affinity`                            | Affinity for embedding worker pods                       | `{}`            |
| `workers.summary_generation_worker.enabled`                    | Enable summary generation worker deployment              | `true`          |
| `workers.summary_generation_worker.replicas`                   | Number of summary generation worker replicas to deploy   | `1`             |
| `workers.summary_generation_worker.annotations`                | Annotations for the summary generation worker deployment | `{}`            |
| `workers.summary_generation_worker.strategy.type`              | Deployment strategy type                                 | `RollingUpdate` |
| `workers.summary_generation_worker.scaling`                    | Horizontal Pod Autoscaler configuration                  | `{}`            |
| `workers.summary_generation_worker.env`                        | Environment variables for the summary generation worker  | `{}`            |
| `workers.summary_generation_worker.envFrom`                    | Environment variables from ConfigMap/Secret              | `[]`            |
| `workers.summary_generation_worker.serviceAccount.create`      | Specifies whether a service account should be created    | `false`         |
| `workers.summary_generation_worker.serviceAccount.name`        | The name of the service account to use                   | `""`            |
| `workers.summary_generation_worker.serviceAccount.labels`      | Additional labels for the service account                | `{}`            |
| `workers.summary_generation_worker.serviceAccount.annotations` | Additional annotations for the service account           | `{}`            |
| `workers.summary_generation_worker.enableHealthProbes`         | Enable health probes for the summary generation worker   | `true`          |
| `workers.summary_generation_worker.nodeSelector`               | Node selector for summary generation worker pods         | `{}`            |
| `workers.summary_generation_worker.tolerations`                | Tolerations for summary generation worker pods           | `[]`            |
| `workers.summary_generation_worker.affinity`                   | Affinity for summary generation worker pods              | `{}`            |

### Models parameters

| Name                                                | Description                                             | Value                       |
| --------------------------------------------------- | ------------------------------------------------------- | --------------------------- |
| `models.visual_model.enabled`                       | Enable visual model deployment                          | `true`                      |
| `models.visual_model.replicas`                      | Number of visual model replicas to deploy               | `1`                         |
| `models.visual_model.port`                          | Port for the visual model service                       | `8000`                      |
| `models.visual_model.strategy.type`                 | Deployment strategy type                                | `RollingUpdate`             |
| `models.visual_model.scaling`                       | Horizontal Pod Autoscaler configuration                 | `{}`                        |
| `models.visual_model.image.repository`              | Docker image repository for visual model                | `activeloopai/visual-model` |
| `models.visual_model.service.type`                  | Kubernetes service type                                 | `ClusterIP`                 |
| `models.visual_model.service.port`                  | Service port                                            | `80`                        |
| `models.visual_model.ingress.enabled`               | Enable ingress record generation for visual model       | `false`                     |
| `models.visual_model.ingress.className`             | IngressClass that will be used to implement the Ingress | `""`                        |
| `models.visual_model.ingress.annotations`           | Additional custom annotations for the ingress record    | `{}`                        |
| `models.visual_model.ingress.host`                  | Default host for the ingress record                     | `api.example.com`           |
| `models.visual_model.ingress.tls`                   | Enable TLS configuration for the hostname               | `[]`                        |
| `models.visual_model.env`                           | Environment variables for the visual model              | `{}`                        |
| `models.visual_model.envFrom`                       | Environment variables from ConfigMap/Secret             | `[]`                        |
| `models.visual_model.serviceAccount.create`         | Specifies whether a service account should be created   | `false`                     |
| `models.visual_model.serviceAccount.name`           | The name of the service account to use                  | `""`                        |
| `models.visual_model.serviceAccount.labels`         | Additional labels for the service account               | `{}`                        |
| `models.visual_model.serviceAccount.annotations`    | Additional annotations for the service account          | `{}`                        |
| `models.visual_model.enableHealthProbes`            | Enable health probes for the visual model               | `false`                     |
| `models.visual_model.nodeSelector`                  | Node selector for visual model pods                     | `{}`                        |
| `models.visual_model.tolerations`                   | Tolerations for visual model pods                       | `[]`                        |
| `models.visual_model.affinity`                      | Affinity for visual model pods                          | `{}`                        |
| `models.embedding_model.enabled`                    | Enable embedding model deployment                       | `true`                      |
| `models.embedding_model.replicas`                   | Number of embedding model replicas to deploy            | `1`                         |
| `models.embedding_model.port`                       | Port for the embedding model service                    | `8000`                      |
| `models.embedding_model.strategy.type`              | Deployment strategy type                                | `RollingUpdate`             |
| `models.embedding_model.scaling`                    | Horizontal Pod Autoscaler configuration                 | `{}`                        |
| `models.embedding_model.image.repository`           | Docker image repository for embedding model             | `activeloopai/visual-model` |
| `models.embedding_model.service.type`               | Kubernetes service type                                 | `ClusterIP`                 |
| `models.embedding_model.service.port`               | Service port                                            | `80`                        |
| `models.embedding_model.ingress.enabled`            | Enable ingress record generation for embedding model    | `false`                     |
| `models.embedding_model.ingress.className`          | IngressClass that will be used to implement the Ingress | `""`                        |
| `models.embedding_model.ingress.annotations`        | Additional custom annotations for the ingress record    | `{}`                        |
| `models.embedding_model.ingress.host`               | Default host for the ingress record                     | `api.example.com`           |
| `models.embedding_model.ingress.tls`                | Enable TLS configuration for the hostname               | `[]`                        |
| `models.embedding_model.env`                        | Environment variables for the embedding model           | `{}`                        |
| `models.embedding_model.envFrom`                    | Environment variables from ConfigMap/Secret             | `[]`                        |
| `models.embedding_model.serviceAccount.create`      | Specifies whether a service account should be created   | `false`                     |
| `models.embedding_model.serviceAccount.name`        | The name of the service account to use                  | `""`                        |
| `models.embedding_model.serviceAccount.labels`      | Additional labels for the service account               | `{}`                        |
| `models.embedding_model.serviceAccount.annotations` | Additional annotations for the service account          | `{}`                        |
| `models.embedding_model.enableHealthProbes`         | Enable health probes for the embedding model            | `false`                     |
| `models.embedding_model.nodeSelector`               | Node selector for embedding model pods                  | `{}`                        |
| `models.embedding_model.tolerations`                | Tolerations for embedding model pods                    | `[]`                        |
| `models.embedding_model.affinity`                   | Affinity for embedding model pods                       | `{}`                        |

### PostgreSQL parameters

| Name                                     | Description                                        | Value        |
| ---------------------------------------- | -------------------------------------------------- | ------------ |
| `postgresql.create`                      | Whether to create a PostgreSQL instance            | `true`       |
| `postgresql.auth.username`               | PostgreSQL username                                | `postgres`   |
| `postgresql.auth.password`               | PostgreSQL password                                | `postgres`   |
| `postgresql.auth.database`               | PostgreSQL database name                           | `neohorizon` |
| `postgresql.primary.persistence.enabled` | Enable PostgreSQL persistence using PVC            | `true`       |
| `postgresql.primary.persistence.size`    | PVC Storage Request for PostgreSQL data volume     | `10Gi`       |
| `postgresql.resources`                   | CPU/Memory resource requests/limits for PostgreSQL | `{}`         |

### RabbitMQ parameters

| Name                           | Description                                      | Value      |
| ------------------------------ | ------------------------------------------------ | ---------- |
| `rabbitmq.create`              | Whether to create a RabbitMQ instance            | `true`     |
| `rabbitmq.auth.username`       | RabbitMQ username                                | `user`     |
| `rabbitmq.auth.password`       | RabbitMQ password                                | `password` |
| `rabbitmq.persistence.enabled` | Enable RabbitMQ persistence using PVC            | `true`     |
| `rabbitmq.persistence.size`    | PVC Storage Request for RabbitMQ data volume     | `20Gi`     |
| `rabbitmq.resources`           | CPU/Memory resource requests/limits for RabbitMQ | `{}`       |

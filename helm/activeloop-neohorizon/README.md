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
| `global.image.tag`        | Global Docker image tag (immutable tags are recommended) | `v2.5.2`                       |
| `global.nodeSelector`     | Global node selector for all pods                        | `{}`                           |
| `global.tolerations`      | Global tolerations for all pods                          | `[]`                           |
| `global.affinity`         | Global affinity for all pods                             | `{}`                           |

### Global configuration parameters [Description of the parameters](https://github.com/activeloopai/activeloop-self-hosted-resources/blob/main/README.md#Parameters)

| Name                                                            | Description                                                                                                                                                            | Value        |
| --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `global.config.postgres_database`                               | PostgreSQL database name (default: see `postgresql.auth.database`)                                                                                                     | `neohorizon` |
| `global.config.postgres_host`                                   | PostgreSQL host address (default: see `postgresql.primary.persistence.host`)                                                                                           | `""`         |
| `global.config.postgres_password`                               | PostgreSQL password (default: see `postgresql.auth.password`)                                                                                                          | `postgres`   |
| `global.config.postgres_port`                                   | PostgreSQL port (default: see `postgresql.primary.persistence.port`)                                                                                                   | `5432`       |
| `global.config.postgres_user`                                   | PostgreSQL username (default: see `postgresql.auth.username`)                                                                                                          | `postgres`   |
| `global.config.deeplake_creds`                                  | Deep Lake credentials, for details refer to [README](https://github.com/activeloopai/activeloop-self-hosted-resources?tab=readme-ov-file#deeplake-storage-credentials) | `""`         |
| `global.config.deeplake_root_dir`                               | Deep Lake storage root, like s3://my-bucket/my-dir                                                                                                                     | `""`         |
| `global.config.rabbitmq_url`                                    | RabbitMQ connection URL, default is generated from rabbitmq.auth.url                                                                                                   | `""`         |
| `global.config.al_api_token`                                    | API key for api authentication                                                                                                                                         | `""`         |
| `global.config.gemini_api_key`                                  | Gemini API key for gemini model                                                                                                                                        | `""`         |
| `global.config.openai_api_key`                                  | OpenAI API key for openai model                                                                                                                                        | `""`         |
| `global.config.text_image__matrix_of_embeddings__ingestion_url` | Text image matrix of embeddings ingestion model URL                                                                                                                    | `""`         |
| `global.config.text_image__matrix_of_embeddings__query_url`     | Text image matrix of embeddings query model URL                                                                                                                        | `""`         |
| `global.config.text_image__embedding__ingestion_url`            | Text image embedding ingestion model URL                                                                                                                               | `""`         |
| `global.config.text_image__embedding__query_url`                | Text image embedding query model URL                                                                                                                                   | `""`         |
| `global.config.text__embedding__ingestion_url`                  | Text embedding ingestion model URL                                                                                                                                     | `""`         |
| `global.config.text__embedding__query_url`                      | Text embedding query model URL                                                                                                                                         | `""`         |
| `global.config.text__summary_embedding__query_url`              | summary embedding query model URL                                                                                                                                      | `""`         |
| `global.config.text__summary_embedding__ingestion_url`          | summary embedding ingestion model URL                                                                                                                                  | `""`         |
| `global.config.gotenberg_endpoint`                              | Gotenberg endpoint, disabled by default (needed for office files processing)                                                                                           | `""`         |
| `global.config.chunkr_api_key`                                  | Chunkr API key, disabled by default (needed for xlsx files processing)                                                                                                 | `""`         |
| `global.useExistingSecret`                                      | Use existing secret for the config, if set config will be ignored                                                                                                      | `""`         |

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

| Name                                                    | Description                                           | Value                           |
| ------------------------------------------------------- | ----------------------------------------------------- | ------------------------------- |
| `apis.lightweight_service.enabled`                      | Enable lightweight service deployment                 | `true`                          |
| `apis.lightweight_service.replicas`                     | Number of lightweight service replicas to deploy      | `1`                             |
| `apis.lightweight_service.port`                         | Port for the lightweight service                      | `8000`                          |
| `apis.lightweight_service.annotations`                  | Annotations for the lightweight service deployment    | `{}`                            |
| `apis.lightweight_service.strategy.type`                | Deployment strategy type                              | `RollingUpdate`                 |
| `apis.lightweight_service.scaling`                      | Horizontal Pod Autoscaler configuration               | `{}`                            |
| `apis.lightweight_service.command`                      | Override default container command                    | `[]`                            |
| `apis.lightweight_service.args`                         | Override default container args                       | `[]`                            |
| `apis.lightweight_service.service.type`                 | Kubernetes service type                               | `ClusterIP`                     |
| `apis.lightweight_service.service.port`                 | Service port                                          | `80`                            |
| `apis.lightweight_service.env`                          | Environment variables for the lightweight service     | `{}`                            |
| `apis.lightweight_service.envFrom`                      | Environment variables from ConfigMap/Secret           | `[]`                            |
| `apis.lightweight_service.serviceAccount.create`        | Specifies whether a service account should be created | `false`                         |
| `apis.lightweight_service.serviceAccount.name`          | The name of the service account to use                | `""`                            |
| `apis.lightweight_service.serviceAccount.labels`        | Additional labels for the service account             | `{}`                            |
| `apis.lightweight_service.serviceAccount.annotations`   | Additional annotations for the service account        | `{}`                            |
| `apis.lightweight_service.enableHealthProbes`           | Enable health probes for the lightweight service      | `true`                          |
| `apis.lightweight_service.nodeSelector`                 | Node selector for lightweight service pods            | `{}`                            |
| `apis.lightweight_service.tolerations`                  | Tolerations for lightweight service pods              | `[]`                            |
| `apis.lightweight_service.affinity`                     | Affinity for lightweight service pods                 | `{}`                            |
| `apis.files_service.enabled`                            | Enable files service deployment                       | `true`                          |
| `apis.files_service.replicas`                           | Number of files service replicas to deploy            | `1`                             |
| `apis.files_service.port`                               | Port for the files service                            | `8000`                          |
| `apis.files_service.strategy.type`                      | Deployment strategy type                              | `RollingUpdate`                 |
| `apis.files_service.scaling`                            | Horizontal Pod Autoscaler configuration               | `{}`                            |
| `apis.files_service.image.repository`                   | Docker image repository for files service             | `activeloopai/neohorizon-files` |
| `apis.files_service.command`                            | Override default container command                    | `[]`                            |
| `apis.files_service.args`                               | Override default container args                       | `[]`                            |
| `apis.files_service.service.type`                       | Kubernetes service type                               | `ClusterIP`                     |
| `apis.files_service.service.port`                       | Service port                                          | `80`                            |
| `apis.files_service.env`                                | Environment variables for the files service           | `{}`                            |
| `apis.files_service.envFrom`                            | Environment variables from ConfigMap/Secret           | `[]`                            |
| `apis.files_service.serviceAccount.create`              | Specifies whether a service account should be created | `false`                         |
| `apis.files_service.serviceAccount.name`                | The name of the service account to use                | `""`                            |
| `apis.files_service.serviceAccount.labels`              | Additional labels for the service account             | `{}`                            |
| `apis.files_service.serviceAccount.annotations`         | Additional annotations for the service account        | `{}`                            |
| `apis.files_service.enableHealthProbes`                 | Enable health probes for the files service            | `true`                          |
| `apis.files_service.nodeSelector`                       | Node selector for files service pods                  | `{}`                            |
| `apis.files_service.tolerations`                        | Tolerations for files service pods                    | `[]`                            |
| `apis.files_service.affinity`                           | Affinity for files service pods                       | `{}`                            |
| `apis.nango_webhook_service.enabled`                    | Enable nango webhook service deployment               | `false`                         |
| `apis.nango_webhook_service.replicas`                   | Number of files service replicas to deploy            | `1`                             |
| `apis.nango_webhook_service.port`                       | Port for the nango webhook service                    | `8080`                          |
| `apis.nango_webhook_service.strategy.type`              | Deployment strategy type                              | `RollingUpdate`                 |
| `apis.nango_webhook_service.scaling`                    | Horizontal Pod Autoscaler configuration               | `{}`                            |
| `apis.nango_webhook_service.image.repository`           | Docker image repository for files service             | `activeloopai/neohorizon-nango` |
| `apis.nango_webhook_service.command`                    | Override default container command                    | `[]`                            |
| `apis.nango_webhook_service.args`                       | Override default container args                       | `[]`                            |
| `apis.nango_webhook_service.service.type`               | Kubernetes service type                               | `ClusterIP`                     |
| `apis.nango_webhook_service.service.port`               | Service port                                          | `80`                            |
| `apis.nango_webhook_service.env`                        | Environment variables for the files service           | `{}`                            |
| `apis.nango_webhook_service.envFrom`                    | Environment variables from ConfigMap/Secret           | `[]`                            |
| `apis.nango_webhook_service.serviceAccount.create`      | Specifies whether a service account should be created | `false`                         |
| `apis.nango_webhook_service.serviceAccount.name`        | The name of the service account to use                | `""`                            |
| `apis.nango_webhook_service.serviceAccount.labels`      | Additional labels for the service account             | `{}`                            |
| `apis.nango_webhook_service.serviceAccount.annotations` | Additional annotations for the service account        | `{}`                            |
| `apis.nango_webhook_service.enableHealthProbes`         | Enable health probes for the files service            | `true`                          |
| `apis.nango_webhook_service.nodeSelector`               | Node selector for files service pods                  | `{}`                            |
| `apis.nango_webhook_service.tolerations`                | Tolerations for files service pods                    | `[]`                            |
| `apis.nango_webhook_service.affinity`                   | Affinity for files service pods                       | `{}`                            |

### Workers parameters

| Name                                                           | Description                                              | Value           |
| -------------------------------------------------------------- | -------------------------------------------------------- | --------------- |
| `workers.vector_search_worker.enabled`                         | Enable vector search worker deployment                   | `true`          |
| `workers.vector_search_worker.replicas`                        | Number of vector search worker replicas to deploy        | `1`             |
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
| `workers.file_status_worker.enabled`                           | Enable summary generation worker deployment              | `true`          |
| `workers.file_status_worker.replicas`                          | Number of summary generation worker replicas to deploy   | `1`             |
| `workers.file_status_worker.annotations`                       | Annotations for the summary generation worker deployment | `{}`            |
| `workers.file_status_worker.strategy.type`                     | Deployment strategy type                                 | `RollingUpdate` |
| `workers.file_status_worker.scaling`                           | Horizontal Pod Autoscaler configuration                  | `{}`            |
| `workers.file_status_worker.env`                               | Environment variables for the summary generation worker  | `{}`            |
| `workers.file_status_worker.envFrom`                           | Environment variables from ConfigMap/Secret              | `[]`            |
| `workers.file_status_worker.serviceAccount.create`             | Specifies whether a service account should be created    | `false`         |
| `workers.file_status_worker.serviceAccount.name`               | The name of the service account to use                   | `""`            |
| `workers.file_status_worker.serviceAccount.labels`             | Additional labels for the service account                | `{}`            |
| `workers.file_status_worker.serviceAccount.annotations`        | Additional annotations for the service account           | `{}`            |
| `workers.file_status_worker.enableHealthProbes`                | Enable health probes for the summary generation worker   | `true`          |
| `workers.file_status_worker.nodeSelector`                      | Node selector for summary generation worker pods         | `{}`            |
| `workers.file_status_worker.tolerations`                       | Tolerations for summary generation worker pods           | `[]`            |
| `workers.file_status_worker.affinity`                          | Affinity for summary generation worker pods              | `{}`            |
| `workers.skywell_worker.enabled`                               | Enable summary generation worker deployment              | `true`          |
| `workers.skywell_worker.replicas`                              | Number of summary generation worker replicas to deploy   | `1`             |
| `workers.skywell_worker.annotations`                           | Annotations for the summary generation worker deployment | `{}`            |
| `workers.skywell_worker.strategy.type`                         | Deployment strategy type                                 | `RollingUpdate` |
| `workers.skywell_worker.scaling`                               | Horizontal Pod Autoscaler configuration                  | `{}`            |
| `workers.skywell_worker.env`                                   | Environment variables for the summary generation worker  | `{}`            |
| `workers.skywell_worker.envFrom`                               | Environment variables from ConfigMap/Secret              | `[]`            |
| `workers.skywell_worker.serviceAccount.create`                 | Specifies whether a service account should be created    | `false`         |
| `workers.skywell_worker.serviceAccount.name`                   | The name of the service account to use                   | `""`            |
| `workers.skywell_worker.serviceAccount.labels`                 | Additional labels for the service account                | `{}`            |
| `workers.skywell_worker.serviceAccount.annotations`            | Additional annotations for the service account           | `{}`            |
| `workers.skywell_worker.enableHealthProbes`                    | Enable health probes for the summary generation worker   | `true`          |
| `workers.skywell_worker.nodeSelector`                          | Node selector for summary generation worker pods         | `{}`            |
| `workers.skywell_worker.tolerations`                           | Tolerations for summary generation worker pods           | `[]`            |
| `workers.skywell_worker.affinity`                              | Affinity for summary generation worker pods              | `{}`            |

### Models parameters

| Name                                   | Description                                             | Value                                   |
| -------------------------------------- | ------------------------------------------------------- | --------------------------------------- |
| `models[0].name`                       | Model name for the visual model                         | `models`                                |
| `models[0].load_models`                | List of models to load                                  | `["colnomic"]`                          |
| `models[0].replicas`                   | Number of visual model replicas to deploy               | `1`                                     |
| `models[0].port`                       | Port for the visual model service                       | `8000`                                  |
| `models[0].strategy.type`              | Deployment strategy type                                | `RollingUpdate`                         |
| `models[0].scaling`                    | Horizontal Pod Autoscaler configuration                 | `{}`                                    |
| `models[0].image.repository`           | Docker image repository for visual model                | `activeloopai/neohorizon-models-triton` |
| `models[0].service.type`               | Kubernetes service type                                 | `ClusterIP`                             |
| `models[0].service.port`               | Service port                                            | `80`                                    |
| `models[0].ingress.enabled`            | Enable ingress record generation for visual model       | `false`                                 |
| `models[0].ingress.className`          | IngressClass that will be used to implement the Ingress | `""`                                    |
| `models[0].ingress.annotations`        | Additional custom annotations for the ingress record    | `{}`                                    |
| `models[0].ingress.host`               | Default host for the ingress record                     | `api.example.com`                       |
| `models[0].ingress.tls`                | Enable TLS configuration for the hostname               | `[]`                                    |
| `models[0].env`                        | Environment variables for the visual model              | `{}`                                    |
| `models[0].envFrom`                    | Environment variables from ConfigMap/Secret             | `[]`                                    |
| `models[0].serviceAccount.create`      | Specifies whether a service account should be created   | `false`                                 |
| `models[0].serviceAccount.name`        | The name of the service account to use                  | `""`                                    |
| `models[0].serviceAccount.labels`      | Additional labels for the service account               | `{}`                                    |
| `models[0].serviceAccount.annotations` | Additional annotations for the service account          | `{}`                                    |
| `models[0].enableHealthProbes`         | Enable health probes for the visual model               | `false`                                 |
| `models[0].nodeSelector`               | Node selector for visual model pods                     | `{}`                                    |
| `models[0].tolerations`                | Tolerations for visual model pods                       | `[]`                                    |
| `models[0].affinity`                   | Affinity for visual model pods                          | `{}`                                    |

### Gotenberg parameters -- [source](https://github.com/MaikuMori/helm-charts/tree/master/charts/gotenberg)

| Name                     | Description                  | Value  |
| ------------------------ | ---------------------------- | ------ |
| `gotenberg.enabled`      | Enable Gotenberg             | `true` |
| `gotenberg.replicaCount` | Number of Gotenberg replicas | `1`    |
| `gotenberg.api.timeout`  | Gotenberg API timeout        | `120s` |

#### Parameters

| Helm Parameter                                  | Environment Variable                            | Default Value                                                | Descriptoin                                                                       |
| ----------------------------------------------- | ----------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------- |
| deeplake_creds                                  | DEEPLAKE_CREDS                                  | -                                                            | Refer to [Deeplake storage credentials](./README.md#deeplake-storage-credentials) |
| deeplake_root_dir                               | DEEPLAKE_ROOT_DIR                               | for `helm` required, for docker-compose: `/var/lib/deeplake` | storage path used by deeplake for data operations                                 |
| postgres_database                               | POSTGRES_DATABASE                               | neohorizon                                                   | virtual database name to use by app,</br> must be created beforehand              |
| postgres_host                                   | POSTGRES_HOST                                   | k8s service host of postgres dependency                      | postgres database hostname (required)                                             |
| postgres_password                               | POSTGRES_PASSWORD                               | postgres                                                     | postgres database user password                                                   |
| postgres_user                                   | POSTGRES_USER                                   | postgres                                                     | postgres database username                                                        |
| postgres_port                                   | POSTGRES_PORT                                   | 5432                                                         | postgres database port                                                            |
| rabbitmq_url                                    | RABBITMQ_URL                                    | -                                                            | rabbitmq ampq url, default will be built from dependency installation (required)  |
| al_api_token                                    | AL_API_TOKEN                                    | - (required)                                                 | api token to authenticate to deployed api                                         |
| gemini_api_key                                  | GEMINI_API_KEY                                  | -                                                            | optional to run geminy requests                                                   |
| openai_api_key                                  | OPENAI_API_KEY                                  | -                                                            | needed for query generation                                                       |
| text_image__matrix_of_embeddings__ingestion_url | TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__INGESTION_URL | -                                                            | should be full path to endpoint triton inference endpoint                         |
| text_image__matrix_of_embeddings__query_url     | TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__QUERY_URL     | -                                                            | should be full path to endpoint triton inference endpoint                         |
| text_image__embedding__ingestion_url            | TEXT_IMAGE__EMBEDDING__INGESTION_URL            | -                                                            | should be full path to endpoint triton inference endpoint                         |
| text_image__embedding__query_url                | TEXT_IMAGE__EMBEDDING__QUERY_URL                | -                                                            | should be full path to endpoint triton inference endpoint                         |
| text__embedding__ingestion_url                  | TEXT__EMBEDDING__INGESTION_URL                  | -                                                            | should be full path to endpoint triton inference endpoint                         |
| text__embedding__query_url                      | TEXT__EMBEDDING__QUERY_URL                      | -                                                            | should be full path to endpoint triton inference endpoint                         |

#### Models usage

Neohorizon works with triton served models for embedding generation both for queries and ingestion. Both helm chart and docker-compose are providing options to run models.
Here are descriptions of models:

##### Models that [Activeloop](chat.activeloop.ai) uses

- **colnomic**: can be used for ingest/retrieval of images, suggested to provide at least **16GiB** RAM and **A100** GPU
- **inf-retriever-v1**: can be used for ingest/retrieval of texts, suggested to provide at least **4GiB** RAM and **A10/L4** GPU
- **doclayout_parser**: can be used to generate images for answers, suggested to provide at least **4GiB** RAM and **A10/L4** GPU

##### Additional models we provide

- **qwen_06B**: can be used for ingest/retrieval, suggested to provide at least **4GiB** RAM and **A10/L4** GPU

> Note. Any custom models can be used with neohorizon, only requirement is that models must be served with triton and full URLs must be set in deployment environment variables.

For both helm chart and docker-compose cases default configuration should be reviewed or adjusted to use models.

- case 1: deployed only image model, then values override yaml would look like

  ```yaml
  ...
  global:
    config:
      text_image__matrix_of_embeddings__ingestion_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
      text_image__matrix_of_embeddings__query_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
      text_image__embedding__ingestion_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
      text_image__embedding__query_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
  ...
  models:
    - name: models
      load_models:
        - colnomic
  ```

- case 2: deployed all models with single deployment

  ```yaml
  ...
  global:
    config:
      text_image__matrix_of_embeddings__ingestion_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
      text_image__matrix_of_embeddings__query_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
      text_image__embedding__ingestion_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
      text_image__embedding__query_url: http://activeloop-neohorizon-models-svc/v2/models/colnomic/infer
      text__embedding__ingestion_url: http://activeloop-neohorizon-models-svc/v2/models/inf-retriever-v1/infer
      text__embedding__query_url: http://activeloop-neohorizon-models-svc/v2/models/inf-retriever-v1/infer
  ...
  models:
    - name: models
      load_models:
        - colnomic
        - inf-retriever-v1
  ```

- case 3: separate deployments for image and text

  ```yaml
  ...
  global:
    config:
      text_image__matrix_of_embeddings__ingestion_url: http://activeloop-neohorizon-colnomic-svc/v2/models/colnomic/infer
      text_image__matrix_of_embeddings__query_url: http://activeloop-neohorizon-colnomic-svc/v2/models/colnomic/infer
      text_image__embedding__ingestion_url: http://activeloop-neohorizon-colnomic-svc/v2/models/colnomic/infer
      text_image__embedding__query_url: http://activeloop-neohorizon-colnomic-svc/v2/models/colnomic/infer
      text__embedding__ingestion_url: http://activeloop-neohorizon-text-svc/v2/models/inf-retriever-v1/infer
      text__embedding__query_url: http://activeloop-neohorizon-text-svc/v2/models/inf-retriever-v1/infer
  ...
  models:
    - name: colnomic
      load_models:
        - colnomic
    ...
    - name: text
      load_models:
        - inf-retriever-v1
  ```

#### Deeplake storage credentials

In the case cloud storage is used (s3, gs, azure blob storage) and underlaying infrastructure does not provide out of the box authentication to the storage,
static credentials should be applied as enviornment variable so deeplake can do storge operations.
To give credentials to deeplake, use `DEEPLAKE_CREDS` environment variable or corresponding Cloud SKD Environment variables.
`DEEPLAKE_CREDS` must be an string serialized dictionary with cloud credentials, examples below.

- **AWS**:

    ```jsonc
    {
      "aws_access_key_id": "AWS_ACCESS_KEY_ID",
      "aws_secret_access_key": "AWS_SECRET_ACCESS_KEY",
      "aws_session_token": "AWS_SESSION_TOKEN",          // Optional
      "endpoint_url": "https://s3.customerendpoint.com", // OPTIONAL
      "region_name": "AWS_REGION"                       // OPTIONAL
    }
    ```

    or

    ```jsonc
    {
      "profile_name": "AWS_PROFILE",
      "endpoint_url": "https://s3.customerendpoint.com",  // OPTIONAL
      "region_name": "AWS_REGION"                 // OPTIONAL
    }
    ```

    or

    ```jsonc
    {
      "profile_name": "AWS_PROFILE",
      "endpoint_url": "https://s3.customerendpoint.com",  // OPTIONAL
      "region_name": "AWS_REGION"                         // OPTIONAL
    }
    ```

    or

    ```jsonc
    {
      "aws_role_arn": "AWS_ROLE_ARN",
      "aws_session_name": "session-name-for-assume-role",
      "aws_external_id": "external-id-for-assume-role",
      "endpoint_url": "https://s3.customerendpoint.com",  // OPTIONAL
      "region_name": "AWS_REGION"                         // OPTIONAL
    }

- **AZURE**:

  ```jsonc
  {
    "azure_client_id": "AZURE_CLIENT_ID",
    "azure_client_secret": "AZURE_CLIENT_SECRET",
    "azure_tenant_id": "AZURE_TENANT"
  }
  ```

  or

  ```jsonc
  {
    "sas_token": "azure-storage-sas-token"
  }
  ```

  or

  ```jsonc
  {
    "account_name": "...",
    "container_name": "...",
    "account_key": "...",
  }
  ```

- **GCP**:

  ```jsonc
  {
    "json_credentials": "SERVICE_ACCOUNT_JSON_KEY"
  }
  ```

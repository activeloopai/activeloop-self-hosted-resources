# activeloop-self-hosted-resources

## Available Deployments

- **Activeloop Neohorizon**
  - [K8s](./helm/activeloop-neohorizon/)
  - [docker-compose](./docker-compose/activeloop-neohorizon/)

### Parameters

| Helm Parameter                                  | Environment Variable                            | Default Value                           | Descriptoin                                                                      |
| ----------------------------------------------- | ----------------------------------------------- | --------------------------------------- | -------------------------------------------------------------------------------- |
| postgres_database                               | POSTGRES_DATABASE                               | neohorizon                              | virtual database name to use by app,</br> must be created beforehand             |
| postgres_host                                   | POSTGRES_HOST                                   | k8s service host of postgres dependency | postgres database hostname (required)                                            |
| postgres_password                               | POSTGRES_PASSWORD                               | postgres                                | postgres database user password                                                  |
| postgres_user                                   | POSTGRES_USER                                   | postgres                                | postgres database username                                                       |
| postgres_port                                   | POSTGRES_PORT                                   | 5432                                    | postgres database port                                                           |
| rabbitmq_url                                    | RABBITMQ_URL                                    | -                                       | rabbitmq ampq url, default will be built from dependency installation (required) |
| al_api_token          ****                          | AL_API_TOKEN                                    |                                         |                                                                                  |
| gemini_api_key                                  | GEMINI_API_KEY                                  | -                                       | optional to run geminy requests                                                  |
| openai_api_key                                  | OPENAI_API_KEY                                  | -                                       | needed for query generation                                                      |
| text_image__matrix_of_embeddings__ingestion_url | TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__INGESTION_URL | ""                                      | should be full path to endpoint triton inference endpoint                        |
| text_image__matrix_of_embeddings__query_url     | TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__QUERY_URL     | ""                                      | should be full path to endpoint triton inference endpoint                        |
| text_image__embedding__ingestion_url            | TEXT_IMAGE__EMBEDDING__INGESTION_URL            | ""                                      | should be full path to endpoint triton inference endpoint                        |
| text_image__embedding__query_url                | TEXT_IMAGE__EMBEDDING__QUERY_URL                | ""                                      | should be full path to endpoint triton inference endpoint                        |
| text__embedding__ingestion_url                  | TEXT__EMBEDDING__INGESTION_URL                  | ""                                      | should be full path to endpoint triton inference endpoint                        |
| text__embedding__query_url                      | TEXT__EMBEDDING__QUERY_URL                      | ""                                      | should be full path to endpoint triton inference endpoint                        |

### Models usage

Neohorizon works with triton served models for embedding generation both for queries and ingestion. Both helm chart and docker-compose are providing options to run models.
Here are descriptions of models:

#### Models that [Activeloop](chat.activeloop.ai) uses

- **colnomic**: can be used for ingest/retrieval of images, suggested to provide at least **16GiB** RAM and **A100** GPU
- **inf-retriever-v1**: can be used for ingest/retrieval of texts, suggested to provide at least **4GiB** RAM and **A10/L4** GPU
- **doclayout_parser**: can be used to generate images for answers, suggested to provide at least **4GiB** RAM and **A10/L4** GPU

#### Additional models we provide

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

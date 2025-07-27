# Activeloop NeoHorizon Docker Compose

This directory contains the Docker Compose configuration for deploying Activeloop NeoHorizon, a comprehensive AI-powered document processing and analysis platform.

## Overview

Activeloop NeoHorizon self-hosted docker-compose deployment with multiple configuration options for different deployment scenarios.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 8GB RAM available
- NVIDIA GPU with CUDA support (optional, for model services)

## Quick Start

1. **Clone the repository and navigate to the docker-compose directory:**

   ```bash
   cd docker-compose/activeloop-neohorizon
   ```

2. **Set required environment variables:**

   ```bash
   # API key to use as Bearer token for authentication
   export AL_API_TOKEN="neohorizon-api-key-here"
   # API key for Gemini requests
   export GEMINI_API_KEY="your-gemini-api-key-here"
   # API key for OpenAI requests
   export OPENAI_API_KEY="your-openai-api-key-here"
   ```

3. **Choose your deployment scenario:**

   ```bash
   # Start all services (recommended for full deployment)
   docker-compose up -d
   ```

   ```bash
   # Start only core services without model (for development/testing)
   docker-compose -f docker-compose.nomodel.yaml up -d
   ```

   ```bash
   # Start only the model service (for separate model deployment)
   docker-compose -f docker-compose.model.yaml up -d
   ```

   ```bash
   # Start only the application services (for production when Model, RMQ and Postgres are managed separately)
   docker-compose -f docker-compose.apps.yaml up -d
   ```

4. **Access the application:**

   - Main API: `http://localhost`
   - RabbitMQ Management: `http://localhost:15672` (username: `neohorizon`, password: `neohorizon`)
   - PostgreSQL: localhost:5432 (username: `postgres`, password: `postgres`)

## Docker Compose Files

This directory contains multiple docker-compose files for different deployment scenarios:

### `docker-compose.yaml` (Default)

- **Purpose:** Complete deployment with all services including model
- **Use case:** Full self-hosted deployment with local model inference
- **Services:** All application services, workers, model, RabbitMQ, PostgreSQL, and proxy

### `docker-compose.nomodel.yaml`

- **Purpose:** Deployment without the model service
- **Use case:** Development/testing or when using external model services
- **Services:** All application services, workers, RabbitMQ, PostgreSQL, and proxy
- **Note:** Requires external model service URLs to be configured

### `docker-compose.model.yaml`

- **Purpose:** Standalone model service deployment
- **Use case:** Separate model deployment for scaling or resource isolation
- **Services:** Only the model service with exposed ports
- **Ports:** 8000 (HTTP), 8001 (gRPC), 8002 (metrics)

### `docker-compose.apps.yaml`

- **Purpose:** Application services only
- **Use case:** Production deployment with external managed services
- **Services:** All application services and workers, proxy
- **Note:** Requires external PostgreSQL, RabbitMQ, and model service URLs

## Services

### Core API Services

#### `main-api`

- **Image:** `quay.io/activeloopai/neohorizon-main:${AL_IMAGE_TAG:-latest}`
- **Port:** 8000 (internal)
- **Purpose:** Main API service handling core application logic
- **Access:** Via nginx proxy at `/`
- **Health Check:** HTTP endpoint `/health`

#### `files-api`

- **Image:** `quay.io/activeloopai/neohorizon-files:${AL_IMAGE_TAG:-latest}`
- **Port:** 8000 (internal)
- **Purpose:** File management and processing service
- **Access:** Via nginx proxy at `/files`
- **Health Check:** HTTP endpoint `/health`

### Worker Services

#### `file_processor_worker`

- **Image:** `quay.io/activeloopai/neohorizon-main:${AL_IMAGE_TAG:-latest}`
- **Purpose:** Processes file uploads and conversions
- **Scaling:** Can be scaled horizontally

#### `embedding_worker`

- **Image:** `quay.io/activeloopai/neohorizon-main:${AL_IMAGE_TAG:-latest}`
- **Purpose:** Generates embeddings for documents
- **Scaling:** Can be scaled horizontally

#### `vector_search_worker`

- **Image:** `quay.io/activeloopai/neohorizon-main:${AL_IMAGE_TAG:-latest}`
- **Purpose:** Handles vector search operations
- **Scaling:** Can be scaled horizontally

#### `summary_generation_worker`

- **Image:** `quay.io/activeloopai/neohorizon-main:${AL_IMAGE_TAG:-latest}`
- **Purpose:** Generates document summaries
- **Scaling:** Can be scaled horizontally

### Model Services

#### `model`

- **Image:** `quay.io/activeloopai/models-triton:${AL_IMAGE_TAG_MODEL:-latest}`
- **Port:** 8000 (internal)
- **Purpose:** Provides visual and embedding model inference
- **GPU:** Requires NVIDIA GPU with CUDA support
- **Access:** Internal service, not directly exposed in main compose. Only exposed in [docker-compose.model.yaml](./docker-compose.model.yaml) via `8000/HTTP`, `8001/GRPC` and `8002/http metrics` ports
- **SHM_SIZE:** Configurable via `SHM_SIZE` environment variable, default is `8g`

### Dependency Services

#### `rabbitmq`

- **Image:** `rabbitmq:3-management`
- **Ports:**
  - 5672 (AMQP) - bound to localhost only
  - 15672 (Management UI) - bound to localhost only
- **Purpose:** Message queue for asynchronous processing
- **Credentials:** `neohorizon`/`neohorizon`
- **Persistence:** Volume `al_neohorizon_rabbitmq_data`
- **Health Check:** RabbitMQ service status

#### `postgres`

- **Image:** `postgres:17`
- **Port:** 5432 - bound to localhost only
- **Purpose:** Primary database for application data
- **Credentials:** `postgres`/`postgres`
- **Database:** `neohorizon`
- **Persistence:** Volume `al_neohorizon_postgres_data`
- **Health Check:** Database readiness check

#### `proxy`

- **Image:** `nginx:latest`
- **Port:** Configurable via `LISTEN_PORT` (default: `80`)
- **Host:** Configurable via `LISTEN_HOST` (default: `0.0.0.0`)
- **Purpose:** Reverse proxy for API services
- **Configuration:** Routes `/files` to files-api and everything else to main-api
- **File Upload:** Supports up to 512MB file uploads

## Environment Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `AL_API_TOKEN` | API Bearer authentication token, this token has special format and can be copied from Activeloop platform UI | `your-api-key` |
| `GEMINI_API_KEY` | Google Gemini API key | `your-gemini-key` |
| `OPENAI_API_KEY` | OpenAI API key | `your-openai-key` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `AL_IMAGE_TAG` | Main application image tag | `latest` |
| `AL_IMAGE_TAG_MODEL` | Model service image tag | `latest` |
| `AL_MODEL_NAME` | Which model to serve | `colnomic` |
| `LISTEN_HOST` | Host interface for nginx proxy | `0.0.0.0` |
| `LISTEN_PORT` | Port for nginx proxy | `80` |
| `SHM_SIZE` | Shared memory size for model service | `8g` |
| `POSTGRES_DATABASE` | PostgreSQL database name | `neohorizon` |
| `POSTGRES_HOST` | PostgreSQL host | `al-neohorizon-postgres` |
| `POSTGRES_PASSWORD` | PostgreSQL password | `postgres` |
| `POSTGRES_PORT` | PostgreSQL port | `5432` |
| `POSTGRES_USER` | PostgreSQL username | `postgres` |
| `RABBITMQ_URL` | RabbitMQ connection URL | `amqp://neohorizon:neohorizon@al-neohorizon-rabbitmq:5672` |
| `VISUAL_MODEL_URL` | Visual model service URL | `http://al-neohorizon-model:8000` |
| `EMBEDDING_MODEL_URL` | Embedding model service URL | `http://al-neohorizon-model:8000` |
| `DEEPLAKE_ROOT_DIR` | Storage path for the NeoHorizon data | `/var/lib/deeplake` |
| `DEEPLAKE_CREDS` | DeepLake storage credentials (optional, for cloud storage) | `N/A` |

### Model Service URLs (Required for nomodel and apps deployments)

| Variable | Description | Example |
|----------|-------------|---------|
| `TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__INGESTION_URL` | URL for text/image matrix embeddings ingestion | `http://model-service:8000/v2/models/colnomic/infer` |
| `TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__QUERY_URL` | URL for text/image matrix embeddings query | `http://model-service:8000/v2/models/colnomic/infer` |
| `TEXT_IMAGE__EMBEDDING__INGESTION_URL` | URL for text/image embedding ingestion | `http://model-service:8000/v2/models/colnomic/infer` |
| `TEXT_IMAGE__EMBEDDING__QUERY_URL` | URL for text/image embedding query | `http://model-service:8000/v2/models/colnomic/infer` |
| `TEXT__EMBEDDING__INGESTION_URL` | URL for text embedding ingestion | `http://model-service:8000/v2/models/colnomic/infer` |
| `TEXT__EMBEDDING__QUERY_URL` | URL for text embedding query | `http://model-service:8000/v2/models/colnomic/infer` |

## Configuration

### Network Configuration

- **Main deployment:** All services run on a custom bridge network `al-neohorizon-network`
- **Model-only deployment:** Uses `al-neohorizon-model-network`
- **Apps-only deployment:** Uses `al-neohorizon-apps-network`

### Volume Persistence

- **PostgreSQL Data Storage:** `al_neohorizon_postgres_data`
- **RabbitMQ Data Storage:** `al_neohorizon_rabbitmq_data`
- **DeepLake Default Data Storage:** `al_neohorizon_deeplake_data`

### Health Checks

- **Main API:** HTTP health check every 30s
- **Files API:** HTTP health check every 30s
- **RabbitMQ:** Service status check every 30s
- **PostgreSQL:** Database readiness check every 30s

## Usage Examples

For the API usage please refer to [NeoHorizon Documentation](https://docs.activeloop.ai/)

### Basic Deployment

```bash
# Set environment variables
export AL_API_TOKEN="your-api-key"
export GEMINI_API_KEY="your-gemini-key"
export OPENAI_API_KEY="your-openai-key"
```

```bash
# Start all services
docker-compose up -d
```

```bash
# Check service status
docker-compose ps
```

```bash
# View logs
docker-compose logs -f main-api
```

### Scaling Workers

```bash
# Scale specific workers
docker-compose up -d --scale file_processor_worker=3 --scale embedding_worker=2
```

### Updating Images

```bash
# Update to specific image tags
export AL_IMAGE_TAG="v0.1.5"
export AL_IMAGE_TAG_MODEL="v0.1.5"
docker-compose pull
docker-compose up -d
```

### Backup and Restore

```bash
# Backup PostgreSQL data
docker-compose exec postgres pg_dump -U postgres neohorizon > backup.sql

# Restore PostgreSQL data
docker-compose exec -T postgres psql -U postgres neohorizon < backup.sql
```

### Separate Model Deployment

```bash
# Deploy model on a separate machine
export AL_MODEL_NAME="colnomic"
export SHM_SIZE="16g"
docker-compose -f docker-compose.model.yaml up -d

# Deploy applications with external model
export TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__INGESTION_URL="http://model-host:8000/v2/models/colnomic/infer"
export TEXT_IMAGE__MATRIX_OF_EMBEDDINGS__QUERY_URL="http://model-host:8000/v2/models/colnomic/infer"
export TEXT_IMAGE__EMBEDDING__INGESTION_URL="http://model-host:8000/v2/models/colnomic/infer"
export TEXT_IMAGE__EMBEDDING__QUERY_URL="http://model-host:8000/v2/models/colnomic/infer"
export TEXT__EMBEDDING__INGESTION_URL="http://model-host:8000/v2/models/colnomic/infer"
export TEXT__EMBEDDING__QUERY_URL="http://model-host:8000/v2/models/colnomic/infer"
docker-compose -f docker-compose.nomodel.yaml up -d
```

## Troubleshooting

### Common Issues

1. **Services not starting:**

   ```bash
   # Check logs for specific service
   docker-compose logs service-name
   ```

   ```bash
   # Check all logs
   docker-compose logs
   ```

2. **Port conflicts:**
   - Ensure ports 80, 5432, 5672, and 15672 are available
   - Modify port mappings in docker-compose.yaml if needed
   - Note: PostgreSQL and RabbitMQ are bound to localhost only for security

3. **GPU issues:**
   - Ensure NVIDIA Docker runtime is installed
   - Check GPU availability: `nvidia-smi`
   - Verify CUDA compatibility
   - Increase `SHM_SIZE` if model service fails to start

4. **Memory issues:**
   - Increase Docker memory limit
   - Reduce worker replicas
   - Monitor resource usage: `docker stats`
   - Set higher `SHM_SIZE` and run docker compose restart if Model is on low memory

5. **Model service connection issues:**
   - Verify model service URLs are correct when using nomodel or apps deployments
   - Check network connectivity between services
   - Ensure model service is running and accessible

6. **External service configuration:**
   - When using apps.yaml, ensure all external service URLs are properly configured
   - Verify PostgreSQL and RabbitMQ connection strings
   - Check model service endpoints are accessible

### Logs and Debugging

```bash
# Follow logs in real-time
docker-compose logs -f
```

```bash
# Follow specific service logs
docker-compose logs -f main-api
```

```bash
# Check service configuration
docker-compose config
```

```bash
# Check specific compose file configuration
docker-compose -f docker-compose.nomodel.yaml config
```

## Security Considerations

1. **API Keys:** Store sensitive API keys in environment variables or Docker secrets
2. **Network Security:** Services communicate over internal Docker network
3. **Database Security:** Change default PostgreSQL credentials in production
4. **RabbitMQ Security:** Change default RabbitMQ credentials in production
5. **File Uploads:** Configure appropriate file size limits and validation
6. **Port Binding:** PostgreSQL and RabbitMQ are bound to localhost only for security

## Production Deployment

For production deployments, consider:

1. **Environment Variables:** Use `.env` files or external secret management
2. **Resource Limits:** Set appropriate CPU and memory limits
3. **Monitoring:** Implement logging and monitoring solutions
4. **Backup Strategy:** Regular database and volume backups
5. **SSL/TLS:** Configure HTTPS termination at the proxy level
6. **Scaling:** Use Docker Swarm or Kubernetes for orchestration
7. **Separate Services:** Consider using external managed PostgreSQL and RabbitMQ
8. **Model Deployment:** Deploy model service on dedicated GPU machines

## Support

For issues and support:

- Check the [Activeloop NeoHorizon Documentation](https://docs.activeloop.ai/)
- Review service logs for error messages
- Ensure all prerequisites are met
- Verify environment variable configuration
- Check network connectivity between services

## License

This configuration is part of the Activeloop NeoHorizon project. Please refer to the main project license for usage terms.

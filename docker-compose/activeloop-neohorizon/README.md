# Activeloop NeoHorizon Docker Compose

This directory contains the Docker Compose configuration for deploying Activeloop NeoHorizon, a comprehensive AI-powered document processing and analysis platform.

## Overview

Activeloop NeoHorizon self-hosted docker-compose deployment:

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

3. **Start the services:**

   ```bash
   # Start all services (recommended for full deployment)
   docker-compose up -d
   ```

   ```bash
   # Start only core services without model (for development/testing)
   docker-compose up -d main-api files-api files_worker embedding_worker vector_search_worker rabbitmq postgres proxy
   ```

   ```bash
   # Start only the model service (for separate model deployment)
   docker-compose up -d model
   ```

   ```bash
    # Start only the application services (for production when Model, RMQ and Postgres are managed separately)
   ```

4. **Access the application:**

   - Main API: `http://localhost`
   - RabbitMQ Management: `http://localhost:15672` (username: `neohorizon`, password: `neohorizon`)
   - PostgreSQL: localhost:5432 (username: `postgres`, password: `postgres`)

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

#### `files_worker`

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

### Model Services

#### `model`

- **Image:** `quay.io/activeloopai/visual-model:${AL_IMAGE_TAG_MODEL:-latest}`
- **Port:** 8000 (internal)
- **Purpose:** Provides visual and embedding model inference
- **GPU:** Requires NVIDIA GPU with CUDA support
- **Access:** Internal service, not directly exposed. Only exposed in [docker-compose.model.yaml](./docker-compose.yaml) via `8000/HTTP`, `8001/GRPC` and `8002/http metrics` ports
- **SHM_SIZE:** Configurable via `SHM_SIZE` environment variable, default is `8g`

### Dependency Services

#### `rabbitmq`

- **Image:** `rabbitmq:3-management`
- **Ports:**
  - 5672 (AMQP)
  - 15672 (Management UI)
- **Purpose:** Message queue for asynchronous processing
- **Credentials:** `neohorizon`/`neohorizon`
- **Persistence:** Volume `al_neohorizon_rabbitmq_data`
- **Health Check:** RabbitMQ service status

#### `postgres`

- **Image:** `postgres:17`
- **Port:** 5432
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

## Configuration

### Network Configuration

All services run on a custom bridge network `al-neohorizon-network` for secure inter-service communication.

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
docker-compose up -d --scale files_worker=3 --scale embedding_worker=2
```

### Updating Images

```bash
# Update to specific image tags
export AL_IMAGE_TAG="v0.1.3"
export AL_IMAGE_TAG_MODEL="v0.1.3"
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

3. **GPU issues:**
   - Ensure NVIDIA Docker runtime is installed
   - Check GPU availability: `nvidia-smi`
   - Verify CUDA compatibility

4. **Memory issues:**
   - Increase Docker memory limit
   - Reduce worker replicas
   - Monitor resource usage: `docker stats`
   - Set higher `SHM_SIZE` and run docker compose restart if Model is on low memory

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

## Security Considerations

1. **API Keys:** Store sensitive API keys in environment variables or Docker secrets
2. **Network Security:** Services communicate over internal Docker network
3. **Database Security:** Change default PostgreSQL credentials in production
4. **RabbitMQ Security:** Change default RabbitMQ credentials in production
5. **File Uploads:** Configure appropriate file size limits and validation

## Production Deployment

For production deployments, consider:

1. **Environment Variables:** Use `.env` files or external secret management
2. **Resource Limits:** Set appropriate CPU and memory limits
3. **Monitoring:** Implement logging and monitoring solutions
4. **Backup Strategy:** Regular database and volume backups
5. **SSL/TLS:** Configure HTTPS termination at the proxy level
6. **Scaling:** Use Docker Swarm or Kubernetes for orchestration

## Support

For issues and support:

- Check the [Activeloop NeoHorizon Documentation](https://docs.activeloop.ai/)
- Review service logs for error messages
- Ensure all prerequisites are met
- Verify environment variable configuration

## License

This configuration is part of the Activeloop NeoHorizon project. Please refer to the main project license for usage terms.
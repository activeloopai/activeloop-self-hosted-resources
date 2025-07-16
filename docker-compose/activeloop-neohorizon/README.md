# Activeloop NeoHorizon Docker Compose

This directory contains the Docker Compose configuration for deploying Activeloop NeoHorizon, a comprehensive AI-powered document processing and analysis platform.

## Overview

Activelop NeoHorizon self-hosted docker-compose deployment:

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
   # Api key to use as Bearer token for authentication
   export AL_API_TOKEN="neohorizon-api-key-here"
   # Api key for gemini requests
   export GEMINI_API_KEY="your-gemini-api-key-here"
   # Api key for openai requests
   export OPENAI_API_KEY="your-openai-api-key-here"
   ```

3. **Start the services:**

   ```bash
   # Start all services with dependencies and model
   docker-compose up -d
   ```

   ```bash
   # Start only neohorizon main services without dependencies
   docker-compose up -d
   ```

   ```bash
   # Start only neohorizon model service
   docker-compose up -d
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

#### `files-api`

- **Image:** `quay.io/activeloopai/neohorizon-files:${AL_IMAGE_TAG:-latest}`
- **Port:** 8000 (internal)
- **Purpose:** File management and processing service
- **Access:** Via nginx proxy at `/files`

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
- **Access:** Internal service, not directly exposed if not deployed separately otherwise with `8000` port
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

#### `postgres`

- **Image:** `postgres:17`
- **Port:** 5432
- **Purpose:** Primary database for application data
- **Credentials:** `postgres`/`postgres`
- **Database:** `neohorizon`
- **Persistence:** Volume `al_neohorizon_postgres_data`

#### `proxy`

- **Image:** `nginx:latest`
- **Port:** `80` (configurable via `LISTEN_PORT`)
- **Host:** `0.0.0.0` (configurable via `LISTEN_PORT`)
- **Purpose:** Reverse proxy for API services
- **Configuration:** Routes `/files` to files-api and everything else to main-api
- **File Upload:** Supports up to 512MB file uploads

## Environment Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `AL_API_TOKEN` | API Bearer authentication token, this token has special format</br>and can be copied from Activeloop platform UI | `your-api-key` |
| `GEMINI_API_KEY` | Google Gemini API key | `your-gemini-key` |
| `OPENAI_API_KEY` | OpenAI API key | `your-openai-key` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `AL_IMAGE_TAG` | Main application image tag | `latest` |
| `AL_IMAGE_TAG_MODEL` | Model service image tag | `latest` |
| `LISTEN_HOST` | Host interface for nginx proxy | `0.0.0.0` |
| `LISTEN_PORT` | Host interface for nginx proxy | `80` |
| `POSTGRES_DATABASE` | PostgreSQL database name | `neohorizon` |
| `POSTGRES_HOST` | PostgreSQL host | `al-neohorizon-postgres` |
| `POSTGRES_PASSWORD` | PostgreSQL password | `postgres` |
| `POSTGRES_PORT` | PostgreSQL port | `5432` |
| `POSTGRES_USER` | PostgreSQL username | `postgres` |
| `RABBITMQ_URL` | RabbitMQ connection URL | `amqp://neohorizon:neohorizon@al-neohorizon-rabbitmq:5672` |
| `VISUAL_MODEL_URL` | Visual model service URL | `http://al-neohorizon-model:8000` |
| `EMBEDDING_MODEL_URL` | Embedding model service URL | `http://al-neohorizon-model:8000` |
| `DEEPLAKE_ROOT_DIR` | Storage path for the neohorizon data | `/var/lib/deeplake` |
| `DEEPLAKE_CREDS` | Credentials for storage if (optional) </br>like s3 endpoint url or storage credentials | `N/A` |

## Configuration

### Network Configuration

All services run on a custom bridge network `al-neohorizon-network` for secure inter-service communication.

### Volume Persistence

- **PostgreSQL Data:** `al_neohorizon_postgres_data`
- **RabbitMQ Data:** `al_neohorizon_rabbitmq_data`

### Health Checks

- **RabbitMQ:** Checks service status every 30s
- **PostgreSQL:** Checks database readiness every 30s

## Usage Examples

For the API usage plese refer to [Neohorizon Documentation](https://docs.activeloop.ai/)

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

## Troubleshooting

### Common Issues

1. **Services not starting:**

   ```bash
   # Check logs for specific service
   docker-compose logs service-name
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
   - Set higher `SHM_SIZE` and run docker compose reastart if Model is on low memory

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
4. **SSL/TLS:** Configure HTTPS termination at the proxy level
5. **Scaling:** Use Docker Swarm or Kubernetes for orchestration

## Support

For issues and support:

- Check the [Activeloop Neohorizon Documentation](https://docs.activeloop.ai/)
- Review service logs for error messages
- Ensure all prerequisites are met
- Verify environment variable configuration

## License

This configuration is part of the Activeloop NeoHorizon project. Please refer to the main project license for usage terms.

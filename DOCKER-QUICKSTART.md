# 🐳 Docker Quick Start

Panduan cepat untuk menjalankan aplikasi menggunakan Docker.

## 📋 Prerequisites

- Docker Desktop terinstall
- Docker Compose terinstall

Cek instalasi:
```bash
docker --version
docker-compose --version
```

## 🚀 Quick Start

### Option 1: Using Interactive Script

```bash
./docker-start.sh
```

Script ini akan menampilkan menu interaktif untuk:
- Start development/production server
- Build images
- View logs
- Clean resources
- Dan lainnya

### Option 2: Using Makefile

```bash
# Development
make dev              # Start dev server
make dev-d            # Start dev server (detached)
make logs-dev         # View dev logs

# Production
make prod             # Start prod server
make prod-d           # Start prod server (detached)
make logs-prod        # View prod logs

# Management
make down             # Stop all services
make clean            # Clean all resources
make shell            # Open shell in container

# Lihat semua commands
make help
```

### Option 3: Using npm scripts

```bash
# Development
npm run docker:dev              # Start dev server
npm run docker:dev:build        # Build dev image
npm run docker:dev:down         # Stop dev server

# Production
npm run docker:prod             # Start prod server
npm run docker:prod:build       # Build prod image
npm run docker:prod:down        # Stop prod server

# Clean up
npm run docker:clean            # Remove all containers & images
```

### Option 4: Using Docker Compose Directly

```bash
# Development
docker-compose -f docker-compose.dev.yml up
docker-compose -f docker-compose.dev.yml up -d  # Detached mode
docker-compose -f docker-compose.dev.yml down

# Production
docker-compose -f docker-compose.prod.yml up
docker-compose -f docker-compose.prod.yml up -d  # Detached mode
docker-compose -f docker-compose.prod.yml down
```

## 🌐 Access URLs

- **Development**: http://localhost:3000
- **Production**: http://localhost:80

## 📖 Detailed Documentation

Lihat [docs/DOCKER.md](docs/DOCKER.md) untuk dokumentasi lengkap.

## 🔧 Common Commands

```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs -f

# Execute commands in container
docker-compose exec dev npm install package-name

# Rebuild image
docker-compose build --no-cache

# Remove all resources
docker-compose down -v
docker system prune -af
```

## 🐛 Troubleshooting

### Port already in use
Edit `docker-compose.dev.yml` atau `docker-compose.prod.yml`:
```yaml
ports:
  - "3001:3000"  # Change host port
```

### Container keeps restarting
```bash
docker-compose logs dev  # Check logs for errors
```

### Clean start
```bash
docker-compose down -v
docker system prune -af
docker-compose build --no-cache
docker-compose up
```

## 📚 More Info

- [Docker Documentation](docs/DOCKER.md)
- [Main README](README.md)

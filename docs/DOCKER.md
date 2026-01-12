# Docker Setup Guide

Dokumentasi lengkap untuk menjalankan R. Prama Wijaya Law Firm website menggunakan Docker.

## 📋 Prerequisites

- Docker Desktop (v20.10 atau lebih baru)
- Docker Compose (v2.0 atau lebih baru)

## 🚀 Quick Start

### Development Mode

Jalankan aplikasi dalam mode development dengan hot reload:

```bash
# Menggunakan docker-compose utama
docker-compose up dev

# Atau menggunakan file development-specific
docker-compose -f docker-compose.dev.yml up
```

Aplikasi akan tersedia di: **http://localhost:3000**

### Production Mode

Build dan jalankan aplikasi dalam mode production dengan nginx:

```bash
# Menggunakan docker-compose utama
docker-compose up prod

# Atau menggunakan file production-specific
docker-compose -f docker-compose.prod.yml up
```

Aplikasi akan tersedia di: **http://localhost:8080** (atau **http://localhost** untuk prod.yml)

## 🔨 Docker Commands

### Build Images

```bash
# Build development image
docker-compose build dev

# Build production image
docker-compose build prod

# Build tanpa cache
docker-compose build --no-cache
```

### Run Containers

```bash
# Run dalam detached mode (background)
docker-compose up -d dev

# Run dengan live logs
docker-compose up dev

# Stop containers
docker-compose down

# Stop dan hapus volumes
docker-compose down -v
```

### Manage Containers

```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs dev
docker-compose logs -f dev  # Follow logs

# Execute commands in container
docker-compose exec dev sh
docker-compose exec dev npm install

# Restart container
docker-compose restart dev
```

## 📁 File Structure

```
.
├── Dockerfile              # Multi-stage Docker build
├── docker-compose.yml      # Main compose file
├── docker-compose.dev.yml  # Development-specific config
├── docker-compose.prod.yml # Production-specific config
├── .dockerignore          # Files to exclude from Docker
└── nginx.conf             # Nginx configuration for production
```

## 🏗️ Multi-Stage Build

Dockerfile menggunakan 3 stages:

1. **Development**: Node.js dengan Vite dev server dan hot reload
2. **Build**: Build aplikasi Vue untuk production
3. **Production**: Serve aplikasi dengan nginx (lightweight)

### Stage 1: Development
```dockerfile
FROM node:18-alpine AS development
- Hot reload enabled
- Volume mounting untuk source code
- Vite dev server di port 3000
```

### Stage 2: Build
```dockerfile
FROM node:18-alpine AS build
- Install dependencies
- Build aplikasi (npm run build)
- Generate static files ke /dist
```

### Stage 3: Production
```dockerfile
FROM nginx:alpine AS production
- Copy built assets dari stage 2
- Serve dengan nginx
- Optimized untuk production
```

## 🔧 Configuration

### Environment Variables

Buat file `.env` di root project:

```env
# Application
NODE_ENV=development
VITE_PORT=3000

# API endpoints (jika ada)
VITE_API_URL=http://localhost:3000/api
```

### Nginx Configuration

File `nginx.conf` sudah dikonfigurasi dengan:
- ✅ Vue Router support (SPA routing)
- ✅ Gzip compression
- ✅ Static asset caching
- ✅ Security headers
- ✅ Error page handling

### Docker Compose Configuration

**Development** (`docker-compose.dev.yml`):
```yaml
- Port: 3000
- Volume mounting untuk hot reload
- Node environment: development
```

**Production** (`docker-compose.prod.yml`):
```yaml
- Port: 80
- No volume mounting
- Health check enabled
- Auto restart
```

## 📊 Container Management

### Development Workflow

1. **Start development server**:
   ```bash
   docker-compose up dev
   ```

2. **Install new packages**:
   ```bash
   docker-compose exec dev npm install <package-name>
   ```

3. **Run commands**:
   ```bash
   docker-compose exec dev npm run lint
   docker-compose exec dev npm run type-check
   ```

### Production Deployment

1. **Build production image**:
   ```bash
   docker-compose build prod
   ```

2. **Test locally**:
   ```bash
   docker-compose up prod
   ```

3. **Deploy to server**:
   ```bash
   # Tag image
   docker tag rpw-law-firm-prod:latest your-registry/rpw-law-firm:latest
   
   # Push to registry
   docker push your-registry/rpw-law-firm:latest
   
   # Pull and run on server
   docker pull your-registry/rpw-law-firm:latest
   docker run -d -p 80:80 your-registry/rpw-law-firm:latest
   ```

## 🐛 Troubleshooting

### Port Already in Use

```bash
# Ubah port di docker-compose.yml
ports:
  - "3001:3000"  # Host:Container
```

### Hot Reload Not Working

```bash
# Pastikan volumes sudah ter-mount dengan benar
docker-compose down
docker-compose up dev
```

### Build Errors

```bash
# Clear cache dan rebuild
docker-compose down
docker system prune -a
docker-compose build --no-cache dev
```

### Container Crashes

```bash
# Check logs
docker-compose logs dev

# Check container status
docker-compose ps

# Restart container
docker-compose restart dev
```

## 🔐 Security Best Practices

1. **Multi-stage builds**: Menggunakan slim images untuk production
2. **Security headers**: Configured di nginx.conf
3. **Non-root user**: Nginx runs as nginx user (not root)
4. **Minimal image size**: Alpine Linux base (< 50MB)
5. **.dockerignore**: Exclude sensitive files

## 📈 Performance Optimization

### Development
- Volume mounting untuk hot reload
- Fast rebuild dengan layer caching
- Node modules cache

### Production
- Gzip compression enabled
- Static asset caching (1 year)
- Minimal image size (nginx:alpine)
- Health checks enabled

## 🌐 Docker Hub / Registry

### Push to Docker Hub

```bash
# Login
docker login

# Tag image
docker tag rpw-law-firm-prod:latest username/rpw-law-firm:latest
docker tag rpw-law-firm-prod:latest username/rpw-law-firm:1.0.0

# Push
docker push username/rpw-law-firm:latest
docker push username/rpw-law-firm:1.0.0
```

### Pull and Run

```bash
# Pull image
docker pull username/rpw-law-firm:latest

# Run container
docker run -d -p 80:80 --name rpw-law-firm username/rpw-law-firm:latest
```

## 📝 Common Use Cases

### 1. Local Development
```bash
docker-compose -f docker-compose.dev.yml up
```

### 2. Production Testing
```bash
docker-compose -f docker-compose.prod.yml up
```

### 3. CI/CD Pipeline
```bash
# Build
docker build --target production -t rpw-law-firm:$CI_COMMIT_SHA .

# Test
docker run rpw-law-firm:$CI_COMMIT_SHA npm test

# Push
docker push rpw-law-firm:$CI_COMMIT_SHA
```

## 🆘 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Vite Documentation](https://vitejs.dev/)

## 📞 Support

Untuk bantuan lebih lanjut, silakan hubungi tim development atau buat issue di repository.

# Makefile for R. Prama Wijaya Law Firm Docker Management

.PHONY: help build dev prod up down logs shell clean install test

# Default target
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

## help: Show this help message
help:
	@echo "$(BLUE)R. Prama Wijaya Law Firm - Docker Management$(NC)"
	@echo ""
	@echo "$(GREEN)Available commands:$(NC)"
	@echo ""
	@grep -E '^## [a-zA-Z_-]+:' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "## |: "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$2, $$3}'

##@ Development

## dev: Start development server
dev:
	@echo "$(GREEN)Starting development server...$(NC)"
	docker-compose -f docker-compose.dev.yml up

## dev-build: Build development image
dev-build:
	@echo "$(GREEN)Building development image...$(NC)"
	docker-compose -f docker-compose.dev.yml build

## dev-d: Start development server in detached mode
dev-d:
	@echo "$(GREEN)Starting development server (detached)...$(NC)"
	docker-compose -f docker-compose.dev.yml up -d

##@ Production

## prod: Start production server
prod:
	@echo "$(GREEN)Starting production server...$(NC)"
	docker-compose -f docker-compose.prod.yml up

## prod-build: Build production image
prod-build:
	@echo "$(GREEN)Building production image...$(NC)"
	docker-compose -f docker-compose.prod.yml build

## prod-d: Start production server in detached mode
prod-d:
	@echo "$(GREEN)Starting production server (detached)...$(NC)"
	docker-compose -f docker-compose.prod.yml up -d

##@ Container Management

## up: Start all services
up:
	@echo "$(GREEN)Starting all services...$(NC)"
	docker-compose up

## down: Stop all services
down:
	@echo "$(RED)Stopping all services...$(NC)"
	docker-compose down

## restart: Restart all services
restart: down up

## logs: Show logs for all services
logs:
	docker-compose logs -f

## logs-dev: Show logs for development service
logs-dev:
	docker-compose logs -f dev

## logs-prod: Show logs for production service
logs-prod:
	docker-compose logs -f prod

## ps: List running containers
ps:
	docker-compose ps

##@ Shell Access

## shell: Open shell in development container
shell:
	@echo "$(GREEN)Opening shell in development container...$(NC)"
	docker-compose exec dev sh

## shell-prod: Open shell in production container
shell-prod:
	@echo "$(GREEN)Opening shell in production container...$(NC)"
	docker-compose exec prod sh

##@ Installation & Dependencies

## install: Install npm dependencies in container
install:
	@echo "$(GREEN)Installing dependencies...$(NC)"
	docker-compose exec dev npm install

## install-package: Install specific package (usage: make install-package PKG=package-name)
install-package:
	@echo "$(GREEN)Installing $(PKG)...$(NC)"
	docker-compose exec dev npm install $(PKG)

##@ Build & Clean

## build: Build all Docker images
build:
	@echo "$(GREEN)Building all images...$(NC)"
	docker-compose build

## build-no-cache: Build all images without cache
build-no-cache:
	@echo "$(GREEN)Building all images (no cache)...$(NC)"
	docker-compose build --no-cache

## clean: Remove all containers, volumes, and images
clean:
	@echo "$(RED)Cleaning up Docker resources...$(NC)"
	docker-compose down -v
	docker system prune -af

## clean-volumes: Remove all volumes
clean-volumes:
	@echo "$(RED)Removing volumes...$(NC)"
	docker-compose down -v

##@ Testing & Quality

## lint: Run ESLint in container
lint:
	@echo "$(GREEN)Running ESLint...$(NC)"
	docker-compose exec dev npm run lint

## type-check: Run TypeScript type checking
type-check:
	@echo "$(GREEN)Running type check...$(NC)"
	docker-compose exec dev npm run type-check

## format: Format code with Prettier
format:
	@echo "$(GREEN)Formatting code...$(NC)"
	docker-compose exec dev npm run format

##@ Quick Actions

## start: Quick start development (alias for dev-d)
start: dev-d
	@echo "$(GREEN)Development server started at http://localhost:3000$(NC)"

## stop: Quick stop all services (alias for down)
stop: down

## status: Show container status (alias for ps)
status: ps

##@ Advanced

## rebuild: Stop, clean, and rebuild all images
rebuild: down clean build
	@echo "$(GREEN)Rebuild complete!$(NC)"

## rebuild-dev: Rebuild development image
rebuild-dev:
	@echo "$(GREEN)Rebuilding development image...$(NC)"
	docker-compose -f docker-compose.dev.yml down
	docker-compose -f docker-compose.dev.yml build --no-cache
	docker-compose -f docker-compose.dev.yml up -d

## rebuild-prod: Rebuild production image
rebuild-prod:
	@echo "$(GREEN)Rebuilding production image...$(NC)"
	docker-compose -f docker-compose.prod.yml down
	docker-compose -f docker-compose.prod.yml build --no-cache
	docker-compose -f docker-compose.prod.yml up -d

## health: Check container health status
health:
	@echo "$(GREEN)Container Health Status:$(NC)"
	@docker inspect --format='{{.State.Health.Status}}' rpw-law-firm-prod 2>/dev/null || echo "Container not running"

##@ Docker Registry

## push: Push images to Docker registry (requires login)
push:
	@echo "$(GREEN)Pushing images to registry...$(NC)"
	docker-compose push

## pull: Pull images from Docker registry
pull:
	@echo "$(GREEN)Pulling images from registry...$(NC)"
	docker-compose pull

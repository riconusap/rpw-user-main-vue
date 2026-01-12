#!/bin/bash

# Docker Quick Start Script for R. Prama Wijaya Law Firm

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "\n${BLUE}======================================${NC}"
    echo -e "${BLUE}  R. Prama Wijaya Law Firm - Docker${NC}"
    echo -e "${BLUE}======================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker Desktop first."
        exit 1
    fi
    print_success "Docker is installed"
}

check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    print_success "Docker Compose is installed"
}

show_menu() {
    echo ""
    echo "Select an option:"
    echo "1) Start Development Server"
    echo "2) Start Production Server"
    echo "3) Build Development Image"
    echo "4) Build Production Image"
    echo "5) Stop All Containers"
    echo "6) View Logs"
    echo "7) Clean Docker Resources"
    echo "8) Shell Access (Dev)"
    echo "9) Install Dependencies"
    echo "0) Exit"
    echo ""
    read -p "Enter choice [0-9]: " choice
}

start_dev() {
    print_info "Starting development server..."
    docker-compose -f docker-compose.dev.yml up -d
    print_success "Development server started!"
    print_info "Access the application at: http://localhost:3000"
    echo ""
    read -p "Do you want to view logs? (y/n): " view_logs
    if [ "$view_logs" = "y" ]; then
        docker-compose -f docker-compose.dev.yml logs -f
    fi
}

start_prod() {
    print_info "Starting production server..."
    docker-compose -f docker-compose.prod.yml up -d
    print_success "Production server started!"
    print_info "Access the application at: http://localhost:80"
    echo ""
    read -p "Do you want to view logs? (y/n): " view_logs
    if [ "$view_logs" = "y" ]; then
        docker-compose -f docker-compose.prod.yml logs -f
    fi
}

build_dev() {
    print_info "Building development image..."
    docker-compose -f docker-compose.dev.yml build
    print_success "Development image built successfully!"
}

build_prod() {
    print_info "Building production image..."
    docker-compose -f docker-compose.prod.yml build
    print_success "Production image built successfully!"
}

stop_all() {
    print_info "Stopping all containers..."
    docker-compose -f docker-compose.dev.yml down
    docker-compose -f docker-compose.prod.yml down
    print_success "All containers stopped!"
}

view_logs() {
    echo ""
    echo "Select logs to view:"
    echo "1) Development"
    echo "2) Production"
    echo "3) Both"
    read -p "Enter choice [1-3]: " log_choice
    
    case $log_choice in
        1)
            docker-compose -f docker-compose.dev.yml logs -f
            ;;
        2)
            docker-compose -f docker-compose.prod.yml logs -f
            ;;
        3)
            docker-compose logs -f
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
}

clean_docker() {
    print_info "This will remove all containers, volumes, and unused images."
    read -p "Are you sure? (y/n): " confirm
    
    if [ "$confirm" = "y" ]; then
        print_info "Cleaning Docker resources..."
        docker-compose down -v
        docker system prune -af
        print_success "Docker resources cleaned!"
    else
        print_info "Cleaning cancelled"
    fi
}

shell_access() {
    print_info "Opening shell in development container..."
    docker-compose exec dev sh
}

install_deps() {
    print_info "Installing dependencies in container..."
    docker-compose exec dev npm install
    print_success "Dependencies installed!"
}

# Main script
print_header

check_docker
check_docker_compose

while true; do
    show_menu
    
    case $choice in
        1)
            start_dev
            ;;
        2)
            start_prod
            ;;
        3)
            build_dev
            ;;
        4)
            build_prod
            ;;
        5)
            stop_all
            ;;
        6)
            view_logs
            ;;
        7)
            clean_docker
            ;;
        8)
            shell_access
            ;;
        9)
            install_deps
            ;;
        0)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please try again."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done

# Multi-stage Dockerfile for Vue 3 + TypeScript + Vite

# Stage 1: Development
FROM node:18-alpine AS development

WORKDIR /app

# Copy package files
COPY package*.json ./

# Copy env.example to .env
RUN cp .env.example .env

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Expose Vite dev server port
EXPOSE 3000

# Start development server
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]


# Stage 2: Build for production
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Copy env.example to .env
RUN cp .env.example .env

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build application
RUN npm run build


# Stage 3: Production with nginx
FROM nginx:alpine AS production

# Copy built assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

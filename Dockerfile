# Set ARGs to switch between dev and prod
ARG NODE_ENV=production

# Build stage
FROM node:23-slim AS builder
WORKDIR /app

# Set build-time ARG and ENV
ARG NODE_ENV
ENV NODE_ENV=$NODE_ENV

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy code
COPY . .

# Build Next.js app
RUN npm run build

# Upload source maps to Sentry (only in production)
RUN if [ "$NODE_ENV" = "production" ]; then \
    npm install -g @sentry/cli && \
    sentry-cli sourcemaps upload --include .next --url-prefix "~/._next" --rewrite; \
    fi

# Production runtime image
FROM node:23-slim AS runner
WORKDIR /app

# Install Doppler CLI, wget (for healthcheck), and Sentry CLI (optional in prod)
RUN apk add --no-cache curl wget \
    && wget -q -t3 'https://packages.doppler.com/public/cli/rsa.8004D9FF50437357.key' -O /etc/apk/keys/cli@doppler-8004D9FF50437357.rsa.pub \
    && echo 'https://packages.doppler.com/public/cli/alpine/any-version/main' | tee -a /etc/apk/repositories \
    && apk add doppler \
    && npm install -g @sentry/cli

# Copy prod config + built files
COPY package.json package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/package.json ./

# Install only prod deps
RUN npm ci --only=production

# Use Doppler to inject runtime secrets
EXPOSE 3000

# Healthcheck for Railway, Docker Compose, etc.
HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost:3000 || exit 1

# Default command
CMD ["doppler", "run", "--", "npm", "start"]

# Set ARGs to switch between dev and prod
ARG NODE_ENV=production

# Build stage
# Use a specific Node.js LTS version with Debian slim for best compatibility
FROM node:20-slim AS builder
# node:slim (Debian) is preferred over Alpine for compatibility with native modules and CLI tools like doppler and sentry-cli.
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

# Install Doppler CLI, wget (for healthcheck), and Sentry CLI (optional in prod)
RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg wget \
    && curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" > /etc/apt/sources.list.d/doppler-cli.list \
    && apt-get update \
    && apt-get install -y doppler \
    && npm install -g @sentry/cli

# Upload source maps to Sentry (only in production)
# NOTE: Uploading Sentry sourcemaps should be done in CI/CD or a separate deployment step, not during Docker build.
# To upload, ensure SENTRY_AUTH_TOKEN, SENTRY_ORG, and SENTRY_PROJECT are set in your pipeline environment.
# RUN if [ "$NODE_ENV" = "production" ]; then \
#     npm install -g @sentry/cli && \
#     sentry-cli sourcemaps upload .next --url-prefix "~/_next" --rewrite; \
# fi

# Production runtime image
FROM node:20-slim AS runner
WORKDIR /app



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

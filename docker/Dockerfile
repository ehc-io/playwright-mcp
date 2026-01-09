# Playwright MCP Server - Docker Compose Edition
# Pre-baked Chromium for instant startup

ARG NODE_VERSION=22
ARG PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# ------------------------------
# Base: Runtime dependencies
# ------------------------------
FROM node:${NODE_VERSION}-bookworm-slim AS base

ARG PLAYWRIGHT_BROWSERS_PATH
ENV PLAYWRIGHT_BROWSERS_PATH=${PLAYWRIGHT_BROWSERS_PATH}

WORKDIR /app

# Install production dependencies and Chromium system deps
RUN --mount=type=cache,target=/root/.npm,sharing=locked,id=npm-cache \
    --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    npm ci --omit=dev && \
    npx -y playwright-core install-deps chromium && \
    sed -i '/if (!allowAnyHost)/,/^    }/d' node_modules/playwright/lib/mcp/sdk/http.js

# ------------------------------
# Browser: Pre-download Chromium
# ------------------------------
FROM base AS browser

# Download Chromium binary at build time (not runtime)
RUN npx -y playwright-core install --no-shell chromium

# ------------------------------
# Runtime: Final image
# ------------------------------
FROM base

ARG PLAYWRIGHT_BROWSERS_PATH
ARG USERNAME=node

ENV NODE_ENV=production
ENV PLAYWRIGHT_MCP_OUTPUT_DIR=/tmp/playwright-output

# Set ownership for non-root user
RUN chown -R ${USERNAME}:${USERNAME} node_modules && \
    mkdir -p ${PLAYWRIGHT_MCP_OUTPUT_DIR} && \
    chown -R ${USERNAME}:${USERNAME} ${PLAYWRIGHT_MCP_OUTPUT_DIR}

USER ${USERNAME}

# Copy pre-downloaded Chromium from browser stage
COPY --from=browser --chown=${USERNAME}:${USERNAME} ${PLAYWRIGHT_BROWSERS_PATH} ${PLAYWRIGHT_BROWSERS_PATH}

# Copy application files
COPY --chown=${USERNAME}:${USERNAME} cli.js package.json ./

# Copy entrypoint script
COPY --chown=${USERNAME}:${USERNAME} docker/entrypoint.sh /entrypoint.sh

# Default environment variables
ENV MCP_PORT=3020
ENV HEADLESS=true

EXPOSE ${MCP_PORT}

ENTRYPOINT ["/entrypoint.sh"]

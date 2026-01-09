#!/bin/bash
set -e

# Playwright MCP Server Entrypoint
# Constructs CLI arguments from environment variables

# Default values
MCP_PORT="${MCP_PORT:-3020}"
HEADLESS="${HEADLESS:-true}"

# Build argument array (using bash array to properly handle special characters)
ARGS=("--port" "${MCP_PORT}" "--host" "0.0.0.0" "--allowed-hosts" "*" "--browser" "chromium" "--no-sandbox")

# Add headless flag if enabled
if [ "${HEADLESS}" = "true" ]; then
    ARGS+=("--headless")
fi

echo "Starting Playwright MCP Server..."
echo "  Port: ${MCP_PORT}"
echo "  Headless: ${HEADLESS}"
echo "  Command: node cli.js ${ARGS[*]}"

exec node cli.js "${ARGS[@]}"

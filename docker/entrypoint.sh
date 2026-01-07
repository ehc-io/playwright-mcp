#!/bin/sh
set -e

# Playwright MCP Server Entrypoint
# Constructs CLI arguments from environment variables

# Default values
MCP_PORT="${MCP_PORT:-3020}"
HEADLESS="${HEADLESS:-true}"

# Build argument list
ARGS="--port ${MCP_PORT} --host 0.0.0.0 --browser chromium --no-sandbox"

# Add headless flag if enabled
if [ "${HEADLESS}" = "true" ]; then
    ARGS="${ARGS} --headless"
fi

echo "Starting Playwright MCP Server..."
echo "  Port: ${MCP_PORT}"
echo "  Headless: ${HEADLESS}"
echo "  Command: node cli.js ${ARGS}"

exec node cli.js ${ARGS}

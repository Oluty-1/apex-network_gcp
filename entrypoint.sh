#!/bin/bash
set -e

# Parse ENV_VARS_JSON if it exists
if [ -n "$ENV_VARS_JSON" ]; then
  echo "🔑 Parsing environment variables from JSON secret..."
  echo "$ENV_VARS_JSON" | jq -r 'to_entries|map("export \(.key)=\(.value|tostring)")|.[]' | sh
fi

# Start application
exec "$@"

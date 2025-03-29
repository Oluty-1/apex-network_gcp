#!/bin/sh
set -e

# Parse ENV_VARS_JSON if it exists
if [ -n "$ENV_VARS_JSON" ]; then
  eval "$(echo "$ENV_VARS_JSON" | jq -r 'to_entries|map("export \(.key)=\(.value|tostring)")|.[]')"
fi

# Start application
exec "$@"
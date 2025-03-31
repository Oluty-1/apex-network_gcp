#!/bin/sh
set -e

# Check if the secrets file exists and load the environment variables
if [ -f /mnt/secrets/apexsecrets.json ]; then
  echo "🔑 Loading secrets from /mnt/secrets/apexsecrets.json..."
  # Debug: Print the contents of the secrets file (remove in production)
  cat /mnt/secrets/apexsecrets.json
  # Load each key-value pair as an environment variable
  eval "$(jq -r 'to_entries|map("export \(.key)=\(.value|tostring)")|.[]' /mnt/secrets/apexsecrets.json)"
  # Debug: Confirm a specific environment variable is set (e.g., DB_URL)
  echo "DEBUG: DB_URL is set to: $DB_URL"
fi

# Start the application
exec "$@"

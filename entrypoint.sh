#!/bin/sh
set -e

# Fetch secrets from GCP Secret Manager if SECRET_NAME is set
if [ -n "$SECRET_NAME" ]; then
  echo "Loading secrets from $SECRET_NAME..."
  export $( \
    gcloud secrets versions access latest --secret="$SECRET_NAME" --project="$GCP_PROJECT" | \
    jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' \
  )
fi

# Run the main application command
exec "$@"

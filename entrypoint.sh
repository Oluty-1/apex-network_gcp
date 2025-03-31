# #!/bin/sh
# set -e

# # Parse ENV_VARS_JSON if it exists
# if [ -n "$ENV_VARS_JSON" ]; then
#   eval "$(echo "$ENV_VARS_JSON" | jq -r 'to_entries|map("export \(.key)=\(.value|tostring)")|.[]')"
# fi

# # Start application
# exec "$@"




#!/bin/sh
set -e

# Check if the secrets file exists and load the environment variables
if [ -f /mnt/secrets/secrets.json ]; then
  echo "🔑 Loading secrets from /mnt/secrets/apexsecrets.json..."
  eval "$(jq -r 'to_entries|map("export \(.key)=\(.value|tostring)")|.[]' /mnt/secrets/apexsecrets.json)"
fi

# Start the application
exec "$@"

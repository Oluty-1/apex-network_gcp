# Step 1: Build the Go application
FROM golang:1.20-alpine AS build_image

LABEL "Project"="Apex_Network"
LABEL "Author"="Tejiri"
# Set the working directory inside the container
WORKDIR /build

# Copy the Go source code into the container
COPY src/go.mod .
COPY src/ .
# COPY .env .

# Download go dependencies
RUN go mod download

# Build the Go application
RUN go build -o /build/apex_network


# Step 2: Create a minimal container to run the application
FROM alpine:latest

# After FROM alpine:latest
RUN apk add --no-cache jq


# Set a working directory in the new container
WORKDIR /app

# Copy the built Go binary from the builder stage
COPY --from=build_image /build/apex_network ./apex_network

# Inject environment variables directly into the image
# ENV PORT=3000
# ENV DB_URL=postgresql://apex_db:2VNlmvPG8lW4yNVOVRgp1QaoaeicXaDv@dpg-d0gjk3re5dus73aefpo0-a.virginia-postgres.render.com/apex_db_hdcx

# Expose the application port
EXPOSE 3000



# # Create entrypoint script directly in the Dockerfile
# RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
#     echo 'set -e' >> /app/entrypoint.sh && \
#     echo '' >> /app/entrypoint.sh && \
#     echo '# Check if the secrets file exists and load the environment variables' >> /app/entrypoint.sh && \
#     echo 'if [ -f /mnt/secrets/apexsecrets.json ]; then' >> /app/entrypoint.sh && \
#     echo '  echo "🔑 Loading secrets from /mnt/secrets/apexsecrets.json..."' >> /app/entrypoint.sh && \
#     echo '  # Debug: Print the contents of the secrets file (remove in production)' >> /app/entrypoint.sh && \
#     echo '  cat /mnt/secrets/apexsecrets.json' >> /app/entrypoint.sh && \
#     echo '  # Load each key-value pair as an environment variable' >> /app/entrypoint.sh && \
#     echo '  eval "$(jq -r '"'"'to_entries|map("export \(.key)=\(.value|tostring)")|.[]'"'"' /mnt/secrets/apexsecrets.json)"' >> /app/entrypoint.sh && \
#     echo '  # Debug: Confirm a specific environment variable is set (e.g., DB_URL)' >> /app/entrypoint.sh && \
#     echo '  echo "DEBUG: DB_URL is set to: $DB_URL"' >> /app/entrypoint.sh && \
#     echo 'fi' >> /app/entrypoint.sh && \
#     echo '' >> /app/entrypoint.sh && \
#     echo '# Start the application' >> /app/entrypoint.sh && \
#     echo 'exec "$@"' >> /app/entrypoint.sh && \
#     chmod +x /app/entrypoint.sh

# # Make the entrypoint script executable
# RUN chmod +x /app/entrypoint.sh

# # Set entrypoint
# ENTRYPOINT ["/app/entrypoint.sh"]



# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Set entrypoint (preserves CMD from original Dockerfile)
ENTRYPOINT ["/app/entrypoint.sh"]


# Command to run the application
CMD [ "./apex_network", "apex_network_api" ]



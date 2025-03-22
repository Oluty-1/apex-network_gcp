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
# ENV DB_URL=postgresql://apex_gcp_db_user:fkjBqF5GqYAbXWK8ewwwXshdT8UeFcOG@dpg-cv2qatfnoe9s73b9m4fg-a.ohio-postgres.render.com/apex_gcp_db

# Expose the application port
EXPOSE 3000

# # Copy entrypoint script
# COPY entrypoint.sh .
# RUN chmod +x entrypoint.sh

# # Set entrypoint (preserves CMD from original Dockerfile)
# ENTRYPOINT ["/app/entrypoint.sh"]



# Create a wrapper script directly in the Dockerfile
RUN echo '#!/bin/sh' > /app/wrapper.sh && \
    echo 'set -e' >> /app/wrapper.sh && \
    echo '# Parse ENV_VARS_JSON if it exists' >> /app/wrapper.sh && \
    echo 'if [ -n "$ENV_VARS_JSON" ]; then' >> /app/wrapper.sh && \
    echo '  echo "🔑 Parsing environment variables from JSON secret..."' >> /app/wrapper.sh && \
    echo '  echo "$ENV_VARS_JSON" | jq -r '\''to_entries|map("export \(.key)=\(.value|tostring)")|.[]'\'' | sh' >> /app/wrapper.sh && \
    echo 'fi' >> /app/wrapper.sh && \
    echo '# Start application' >> /app/wrapper.sh && \
    echo 'exec "$@"' >> /app/wrapper.sh && \
    chmod +x /app/wrapper.sh

# Set the wrapper script as the entrypoint
ENTRYPOINT ["/app/wrapper.sh"]



# Command to run the application
CMD [ "./apex_network", "apex_network_api" ]



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



# Create the entrypoint script directly in the Dockerfile
RUN echo '#!/bin/sh\n\
set -e\n\
\n\
# Check if the secrets file exists and load the environment variables\n\
if [ -f /mnt/secrets/apexsecrets.json ]; then\n\
  echo "🔑 Loading secrets from /mnt/secrets/apexsecrets.json..."\n\
  # Debug: Print the contents of the secrets file\n\
  cat /mnt/secrets/apexsecrets.json\n\
  # Load each key-value pair as an environment variable\n\
  export $(jq -r "to_entries|map(\\(.key)=\\(.value|tostring))|.[]" /mnt/secrets/apexsecrets.json)\n\
  # Debug: Confirm DB_URL is set\n\
  echo "DEBUG: DB_URL is set to: $DB_URL"\n\
fi\n\
\n\
# Start the application\n\
exec "$@"' > /app/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]


# # Copy entrypoint script
# COPY entrypoint.sh .
# RUN chmod +x entrypoint.sh

# # Set entrypoint (preserves CMD from original Dockerfile)
# ENTRYPOINT ["/app/entrypoint.sh"]


# Command to run the application
CMD [ "./apex_network", "apex_network_api" ]



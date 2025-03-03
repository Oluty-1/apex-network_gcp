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

# Set a working directory in the new container
WORKDIR /app

# Copy the built Go binary from the builder stage
COPY --from=build_image /build/apex_network ./apex_network

# Inject environment variables directly into the image
ENV PORT=3000
ENV DB_URL=postgresql://apex_db:drhtjRgYuThA7LBzXyV6nUvh1Gtvj419@dpg-creg3c0gph6c73erudi0-a.ohio-postgres.render.com/apex_db_i10e

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD [ "./apex_network", "apex_network_api" ]


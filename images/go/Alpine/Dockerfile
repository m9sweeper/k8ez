# Start from the Golang Alpine image
FROM golang:1.19-alpine

# Install git, required for fetching Go dependencies.
RUN apk add --no-cache git

# Set destination for COPY
WORKDIR /app

# Copy the necessary files
COPY ../code/go.mod ../code/go.sum ./

# Download Go modules
RUN go mod download

# Copy the source code
COPY ../code/*.go ./

# Build
# CGO_ENABLED=0 is set to ensure a static binary is built,
# which is often necessary for Alpine-based images.
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping

# Create non root user
RUN addgroup -g 1050 -S limitedaccessaccount && \
    adduser -u 1050 -S limitedaccessaccount -G limitedaccessaccount \

# Change to the non-root user
USER 1050

# Expose port 8080
EXPOSE 8080

# Run
CMD [ "/docker-gs-ping" ]

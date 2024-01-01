# Start from the Golang Debian image
FROM golang:1.19

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
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping

# Create a non root user
RUN groupadd -g 1001 appuser && useradd -u 1001 -g appuser -m appuser

# Change to the non-root user
USER 1001

# Expose the port
EXPOSE 8080

# Run
CMD [ "/docker-gs-ping" ]
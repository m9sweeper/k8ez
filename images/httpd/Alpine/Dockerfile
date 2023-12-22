# Use Alpine Linux as the base image
FROM alpine:latest

# Install apache (httpd) and supervisor
RUN apk add --no-cache apache2 supervisor

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Create necessary directories for supervisor and pidfile
RUN mkdir -p /var/run/supervisor && \
    chown -R appuser:appgroup /var/run/supervisor /run/apache2

# Copy the custom httpd.conf to the container
COPY ../Alpine/httpd.conf /etc/apache2/httpd.conf

# Copy the supervisord.conf to the container
COPY ../Alpine/supervisord.conf /etc/supervisord.conf

# Create a directory for static files and copy them
COPY ../code/build/ /var/www/localhost/htdocs/

# Switch to the non-root user
USER appuser

# Expose the port Apache is listening on
EXPOSE 8080

# Start supervisord
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

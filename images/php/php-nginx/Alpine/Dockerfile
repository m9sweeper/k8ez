# Use PHP 8.0 FPM based on Alpine
FROM php:8.0-fpm-alpine

# Install nginx and supervisor
RUN apk --no-cache add nginx supervisor

# Create a new user and group with specific UID/GID (e.g., 1001)
RUN addgroup -g 1001 appgroup && \
    adduser -D -u 1001 -G appgroup appuser

# Configure Nginx
RUN rm -rf /var/www/html/*

# Copy application files and set ownership to the new user
COPY --chown=appuser:appgroup ../Alpine/index.php /var/www/html/index.php
COPY --chown=appuser:appgroup ../Alpine/nginx.conf /etc/nginx/http.d/default.conf

# Configure Supervisord
COPY --chown=appuser:appgroup ../Alpine/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories for Nginx and Supervisord
RUN mkdir -p /var/log/supervisor /var/tmp/nginx && \
    chown -R appuser:appgroup /var/www /var/tmp/nginx /var/log/supervisor

# Create and set permissions for Nginx logs and temp directories
RUN mkdir -p /var/lib/nginx/tmp && \
    chown -R appuser:appgroup /var/lib/nginx /run

# Redirect Nginx logs to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Set the working directory
WORKDIR /var/www/html

# Switch to the non-root user
USER 1001

# Expose port 80
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

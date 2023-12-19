# Use PHP 8.0 FPM based on Alpine
FROM php:8.0-fpm-alpine

# Install nginx and supervisor
RUN apk --no-cache add nginx supervisor

# Configure Nginx
RUN rm -rf /var/www/html/*

# Create a new non root user and group with specific UID/
RUN addgroup -g 1001 appgroup && \
    adduser -D -u 1001 -G appgroup appuser
COPY --chown=appuser:appgroup ../code/index.php /var/www/html/index.php

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY --chown=appuser:appgroup ../Alpine/nginx.conf /etc/nginx/http.d/default.conf

# Configure Supervisord
COPY ../Alpine/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories and set permissions for nginx and supervisord
RUN mkdir -p /var/tmp/nginx && \
    chown -R appuser:appgroup /var/www /var/tmp/nginx

# Create and set permissions for Nginx logs and temp directories
RUN mkdir -p /var/lib/nginx/tmp /var/lib/nginx/tmp/client_body && \
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

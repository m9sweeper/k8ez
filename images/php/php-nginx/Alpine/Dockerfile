# Use PHP 8.0 FPM based on Alpine
FROM php:8.0-fpm-alpine

# Install nginx and supervisor
RUN apk --no-cache add nginx supervisor

# Configure Nginx
RUN rm -rf /var/www/html/*

# In Alpine Linux (and many other Linux distributions), the 'nobody' user is a predefined system user that exists by default.
COPY --chown=nobody:nobody index.php /var/www/html/index.php

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY --chown=nobody:nobody nginx.conf /etc/nginx/http.d/default.conf

# Configure Supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories and set permissions for nginx and supervisord
RUN mkdir -p /var/log/supervisor /var/tmp/nginx && \
    chown -R nobody:nobody /var/www /var/log /var/tmp/nginx

# Create and set permissions for Nginx logs and temp directories
RUN mkdir -p /var/lib/nginx/logs /var/lib/nginx/tmp /var/lib/nginx/tmp/client_body && \
    chown -R nobody:nobody /var/lib/nginx /run

# Set the working directory
WORKDIR /var/www/html

# Switch to the non-root user
USER nobody

# Expose port 80
EXPOSE 80

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

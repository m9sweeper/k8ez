# Use an Alpine-based PHP 8 image with FPM
FROM php:8.0-fpm-alpine

# Install Apache and other necessary packages
RUN apk update && apk add --no-cache \
    apache2 \
    apache2-proxy \
    supervisor \
    && rm -rf /var/cache/apk/*

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy Apache, PHP-FPM and Supervisord configuration files
COPY apache.conf /etc/apache2/httpd.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Adjust PHP configuration for logging and other settings
RUN echo "log_errors = On" >> /usr/local/etc/php/php.ini \
    && echo "error_log = /proc/self/fd/2" >> /usr/local/etc/php/php.ini

# Create necessary directories and set permissions
RUN mkdir -p /var/www/html \
    && mkdir -p /run/apache2 \
    && mkdir -p /var/log/supervisor \
    && chown -R appuser:appgroup /var/www /run/apache2 /var/log

# Install Composer globally
RUN apk add --no-cache composer

# Copy application source
COPY --chown=appuser:appgroup . /var/www/html

# Set the working directory to the application directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# Switch to the non-root user
USER appuser

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

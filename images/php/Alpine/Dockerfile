# Use Alpine-based PHP with FPM
FROM php:8.0-fpm-alpine

# Install Apache and other necessary packages
RUN apk update && apk add --no-cache \
    apache2 \
    apache2-proxy \
    supervisor \
    php8-fpm \
    && rm -rf /var/cache/apk/*

# Copy over the Apache configuration
COPY ../Alpine/apache.conf /etc/apache2/httpd.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a new user and group to run the processes with a specific UID
RUN addgroup -S appgroup && adduser -S -u 1000 -G appgroup appuser

RUN chown -R appuser:appgroup /var/www/html \
    && chown -R appuser:appgroup /etc/apache2 \
    && chmod 755 -R /etc/apache2

# Copy the PHP application and composer.json file
COPY ../code/index.php /var/www/html/
COPY ../code/composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install PHP dependencies
RUN composer install

# Change ownership and permissions of the /run/apache2 directory
RUN chown -R appuser:appgroup /run/apache2 \
    && chmod 755 -R /run/apache2/

# Copy the supervisord configuration file
COPY ../Alpine/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Switch to the non-root user
USER 1000

# Expose the port Apache is listening on
EXPOSE 8080

# Start Apache and PHP-FPM using supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

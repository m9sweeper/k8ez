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
COPY apache.conf /etc/apache2/httpd.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a new user and group to run the processes
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN chown -R appuser:appgroup /var/www/html \
    && chown -R appuser:appgroup /etc/apache2 \
    && chmod 755 -R /etc/apache2

# Copy the PHP application
COPY . /var/www/html
WORKDIR /var/www/html

# Install PHP dependencies
RUN composer install

RUN chown -R www-data:www-data /run/apache2 \
    && chmod 777 -R /run/apache2/

# Copy the supervisord configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Switch to the non-root user
USER appuser

# Expose the port Apache is listening on
EXPOSE 80

# Start Apache and PHP-FPM using supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

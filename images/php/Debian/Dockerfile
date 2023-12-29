# Use Debian-based PHP with FPM
FROM php:8.0-fpm

# Install Apache, Composer dependencies, and other necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod proxy_fcgi

# Copy over the Apache configuration
COPY ../Debian/apache.conf /etc/apache2/sites-available/000-default.conf

RUN a2ensite 000-default

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a new user and group to run the processes
RUN groupadd -g 1000 appgroup && useradd -u 1000 -g appgroup -m appuser

# Set ownership and permissions for necessary directories
RUN mkdir -p /var/www/html /var/log/apache2 /var/lock/apache2 /var/run/apache2 \
    && chown -R appuser:appgroup /var/www /var/lock/apache2 /var/log/apache2 /var/run/apache2

# Copy the PHP application and composer.json file
COPY ../code/index.php /var/www/html/
COPY ../code/composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install PHP dependencies
RUN composer install --no-dev --no-scripts --no-plugins

# Copy the supervisord configuration file
COPY ../Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Run as non-root user
USER 1000

# Expose the port Apache is listening on
EXPOSE 8080

# Start Apache and PHP-FPM using supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

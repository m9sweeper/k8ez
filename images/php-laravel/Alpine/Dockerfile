# Use the official PHP image with FPM based on Alpine
FROM php:8.1-fpm-alpine

# Install system dependencies
RUN apk --no-cache add \
    git \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip \
    apache2 \
    apache2-proxy \
    apache2-ssl \
    apache2-utils \
    supervisor \
    && rm -rf /var/cache/apk/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN addgroup -g 1000 appgroup \
    && adduser -u 1000 -G appgroup -s /bin/sh -D appuser

# Copy existing application directory permissions
COPY --chown=appuser:appgroup ../code/hello-world /var/www

# Set working directory
WORKDIR /var/www

# Copy Apache vhost file to proxy php requests to php-fpm service
COPY ../Alpine/apache.conf /etc/apache2/conf.d/default.conf

# Copy supervisor configuration file
COPY ../Alpine/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure Apache
RUN mkdir -p /run/apache2 \
    && chown -R appuser:appgroup /run/apache2 \
    && chown -R appuser:appgroup /var/www/

# File Permissions
RUN chown -R appuser:appgroup /var/www/storage /var/www/bootstrap/cache /var/log/apache2/ \
    && chmod -R 755 /var/www/storage /var/www/bootstrap/cache /etc/ssl/apache2  /etc/ssl/apache2

# Enable necessary Apache modules
RUN sed -i 's|ErrorLog logs/error.log|ErrorLog stderr|' /etc/apache2/httpd.conf
RUN sed -i 's|CustomLog logs/access.log combined|CustomLog stdout combined|' /etc/apache2/httpd.conf

USER 1000

# Expose port 80
EXPOSE 80

# Start Supervisor to manage Apache and PHP-FPM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

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

# Create a non-root user to run Composer and Artisan Commands
RUN addgroup -g 1000 limitedaccessuser \
    && adduser -u 1000 -G limitedaccessuser -s /bin/sh -D limitedaccessuser

# Copy existing application directory permissions
COPY --chown=limitedaccessuser . /var/www

# Set working directory
WORKDIR /var/www

# Copy Apache vhost file to proxy php requests to php-fpm service
COPY vhost.conf /etc/apache2/conf.d/default.conf

# Copy supervisor configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure Apache
RUN mkdir -p /run/apache2 \
    && chown -R limitedaccessuser:limitedaccessuser /run/apache2 \
    && chown -R limitedaccessuser:limitedaccessuser /var/www/

# Give permissions to log files
RUN chown -R limitedaccessuser:limitedaccessuser /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 777 /var/www/storage /var/www/bootstrap/cache

# Enable necessary Apache modules
RUN sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule proxy_module/LoadModule proxy_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule proxy_fcgi_module/LoadModule proxy_fcgi_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule session_module/LoadModule session_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule session_cookie_module/LoadModule session_cookie_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule session_crypto_module/LoadModule session_crypto_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule slotmem_shm_module/LoadModule slotmem_shm_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule socache_shmcb_module/LoadModule socache_shmcb_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule fcgid_module/LoadModule fcgid_module/' /etc/apache2/httpd.conf

# Expose port 80
EXPOSE 80

# For the time being, we are switching to non root user to run the app. We should switch to the limitedaccessuser before starting supervisord.
USER root

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

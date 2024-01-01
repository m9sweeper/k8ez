# Use the official PHP image with FPM
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    apache2 \
    libapache2-mod-fcgid \
    supervisor

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create a non root user to run Composer and Artisan Commands
RUN groupadd -g 1000 appgroup \
    && useradd -u 1000 -ms /bin/bash -g appgroup appuser

# Copy existing application directory permissions
COPY --chown=appuser:appgroup ../code/hello-world /var/www

# Set working directory
WORKDIR /var/www

# Copy existing application directory permissions
COPY --chown=appuser:appgroup ../code/hello-world /var/www

# Copy Apache vhost file to proxy php requests to php-fpm service
COPY ../Debian/apache.conf /etc/apache2/sites-available/000-default.conf

# Copy supervisor configuration file
COPY ../Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Permissions
RUN chown -R appuser:appgroup /var/www/storage /var/www/bootstrap/cache  \
    && chmod -R 777 /var/www/storage /var/www/bootstrap/cache

RUN sed -i 's|ErrorLog ${APACHE_LOG_DIR}/error.log|ErrorLog stderr|' /etc/apache2/apache2.conf

# Enable Apache mods
RUN a2enmod proxy_fcgi
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord"]

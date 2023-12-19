# Use PHP 8.0 FPM based on Debian Buster
FROM php:8.0-fpm-buster

# Install nginx and supervisor
RUN apt-get update && \
    apt-get install -y nginx supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure Nginx
RUN rm -rf /var/www/html/*
COPY --chown=www-data:www-data ../code/index.php /var/www/html/index.php
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY --chown=www-data:www-data ../Debian/nginx.conf /etc/nginx/sites-available/default

# Configure Supervisord
COPY ../Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add a non-root user with specific UID (e.g., 1001)
RUN useradd -m -u 1001 limitedaccessuser
RUN chown -R limitedaccessuser:limitedaccessuser /var/www /var/log/nginx /var/lib/nginx /run

# Change to non-root user with specific UID
USER 1001

# Expose port 8080
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

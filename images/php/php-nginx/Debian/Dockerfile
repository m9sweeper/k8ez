# Use PHP 8.0 FPM based on Debian Buster
FROM php:8.0-fpm-buster

# Install nginx and supervisor
RUN apt-get update && \
    apt-get install -y nginx supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure Nginx
RUN rm -rf /var/www/html/*
COPY --chown=www-data:www-data index.php /var/www/html/index.php
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY --chown=www-data:www-data nginx.conf /etc/nginx/sites-available/default

# Configure Supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add a non-root user
RUN useradd -m limitedaccessuser
RUN chown -R limitedaccessuser:limitedaccessuser /var/www /var/log/nginx /var/lib/nginx /run

# Create the supervisor log directory and set permissions
RUN mkdir -p /var/log/supervisor && \
    chown -R limitedaccessuser:limitedaccessuser /var/log/supervisor

# Change to non-root user
USER limitedaccessuser

# Expose port 80
EXPOSE 80

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

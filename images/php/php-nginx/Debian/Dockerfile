# Use PHP 8.0 FPM based on Debian Buster
FROM php:8.0-fpm-buster

# Install nginx and supervisor
RUN apt-get update && \
    apt-get install -y nginx supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure Nginx
RUN rm -rf /var/www/html/*

# Add a non-root user with specific UID
RUN addgroup --gid 1001 appgroup && \
    useradd -m -u 1001 -g appgroup appuser

COPY --chown=appuser:appgroup ../code/ /var/www/html
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY --chown=appuser:appgroup ../Debian/nginx.conf /etc/nginx/conf.d/default.conf

# Configure Supervisord
COPY ../Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chown -R appuser:appgroup /var /run

# Redirect Nginx logs to stdout and stderr
RUN ln -sf /var/www/html/app_logs/access.log /dev/stdout && \
    ln -sf /var/www/html/app_logs/errors.log /dev/stderr

# Change to non-root user with specific UID
USER 1001

# Expose port 8080
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

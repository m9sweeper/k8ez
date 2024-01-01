# Use Alpine Linux as the base image
FROM alpine:latest

# Install apache (httpd) and supervisor
RUN apk add --no-cache apache2 supervisor

# Create a non-root user with UID and group
RUN addgroup -S appgroup && adduser -S -u 1000 -G appgroup appuser

# Create necessary directories for supervisor and pidfile
RUN mkdir -p /var/run/supervisor && \
    chown -R appuser:appgroup /var/run/supervisor /run/apache2

# Copy the custom httpd.conf to the container
COPY ../Alpine/httpd.conf /etc/apache2/conf.d/default.conf

# Copy the supervisord.conf to the container
COPY ../Alpine/supervisord.conf /etc/supervisord.conf

# Create a directory for static files and copy them
COPY ../code/build/ /var/www/localhost/htdocs/

# Modify the nginx.conf file to log errors to stderr
RUN sed -i 's|CustomLog logs/access.log combined|CustomLog /dev/stdout combined|' /etc/apache2/httpd.conf
RUN sed -i 's|ErrorLog logs/error.log|ErrorLog /dev/stderr|' /etc/apache2/httpd.conf

# Switch to the non-root user
USER 1000

# Expose the port Apache is listening on
EXPOSE 8080

# Start supervisord
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

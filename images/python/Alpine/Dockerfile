# Use Alpine base image with Python
FROM python:3.9-alpine

# Create and set working directory for the Django app
WORKDIR /var/www/myproject

# Install Apache and other necessary packages
RUN apk update \
    && apk add --no-cache apache2 apache2-utils apache2-dev supervisor && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/Listen 80/Listen 8080/' /etc/apache2/httpd.conf

# Install dependencies
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make \
    && pip install mod_wsgi \
    && apk del .build-deps

# Create a non root user and group for the application to run as
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the Django project files into the container
COPY ../code/myproject .

# Install Python dependencies
COPY ../code/myproject/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput
RUN mkdir -p /myproject/static

# Copy the Apache configuration for Django
COPY ../Alpine/apache.conf /etc/apache2/conf.d/

# Copy the Supervisor configuration file
COPY ../Alpine/supervisord.conf /etc/supervisord.conf

# Create log directories and set permissions
RUN mkdir -p /var/log/supervisor /var/run/ && \
    chown -R appuser:appgroup /var/log/supervisor /var/log/apache2 /var/run/ /var/www/logs

# Switch to non-root user
USER appuser

# Expose the port Apache is listening on
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

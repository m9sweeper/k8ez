# Use an Alpine-based Python image
FROM python:3.9-alpine

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Create and set the working directory
WORKDIR /var/www/myproject

# Install build dependencies for Apache and mod_wsgi
RUN apk update && \
    apk add --no-cache apache2 apache2-dev apache2-utils gcc libc-dev make python3-dev py3-pip supervisor && \
    apk add --virtual .build-deps && \
    pip install --upgrade pip && \
    apk del .build-deps

RUN apk add  apache2-mod-wsgi
RUN apk search apache2-mod

# Copy the Django project files into the container
COPY ../../code/myproject /var/www/myproject

# Create a non root user and group
RUN addgroup -S appuser && \
    adduser -S -G appuser -u 1001 appuser

# Create a directory for the Supervisor PID file and set permissions
RUN mkdir -p /home/appuser/supervisor /var/log/supervisor && chown -R appuser:appuser /home/appuser/supervisor \
    /var/www/myproject /var/log/supervisor /var/log/apache2/ /run/apache2 /home/appuser

# Install Python dependencies
COPY ../../code/myproject/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Sed command to output logs to stdout and stderr
RUN sed -i 's|ErrorLog .*|ErrorLog /dev/stderr|' /etc/apache2/httpd.conf
RUN sed -i 's|CustomLog .* combined|CustomLog /dev/stdout combined|' /etc/apache2/httpd.conf

# Copy the Apache and Supervisor configuration files
COPY ../apache/Alpine/apache.conf /etc/apache2/conf.d/default.conf
COPY ../apache/Alpine/supervisord.conf /etc/supervisor/conf.d/

# Switch to non-root user by UID
USER 1001

# Expose the port Apache is listening on
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

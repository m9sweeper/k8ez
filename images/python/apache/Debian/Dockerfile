# Use a Debian-based Python image
FROM python:3.9-slim

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Create and set the working directory
WORKDIR /var/www/myproject

# Update and install Apache, mod_wsgi, and Supervisor
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-wsgi-py3 supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the Django project files into the container
COPY ../../code/myproject /var/www/myproject

# Create a non root user and group
RUN groupadd -r appuser && \
    useradd -r -u 1001 -g appuser -m -d /home/appuser appuser

# Create a directory for the Supervisor PID file and set permissions
RUN mkdir -p /home/appuser/supervisor && chown -R appuser:appuser /home/appuser/supervisor  \
    /var/www/myproject /var/run/apache2 /home/appuser

# Install Python dependencies
COPY ../../code/myproject/requirements.txt .

RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Copy the Apache and Supervisor configuration files
COPY ../apache/Debian/apache.conf /etc/apache2/sites-available/000-default.conf
COPY ../apache/Debian/supervisord.conf /etc/supervisor/conf.d/

# Sed command to output logs to stdout and stderr
RUN sed -i 's|CustomLog ${APACHE_LOG_DIR}/other_vhosts_access.log vhost_combined|CustomLog /dev/stdout combined|' /etc/apache2/conf-available/other-vhosts-access-log.conf

# Switch to non-root user by UID
USER 1001

# Expose the port Apache is listening on
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

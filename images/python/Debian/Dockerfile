# Use a Debian-based Python image
FROM python:3.9-slim

# Create and set the working directory
WORKDIR /var/www/myproject

# Update and install Apache, mod_wsgi, and Supervisor
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-wsgi-py3 supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the Django project files into the container
COPY ../code/myproject/ .

# Create a non root user and group
RUN groupadd -r appuser && useradd -r -g appuser -m -d /home/appuser appuser

# Change ownership of directories to the non-root user
RUN chown -R appuser:appuser /var/www/myproject /var/log/apache2 /var/run/apache2 /var/run /var/lib/apache2 /var/log/supervisor /home/appuser

# Create a directory for the Supervisor PID file
RUN mkdir -p /home/appuser/supervisor && chown -R appuser:appuser /home/appuser/supervisor

# Install Python dependencies
COPY ../code/myproject/requirements.txt .

RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Copy the Apache and Supervisor configuration files
COPY ../Debian/apache.conf /etc/apache2/sites-available/000-default.conf
COPY ../Debian/supervisord.conf /etc/supervisor/conf.d/

# Switch to non-root user
USER appuser

# Expose the port Apache is listening on
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

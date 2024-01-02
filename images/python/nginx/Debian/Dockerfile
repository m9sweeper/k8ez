# Use a Debian-based Python image
FROM python:3.9-slim

# Create and set working directory for the Django app
WORKDIR /var/www/myproject

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install Nginx, Gunicorn, and other necessary packages
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y nginx supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/nginx

# Install dependencies
RUN pip install --upgrade pip
COPY ../../code/myproject/requirements.txt /var/www/myproject/
RUN pip install -r requirements.txt

# Copy the Django project files into the container
COPY ../../code/myproject/ /var/www/myproject/

# Collect static files
RUN python manage.py collectstatic --noinput

# Create log directories and set permissions
RUN mkdir -p /var/log/nginx /var/log/supervisor /var/log/gunicorn

# Copy Nginx and Supervisor configuration files
COPY ../nginx/Debian/nginx.conf /etc/nginx/nginx.conf
COPY ../nginx/Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create a non-root user
RUN groupadd -r django && useradd -r -g django -m django \
    && chown -R django:django /var/www/myproject /var/lib/nginx/ /run/

# Expose the port Nginx is listening on
EXPOSE 8080

# Switch to non-root user
USER django

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

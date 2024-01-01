# Use Alpine base image with Python
FROM python:3.9-alpine

# Create and set working directory for the Django app
WORKDIR /var/www/myproject

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install Nginx, Gunicorn, and other necessary packages
RUN apk update && apk upgrade \
    && apk add --no-cache nginx supervisor \
    && mkdir -p /run/nginx

# Install dependencies
RUN pip install --upgrade pip
COPY ../../code/myproject/requirements.txt /var/www/myproject/
RUN pip install -r requirements.txt

# Copy the Django project files into the container
COPY ../../code/myproject /var/www/myproject/

# Collect static files
RUN python manage.py collectstatic --noinput

# Create log directories and set permissions
RUN mkdir -p /var/log/nginx /var/log/supervisor /var/log/gunicorn

# Copy Nginx and Supervisor configuration files
COPY ../nginx/Alpine/nginx.conf /etc/nginx/nginx.conf
COPY ../nginx/Alpine/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create a non-root user
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup && \
    chown -R appuser:appgroup /var/www/myproject

# Expose the port Nginx is listening on
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

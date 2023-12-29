# Use Alpine base image with Python
FROM python:3.9-alpine

# Create and set working directory for the Django app
WORKDIR /var/www/myproject

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install Apache and other necessary packages
RUN apk update && apk upgrade \
    && apk add --no-cache apache2 apache2-utils apache2-dev supervisor && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/Listen 80/Listen 8080/' /etc/apache2/httpd.conf

# Install dependencies
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make \
    && pip install mod_wsgi \
    && apk del .build-deps

RUN pip install --upgrade pip

COPY ../code/myproject/requirements.txt /var/www/myproject/requirements.txt

RUN pip3 install -r requirements.txt

COPY ../Alpine/docker-entrypoint.sh /var/www/myproject/docker-entrypoint.sh
# Copy the Django project files into the container
COPY ../code/myproject .

# Collect static files
RUN python manage.py collectstatic --noinput
RUN mkdir -p /myproject/static

# Copy the Apache configuration for Django
COPY ../Alpine/apache.conf /etc/apache2/conf.d/

# Copy the Supervisor configuration file
COPY ../Alpine/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create non root user
RUN addgroup -g 1000 -S limitedaccessaccount && \
    adduser -u 1000 -S limitedaccessaccount -G limitedaccessaccount && \
    chown -R limitedaccessaccount:limitedaccessaccount /var/www/myproject && \
    chmod -R 0777 /var/www/myproject

# Create log directories and set permissions
RUN mkdir -p /var/log/supervisor /var/run/ && \
    chown -R limitedaccessaccount:limitedaccessaccount /var/log/supervisor /var/log/apache2 /var/run/ /var/www/logs

# Set non root user
USER 1000

# Expose the port Apache is listening on
EXPOSE 8080

# Start Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

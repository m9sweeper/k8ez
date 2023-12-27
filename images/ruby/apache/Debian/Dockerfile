# Use the official Ruby image based on Debian
FROM ruby:3.2.1

# Install dependencies including Nginx
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        build-essential \
        wget \
        gnupg \
        git \
        curl \
        openssh-client \
        supervisor \
        postgresql-client \
        libpq-dev \
        tzdata \
        nodejs \
        yarn \
        apache2 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable for installation path
ENV APP_NAME=hello-rails
ARG INSTALL_PATH=/opt/$APP_NAME
ENV INSTALL_PATH $INSTALL_PATH
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Set working directory for gems
WORKDIR /gems

# Copy Gemfile + Gemfile.lock
RUN gem install bundler

COPY ../code/$APP_NAME/Gemfile .
COPY ../code/$APP_NAME/Gemfile.lock .

# Preinstall gems. This will ensure that Gem Cache won't drop on code change
RUN (bundle check || bundle install)

RUN rails yarn:install && \
    rails assets:clobber && \
    rails assets:precompile

# Create app directory
WORKDIR $INSTALL_PATH

# Create a non-root user 'appuser' with UID 1001 and switch to it
RUN groupadd -g 1001 appgroup && useradd -u 1001 -g appgroup -m appuser \
    && mkdir -p $INSTALL_PATH \
    && chown appuser:appgroup $INSTALL_PATH

# Copy the app's code into the container
COPY --chown=appuser:appgroup ../code/$APP_NAME/ .

# Copy the supervisord.conf file into the container
COPY --chown=appuser:appgroup ../apache/Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy the Nginx configuration file into the container
COPY --chown=appuser:appgroup ../apache/Debian/apache.conf /etc/apache2/sites-available/apache.conf

# Modify Apache configurations
RUN sed -i 's|ErrorLog ${APACHE_LOG_DIR}/error.log|ErrorLog /dev/stderr|' /etc/apache2/apache2.conf && \
    sed -i 's|CustomLog ${APACHE_LOG_DIR}/other_vhosts_access.log vhost_combined|CustomLog /dev/stdout vhost_combined|' /etc/apache2/conf-available/other-vhosts-access-log.conf

# Make start_rails.sh executable
RUN chmod +x $INSTALL_PATH/start_rails.sh
RUN chown -R appuser:appgroup $INSTALL_PATH/start_rails.sh

# Create necessary directories for Apache and set permissions
RUN mkdir -p /var/run/apache2 /var/lock/apache2 && \
    chown -R appuser:appgroup /var/run/apache2 /var/lock/apache2

# Enable required Apache modules
RUN a2enmod proxy proxy_balancer proxy_http lbmethod_byrequests
RUN a2dissite 000-default
RUN a2ensite apache

# Change to the non-root user
USER 1001

# Expose the port Nginx is running on
EXPOSE 8080

# Set the default command to run supervisord as non-root user
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

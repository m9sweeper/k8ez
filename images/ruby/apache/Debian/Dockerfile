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
        nginx \
    && rm -rf /var/lib/apt/lists/*
# Install Apache
RUN apt-get update -qq && apt-get install -y apache2

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
RUN groupadd -g 1001 appuser && useradd -u 1001 -g appuser -m appuser \
    && mkdir -p $INSTALL_PATH \
    && chown 1001:appuser $INSTALL_PATH

# Copy the app's code into the container
COPY --chown=1001:appuser ../code/$APP_NAME/ .

# Create the log directory and give appuser ownership
#RUN mkdir -p /var/log/supervisor \
#    && chown -R 1001:appuser /var/log/supervisor /run/

# Copy the supervisord.conf file into the container
COPY --chown=1001:appuser ../apache/Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy the Nginx configuration file into the container
COPY --chown=1001:appuser ../apache/Debian/apache.conf /etc/apache2/sites-available/apache.conf
RUN chown -Rf www-data:www-data /var/
RUN chmod -Rf 777 /var/

# Make start_rails.sh executable
RUN chmod +x $INSTALL_PATH/start_rails.sh
RUN chown -R 1001:appuser $INSTALL_PATH/start_rails.sh

# Change to the non-root user
USER 1001

# Expose the port Nginx is running on
EXPOSE 80

# Set the default command to run supervisord as non-root user
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

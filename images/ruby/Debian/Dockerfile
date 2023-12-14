# Use the official Ruby image based on Debian
FROM ruby:3.2.2

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

# Set environment variable for installation path
ENV APP_NAME=hello-rails
ARG INSTALL_PATH=/opt/$APP_NAME
ENV INSTALL_PATH $INSTALL_PATH
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true


# Create necessary directories
RUN mkdir -p /gems /run/nginx /var/log/nginx

# Set working directory for gems
WORKDIR /gems

# Copy Gemfile + Gemfile.lock
RUN gem install bundler -v 2.2.22

COPY ../code/$APP_NAME/Gemfile .
COPY ../code/$APP_NAME/Gemfile.lock .

# Preinstall gems. This will ensure that Gem Cache won't drop on code change
RUN (bundle check || bundle install)

RUN rails yarn:install && \
    rails assets:clobber && \
    rails assets:precompile


# Create app directory
WORKDIR $INSTALL_PATH

# Create a non-root user 'appuser' and switch to it
RUN groupadd appuser && useradd -g appuser -m appuser \
    && mkdir -p $INSTALL_PATH \
    && chown appuser:appuser $INSTALL_PATH

# Copy the app's code into the container
COPY --chown=appuser:appuser ../code/$APP_NAME/ .

# Create the log directory and give appuser ownership
RUN mkdir -p /var/log/supervisor \
    && chown -R appuser:appuser /var/log/supervisor /var/log/nginx /var/lib/nginx /run/

# Copy the supervisord.conf file into the container
COPY --chown=appuser:appuser ../Debian/supervisord.conf /etc/supervisord.conf

# Copy the Nginx configuration file into the container
COPY --chown=appuser:appuser ../Debian/nginx.conf /etc/nginx/nginx.conf

# Make start_rails.sh executable
RUN chmod +x $INSTALL_PATH/start_rails.sh
RUN chown -R appuser:appuser $INSTALL_PATH/start_rails.sh

# Change to the non-root user
USER appuser

# Expose the port Nginx is running on
EXPOSE 80

# Set the default command to run supervisord as non-root user
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

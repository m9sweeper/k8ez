# Use the official Ruby image based on Alpine
FROM ruby:3.2.1-alpine

# label our docker file
LABEL repo='git.ascendlearning.com' \
      company='Intelletive' \
      team='Intelletive' \
      maintainer='mahmud.tarique@intelletive.com'

# Install dependencies including Nginx
RUN apk add --update --no-cache \
        build-base \
        wget \
        gnupg \
        git \
        curl \
        openssh \
        supervisor \
        postgresql-client \
        postgresql-dev \
        tzdata \
        nodejs \
        yarn \
        nginx \
    && rm -rf /var/cache/apk/*

# Set environment variable for installation path
ARG APP_NAME=hello-rails
ARG INSTALL_PATH=/opt/$APP_NAME
ENV INSTALL_PATH $INSTALL_PATH
ENV RAILS_ENV=production

# Create necessary directories
RUN mkdir -p /gems /run/nginx /var/log/nginx

# Set working directory for gems
WORKDIR /gems

# Copy Gemfile + Gemfile.lock
RUN gem install bundler

COPY ../code/$APP_NAME/Gemfile .
COPY ../code/$APP_NAME/Gemfile.lock .

# Preinstall gems. This will ensure that Gem Cache won't drop on code change
RUN (bundle check || bundle install)

RUN bundle exec rake yarn:install && \
    bundle exec rake assets:clobber && \
    bundle exec rake assets:precompile

# Create app directory
WORKDIR $INSTALL_PATH

# Create a non-root user 'appuser' and switch to it
RUN addgroup -S appuser && adduser -S appuser -G appuser \
    && mkdir -p $INSTALL_PATH \
    && chown appuser:appuser $INSTALL_PATH

# Copy the app's code into the container
COPY --chown=appuser:appuser ../code/$APP_NAME/ .

# Create the log directory and give appuser ownership
RUN mkdir -p /var/log/supervisor \
    && chown -R appuser:appuser /var/log/supervisor /var/log/nginx /var/lib/nginx /run/

# Copy the supervisord.conf file into the container
COPY --chown=appuser:appuser ../Alpine/supervisord.conf /etc/supervisord.conf

# Copy the Nginx configuration file into the container
COPY --chown=appuser:appuser ../Alpine/nginx.conf /etc/nginx/nginx.conf

# Make start_rails.sh executable
RUN chmod +x $INSTALL_PATH/start_rails.sh
RUN chown -R appuser:appuser $INSTALL_PATH/start_rails.sh

# Change to the non-root user
USER appuser

# Expose the port Nginx is running on
EXPOSE 80

# Set the default command to run supervisord as non-root user
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

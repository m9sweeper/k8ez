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

# Create necessary directories
RUN mkdir -p /gems /run/nginx /var/log/nginx

# Set working directory for gems
WORKDIR /gems

# Copy Gemfile + Gemfile.lock
RUN gem install bundler -v 2.2.22

COPY Gemfile .
COPY Gemfile.lock .

# Preinstall gems. This will ensure that Gem Cache won't drop on code change
RUN (bundle check || bundle install)

# Set environment variable for installation path
ARG INSTALL_PATH=/opt/hello-rails
ENV INSTALL_PATH $INSTALL_PATH

# Create app directory
WORKDIR $INSTALL_PATH

# Create a non-root user 'appuser' and switch to it
RUN groupadd appuser && useradd -g appuser -m appuser \
    && mkdir -p $INSTALL_PATH \
    && chown appuser:appuser $INSTALL_PATH

# Copy the app's code into the container
COPY --chown=appuser:appuser . .

# Create the log directory and give appuser ownership
RUN mkdir -p /var/log/supervisor \
    && chown -R appuser:appuser /var/log/supervisor /var/log/nginx /var/lib/nginx /run/

# Copy the supervisord.conf file into the container
COPY --chown=appuser:appuser supervisord.conf /etc/supervisord.conf

# Copy the Nginx configuration file into the container
COPY --chown=appuser:appuser nginx.conf /etc/nginx/nginx.conf

# Create scripts directory and start_rails.sh, make it executable
RUN mkdir -p $INSTALL_PATH/scripts \
    && echo '#! /bin/sh' > $INSTALL_PATH/scripts/start_rails.sh \
    && echo 'bundle exec rails db:migrate' >> $INSTALL_PATH/scripts/start_rails.sh \
    && echo 'bundle exec rails db:seed' >> $INSTALL_PATH/scripts/start_rails.sh \
    && echo 'bundle exec rails s -b 0.0.0.0' >> $INSTALL_PATH/scripts/start_rails.sh \
    && chmod +x $INSTALL_PATH/scripts/start_rails.sh \
    && chown -R appuser:appuser $INSTALL_PATH/scripts

# Change to the non-root user
USER appuser

# Expose the port Nginx is running on
EXPOSE 80

# Set the default command to run supervisord as non-root user
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

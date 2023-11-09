# Use the official Ruby image based on Alpine
FROM ruby:3.2.1-alpine

# Install dependencies
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
    && rm -rf /var/cache/apk/*

# Create a directory for gems
RUN mkdir /gems
WORKDIR /gems

# Copy Gemfile + Gemfile.lock
RUN gem install bundler -v 2.2.22

COPY Gemfile .
COPY Gemfile.lock .

# Preinstall gems. This will ensure that Gem Cache won't drop on code change
RUN (bundle check || bundle install)

ARG INSTALL_PATH=/opt/hello-rails
ENV INSTALL_PATH $INSTALL_PATH

WORKDIR $INSTALL_PATH

# Create a non-root user 'appuser' and switch to it
RUN addgroup -S appuser && adduser -S appuser -G appuser \
    && mkdir -p $INSTALL_PATH \
    && chown appuser:appuser $INSTALL_PATH

# Copy the app's code into the container
COPY --chown=appuser:appuser . .

# Create the log directory and give appuser ownership
RUN mkdir -p /var/log/supervisor \
    && chown -R appuser:appuser /var/log/supervisor

# Copy the supervisord.conf file into the container
COPY --chown=appuser:appuser supervisord.conf /etc/supervisord.conf

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

# Expose the port the app runs on
EXPOSE 3000

# Set the default command to run supervisord as non-root user
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

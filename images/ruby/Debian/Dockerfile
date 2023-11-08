# Use the official Ruby image based on Debian
FROM ruby:3.2.1-bullseye

# Install dependencies
RUN apt-get -y update && \
      apt-get install --fix-missing --no-install-recommends -qq -y \
        build-essential \
        wget gnupg \
        git-all \
        curl \
        ssh \
        supervisor \
        postgresql-client-13 libpq5 libpq-dev -y && \
      wget -qO- https://deb.nodesource.com/setup_12.x  | bash - && \
      apt-get install -y nodejs && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && \
      apt-get install yarn && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir /gems
WORKDIR /gems

# Copy Gemfile + Gemfile.lock
RUN gem install bundler -v 2.2.22

COPY Gemfile .
COPY Gemfile.lock .

## Preinstall gems. This will ensure that Gem Cache wont drop on code change
RUN (bundle check || bundle install)

ARG INSTALL_PATH=/opt/hello-rails
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY . .

# Create sctipts directory and start_rails.sh, make it executable
RUN mkdir -p $INSTALL_PATH//scripts \
    && echo '#! /bin/bash' > $INSTALL_PATH/scripts/start_rails.sh \
    && echo 'rails db:migrate' >> $INSTALL_PATH/scripts/start_rails.sh \
    && echo 'rails db:seed' >> $INSTALL_PATH/scripts/start_rails.sh \
    && echo 'rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0' >> $INSTALL_PATH/scripts/start_rails.sh \
    && chmod +x $INSTALL_PATH/scripts/start_rails.sh

# Expose the port the app runs on
EXPOSE 3000

CMD ["/usr/bin/supervisord"]

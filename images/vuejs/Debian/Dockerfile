FROM debian:latest

# Install Node.js, Yarn, Nginx, and Supervisor
RUN apt-get update && \
    apt-get install -y curl gnupg nginx supervisor && \
    curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists/*

# Copy the Vue.js application
COPY ../code /app
WORKDIR /app

# Build the Vue.js application
RUN yarn install && yarn build

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY ../Debian/nginx.conf /etc/nginx/sites-enabled/default

# Supervisor configuration
COPY ../Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port 80
EXPOSE 80

# Run Supervisor
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

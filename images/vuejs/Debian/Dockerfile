FROM debian:12.4

# Install Node.js, Yarn, Nginx, and Supervisor
RUN apt-get update && \
    apt-get install -y curl gnupg nginx supervisor && \
    curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user with a specific UID
RUN groupadd -g 1000 appgroup && \
    useradd -m -u 1000 -g appgroup -s /bin/bash appuser

# Copy the Vue.js application
COPY ../code /app

# Set the work directory
WORKDIR /app

# Change ownership of the /app directory to the new user
RUN chown -R appuser:appgroup /app

# Create necessary directories if not exist and set permission for nginx server
RUN mkdir -p /var/lib/nginx /usr/share/nginx && chown -R appuser:appgroup /var/lib/nginx /usr/share/nginx /run/

# Sed command to outpu logs to stdout and stderr
RUN sed -i 's|error_log /var/log/nginx/error.log;|error_log stderr;|' /etc/nginx/nginx.conf
RUN sed -i 's|access_log /var/log/nginx/access.log;|access_log stdout;|' /etc/nginx/nginx.conf

# Build the Vue.js application
RUN yarn install && yarn build

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY ../Debian/nginx.conf /etc/nginx/sites-enabled/default

# Supervisor configuration
COPY ../Debian/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Switch to the non-root user
USER 1000

# Expose port 8080
EXPOSE 8080

# Run Supervisor
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

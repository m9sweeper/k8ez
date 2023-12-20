# Stage 1: Build the Angular application
FROM node:alpine as build-stage

WORKDIR /app

# Copy package.json and package-lock.json
COPY ../code/package*.json /app/

# Install dependencies
RUN npm install

# Copy the Angular project files to the container
COPY ../code /app

# Build the project
RUN npm run ng build --prod

# Stage 2: Setup Nginx to serve the built Angular application
FROM nginx:alpine

# Remove the default Nginx configuration and files
RUN rm -rf /etc/nginx/conf.d/default.conf
RUN rm -rf /usr/share/nginx/html/*

# Copy the compiled build from the previous stage
COPY --from=build-stage /app/dist/code/browser /usr/share/nginx/html

# Custom Nginx configuration
COPY ../Alpine/nginx.conf /etc/nginx/nginx.conf

# Set UID and GID for user and group
ARG USER_UID=1001
ARG USER_GID=1001

# Create a non-root group and user with specified UID and GID
RUN addgroup -S nginxgroup -g ${USER_GID} && \
    adduser -S nginxuser -G nginxgroup -u ${USER_UID}

# Change ownership for the app directory
RUN chown -R nginxuser:nginxgroup /usr/share/nginx/html

# Create required directories and set permissions for Nginx
RUN mkdir -p /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi /var/lib/nginx/uwsgi /var/lib/nginx/scgi /var/cache/nginx /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R nginxuser:nginxgroup /var/lib/nginx /var/cache/nginx

# Update Nginx configuration to use a custom pid file location that the non-root user can access
RUN sed -i 's/^user  nginx;/user  nginxuser nginxgroup;/' /etc/nginx/nginx.conf && \
    sed -i 's/^pid.*/pid \/tmp\/nginx.pid;/' /etc/nginx/nginx.conf

# Switch to the non-root user with specified UID
USER ${USER_UID}

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

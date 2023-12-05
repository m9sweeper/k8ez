# Stage 1: Build the Angular application
FROM node:latest as build-stage

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
FROM debian:latest

# Install Nginx
RUN apt-get update && \
    apt-get install -y nginx --fix-missing && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/nginx/conf.d/default.conf && \
    rm -rf /usr/share/nginx/html/*

# Create a group and user
RUN groupadd -r nginxgroup && \
    useradd -r -g nginxgroup nginxuser

# Create required directories and set permissions for Nginx
RUN mkdir -p /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi /var/lib/nginx/uwsgi /var/lib/nginx/scgi /var/log/nginx /var/cache/nginx && \
    chown -R nginxuser:nginxgroup /var/lib/nginx /var/log/nginx /var/cache/nginx

# Copy the compiled build from the previous stage
COPY --from=build-stage /app/dist/code/browser /usr/share/nginx/html

# Copy the modified Nginx configuration file
COPY ../Debian/nginx.conf /etc/nginx/nginx.conf

# Set ownership for the app directory
RUN chown -R nginxuser:nginxgroup /usr/share/nginx/html

# Update Nginx configuration to use a custom pid file location that the non-root user can access
RUN sed -i 's/^user  nginx;/user  nginxuser nginxgroup;/' /etc/nginx/nginx.conf && \
    sed -i 's/^pid.*/pid \/tmp\/nginx.pid;/' /etc/nginx/nginx.conf

# Switch to the non-root user
USER nginxuser

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

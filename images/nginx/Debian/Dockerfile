# Stage 1: Build the React application
FROM node:latest as build
WORKDIR /app
COPY ../code/package.json ../code/package-lock.json ./
RUN npm install
COPY ../code ./
RUN npm run build

# Stage 2: Serve the application with Nginx on Debian
FROM debian:stable-slim
RUN apt-get update && apt-get install -y nginx && apt-get clean
RUN addgroup --system limitedaccessgroup && adduser --system --ingroup limitedaccessgroup limitedaccessuser

# Create and set permissions for necessary Nginx folders
RUN mkdir -p /www /var/log/nginx /var/lib/nginx/body /var/lib/nginx/fastcgi /var/lib/nginx/proxy /var/lib/nginx/scgi /var/lib/nginx/uwsgi /var/cache/nginx /var/run && \
    chown -R limitedaccessuser:limitedaccessgroup /www /var/log/nginx /var/lib/nginx /var/cache/nginx /var/run /run
RUN chmod -R 755 /run/
# Copy built static files
COPY --from=build /app/build /www

# Copy Nginx configuration files
COPY ../Debian/nginx.conf /etc/nginx/sites-available/default

# Modify Nginx configuration as root
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Switch to the non-root user
USER limitedaccessuser

EXPOSE 8080
CMD ["nginx"]

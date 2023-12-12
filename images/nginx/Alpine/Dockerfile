# Stage 1: Build the React application
FROM node:latest as build
WORKDIR /app
COPY ../code/package.json ../code/package-lock.json ./
RUN npm install
COPY ../code ./
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM alpine:latest
RUN apk add --no-cache nginx
RUN addgroup -S limitedaccessgroup && adduser -S limitedaccessuser -G limitedaccessgroup

# Create and set permissions for Nginx folders
RUN mkdir -p /www /var/log/nginx /var/lib/nginx/tmp /var/run && \
    chown -R limitedaccessuser:limitedaccessgroup /www /var/log/nginx /var/lib/nginx/tmp /var/run /run/

RUN chmod -R 755 /var/lib/nginx/ /run/

# Copy built static files
COPY --from=build /app/build /www

# Copy Nginx configuration files
COPY ../Alpine/nginx.conf /etc/nginx/http.d/default.conf

# Modify Nginx configuration as root
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Switch to the non-root user
USER limitedaccessuser

EXPOSE 8080
CMD ["nginx"]

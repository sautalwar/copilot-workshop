FROM nginx:alpine

# Copy nginx configuration
COPY presentation/nginx.conf /etc/nginx/conf.d/default.conf

# Copy the presentation HTML
COPY workshop-outfront.html /usr/share/nginx/html/index.html

EXPOSE 80

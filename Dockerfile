FROM nginx:alpine
COPY workshop.html /usr/share/nginx/html/index.html
COPY presentation.html /usr/share/nginx/html/presentation.html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

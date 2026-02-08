FROM nginx:1.29.5-alpine3.23
COPY website/. /usr/share/nginx/html
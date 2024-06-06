FROM alpine:3.16.9

WORKDIR /app

RUN apk update && \
    apk add --no-cache nginx

COPY nginx/index.html /var/www/html/index.html
COPY nginx/default.conf /etc/nginx/http.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

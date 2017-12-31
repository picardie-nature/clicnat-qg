FROM ndamiens/nginx-php:latest

RUN mkdir /etc/baseobs
COPY htdocs /opt/app/www
COPY smarty /opt/app/smarty
COPY composer.json composer.lock ./
RUN composer install -o

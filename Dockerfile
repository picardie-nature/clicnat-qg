FROM ndamiens/nginx-php:latest

RUN mkdir /etc/baseobs
COPY htdocs /opt/app/www
COPY smarty /opt/app/smarty
COPY composer.json composer.lock ./
RUN composer install -o
RUN mkdir -p /opt/app/www/assets/morris/ && cp vendor/morrisjs/morris.js/morris.js vendor/morrisjs/morris.js/morris.css vendor/morrisjs/morris.js/morris.min.js /opt/app/www/assets/morris/
RUN mkdir -p /opt/app/www/assets/raphael/ && cp vendor/sheillendra/raphael/raphael.js vendor/sheillendra/raphael/raphael-min.js /opt/app/www/assets/raphael/
RUN mkdir -p /opt/app/www/assets/jquery/ && cp vendor/components/jquery/jquery*.js /opt/app/www/assets/jquery/
RUN mkdir -p /opt/app/www/assets/jqueryui/ && cp -a vendor/components/jqueryui/jquery-ui*.js vendor/components/jqueryui/themes /opt/app/www/assets/jqueryui/
RUN mkdir -p /opt/app/www/assets/bootstrap/ && cp -a vendor/components/bootstrap/css vendor/components/bootstrap/img vendor/components/bootstrap/js /opt/app/www/assets/bootstrap/

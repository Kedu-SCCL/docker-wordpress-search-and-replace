FROM php:7.3.6-apache
#RUN source .env
#FROM ${APP_IMAGE}:${APP_VERSION}
MAINTAINER info@kedu.coop

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apt-get update && apt-get install  -y \
  libpng-dev \
  libmcrypt-dev

RUN docker-php-ext-install gd

#RUN docker-php-ext-install mcrypt

RUN a2enmod rewrite

WORKDIR /var/www/html/

EXPOSE 80

# By default, simply start apache.
#CMD ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

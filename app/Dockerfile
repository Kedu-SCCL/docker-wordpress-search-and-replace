ARG IMAGE

ARG VERSION

FROM $IMAGE:$VERSION

MAINTAINER info@kedu.coop

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apt-get update && apt-get install  -y \
  libpng-dev \
  libmcrypt-dev

RUN docker-php-ext-install gd

#RUN docker-php-ext-install mcrypt

RUN a2enmod rewrite

COPY search-replace-wp-kedu /search-replace-wp-kedu

WORKDIR /var/www/html/

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

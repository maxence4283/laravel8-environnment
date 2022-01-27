FROM php:8.0-fpm-alpine

ADD ressources /

RUN apk upgrade --update && apk add --no-cache tzdata libzip-dev zlib-dev freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev nodejs-current npm \
        && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo "Europe/Paris" >  /etc/timezone \
        && docker-php-ext-configure gd  \
        && docker-php-ext-configure zip \
        && docker-php-ext-configure pcntl \
        && docker-php-ext-install  pcntl gd zip pdo_mysql \
        && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
        && php composer-setup.php && php -r "unlink('composer-setup.php');" \
        && mv composer.phar /usr/local/bin/composer \
        && mkdir -p /var/www/html ; chown www-data:www-data -R /var/www

# php-redis
ENV PHPREDIS_VERSION="5.3.2"

RUN docker-php-source extract \
    && curl -L -o /tmp/redis.tar.gz "https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz" \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && docker-php-source delete

WORKDIR /var/www/html

USER www-data

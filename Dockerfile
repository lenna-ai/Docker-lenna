ARG VOLUMES_DRIVER
ARG PUID
ARG PGID
FROM php:7.4-fpm

LABEL maintainer="Nur Arifin <arifin@lenna.ai>"

WORKDIR /var/www

RUN apt-get update

RUN set -eux; \
    apt-get upgrade -y; \
    apt-get update; \
    apt-get install -y\
        libzip-dev \
        zip \
        unzip \
        supervisor \
        git \
        zlib1g-dev \
        curl \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libwebp-dev \
        libxpm-dev \
        libmcrypt-dev \
        libonig-dev; \
        rm -rf /var/lib/apt/lists/*

# RUN apt-get install libgmp-dev

# RUN apt-get install -y php-dev
RUN apt-get install autoconf
# RUN apt-get install php-pear

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#RUN pecl install grpc


RUN docker-php-ext-install \
        gd pdo pdo_pgsql pdo_mysql zip sockets bcmath opcache\
    && docker-php-ext-enable \
        gd pdo pdo_pgsql pdo_mysql zip sockets  bcmath opcache

# RUN echo ${VOLUMES_DRIVER}

# RUN usermod -u 1000 www-data
RUN groupmod -o -g 82 www-data && \
    usermod -o -u 82 -g www-data www-data
# RUN set -x ; \
#     addgroup -g 82 -S www-data ; \
#     adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1
RUN rm -rf /var/cache/apk/*
ADD ${VOLUMES_DRIVER} /var/www
RUN chown -R www-data:www-data /var/www/
RUN chown www-data:www-data /var/www/
RUN chmod -R 777 /var/www

# RUN composer install -d=/var/www/backend

USER www-data


EXPOSE 9000
CMD ["php-fpm"]




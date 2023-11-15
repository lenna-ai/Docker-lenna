FROM php:7.4-fpm-alpine

RUN mkdir -p /var/log/supervisor/

RUN apk --no-cache add postgresql-dev

RUN apk update

RUN set -eux; \
    apk upgrade; \
    apk update; \
    apk add --no-cache\
        cron \
        build-essential \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        locales \
        libzip-dev \
        zip \
        jpegoptim optipng pngquant gifsicle \
        vim \
        unzip \
        graphviz \
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
        libonig-dev; 

RUN docker-php-ext-install \
        gd pdo pdo_pgsql pgsql pdo_mysql zip sockets bcmath opcache

RUN apk update && apk add --no-cache supervisor

RUN mkdir -p "/etc/supervisor/logs"

COPY ./docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf


COPY ./docker/supervisor/mycronjob.txt /etc/cron.d/crontab
RUN chmod 777 /etc/cron.d/crontab

# Apply cron job

RUN crontab /etc/cron.d/crontab

RUN touch /var/log/cron.log
RUN chmod -R 777 /var/log/cron.log

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]

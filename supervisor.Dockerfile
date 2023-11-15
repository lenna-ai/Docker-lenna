FROM php:7.4-fpm-alpine

RUN mkdir -p /var/log/supervisor/

RUN apk --no-cache add postgresql-dev

RUN apk update

RUN set -eux; \
    apk upgrade; \
    apk update; \
    apk add --no-cache\
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
        libssl-dev \
        libwebp-dev \
        libxpm-dev \
        libmcrypt-dev \
        rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_pgsql

RUN apk update && apk add --no-cache supervisor

RUN mkdir -p "/etc/supervisor/logs"

COPY ./docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./docker/supervisor/mycronjob.txt /etc/cron.d/mycronjob
RUN chmod 0644 /etc/cron.d/mycronjob

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]

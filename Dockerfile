FROM php:8.1-fpm-alpine3.17

WORKDIR /var/www

ENV APP_ENV=prod \
  POSTGRES_DB='' \
  POSTGRES_USER=medleybox \
  POSTGRES_PASSWORD='' \
  TZ='Europe/London' \
  PAGER='busybox less' \
  MINIO_ENDPOINT='http://minio:9000' \
  REDIS_VERSION='5.3.7' \
  REDIS_URL='redis://redis'

RUN apk add --no-cache --virtual .build-deps \
    autoconf \
    binutils \
    freetype-dev \
    g++ \
    git \
    icu-dev \
    libxml2-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libzip-dev \
    make \
    postgresql-dev \
    tar \
  && apk add --no-cache \
    freetype \
    icu-libs \
    libjpeg-turbo \
    libpng \
    libwebp \
    libxslt \
    libzip \
    tzdata \
    postgresql-libs \
  && echo "https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz" \
  && curl -L -o /tmp/redis.tar.gz "https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz" \
  && tar xfz /tmp/redis.tar.gz \
  && rm -r /tmp/redis.tar.gz \
  && mkdir -p /usr/src/php/ext \
  && mv phpredis-* /usr/src/php/ext/redis \ 
  && docker-php-ext-install -j "$(getconf _NPROCESSORS_ONLN)" \
    exif \
    gd \
    intl \
    opcache \
    pdo_pgsql \
    redis \
    zip \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/* /usr/src

COPY www.conf /usr/local/etc/php-fpm.d/www.conf

HEALTHCHECK --interval=20s --timeout=5s --start-period=30s \  
  CMD bin/docker-console

RUN php -i; php -v
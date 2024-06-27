ARG PHP_VERSION=8
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

WORKDIR /var/www

ENV APP_ENV=prod \
  POSTGRES_HOST='db' \
  POSTGRES_DB='' \
  POSTGRES_USER=medleybox \
  POSTGRES_PASSWORD='' \
  TZ='Europe/London' \
  PAGER='busybox less' \
  MINIO_ENDPOINT='http://minio:9000' \
  REDIS_VERSION='5.3.7' \
  REDIS_URL='redis://redis' \
  FPM_WORKERS='4' \
  FPM_MEMORY_LIMIT='128M'

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

ENTRYPOINT ["/docker-entrypoint"]

COPY docker-entrypoint /docker-entrypoint

RUN php -i; php -v; mkdir -p /var/www/bin; echo "echo 'medleybox'; docker-php-entrypoint php-fpm" > /var/www/bin/docker-entrypoint; chmod +x /var/www/bin/docker-entrypoint \
  && chown 82:82 /usr/local/etc/php-fpm.d/www.conf

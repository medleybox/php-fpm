# PHP FPM Docker image
> PHP 8 Alpine fpm docker image

PHP `v8.3.2` Alpine `v3.18` fpm docker image to run PHP code with the following extensions installed:
- exif
- gd
- intl
- opcache
- pdo_pgsql
- redis
- zip

## Using latest version
```
FROM ghcr.io/medleybox/php-fpm:master

COPY . /app
```

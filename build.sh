#!/bin/sh

PHP_VERSION=`php latest.php`

docker build . --build-arg="PHP_VERSION=$PHP_VERSION" -t ghcr.io/medleybox/php-fpm:${PHP_VERSION}
docker tag ghcr.io/medleybox/php-fpm:${PHP_VERSION} ghcr.io/medleybox/php-fpm:master
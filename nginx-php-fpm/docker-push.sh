#!/usr/bin/env bash
set -x
set -e

#docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker login
docker build --rm --pull -t alliage/nginx-php-fpm:7.4 -t alliage/nginx-php-fpm:latest .

#(cd 8.0/base && docker build --rm --pull -t alliage/nginx-php-fpm:8.0 -t alliage/nginx-php-fpm:latest .)
#(cd 8.0/php-all-exts && docker build --rm -t alliage/nginx-php-fpm:8.0-all-exts -t alliage/nginx-php-fpm:latest-all-exts .)
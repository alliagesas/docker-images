#!/usr/bin/env bash

VERSION="8.4"

docker build -t php-fpm -f "Dockerfile-${VERSION}" .
# Changement de version de PHP ?"
docker image tag php-fpm alliage/php-fpm:${VERSION}
# Définition du tag "latest"
docker image tag php-fpm alliage/php-fpm:latest
# Identification
#docker login -u "alliage" -p "PASSWORD"
docker push --all-tags alliage/php-fpm
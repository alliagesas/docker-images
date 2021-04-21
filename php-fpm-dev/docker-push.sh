docker build -t php-fpm-dev .
# Changement de version de PHP ?"
#docker image tag php-fpm-prod alliage/php-fpm-prod:[NUM_VERSION]
# Définition du tag "latest"
docker image tag php-fpm-dev alliage/php-fpm-dev:latest
docker push --all-tags alliage/php-fpm-dev
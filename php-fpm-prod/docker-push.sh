docker build -t php-fpm-prod .
# Changement de version de PHP ?"
#docker image tag php-fpm-prod alliage/php-fpm-prod:[NUM_VERSION]
# Définition du tag "latest"
docker image tag php-fpm-prod alliage/php-fpm-prod:latest
# Identification
#docker login -u "alliage" -p "PASSWORD"
docker push --all-tags alliage/php-fpm-prod
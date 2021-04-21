#FROM debian:stretch
# PHP-FPM:7.4:buster
FROM alliage/php-fpm-dev:7.4

MAINTAINER  Alliage <tech@alliage-maintenance.com>

# PHP
COPY php/php-fpm.conf.tpl /tmp/php-fpm.conf.tpl
#RUN mkdir -p /run/php && touch /run/php/php7.0-fpm.sock && touch /run/php/php7.0-fpm.pid
# Script permettant l'arrêt du conteneur en cas d'erreur grave sur PHP-FPM
# Voir supervisor/supervisord.conf
COPY stop-container.php /stop-container.php


# SUPERVISORD
#RUN apt-get -qq update > /dev/null && apt-get -qq upgrade -y > /dev/null; \
#    apt-get -qq install -y ... supervisor  > /dev/null;
RUN apt-get update && apt-get install -y supervisor
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# NGINX
RUN apt-get install -y nginx
RUN rm -f /etc/nginx/sites-enabled/*
COPY nginx/nginx.conf.tpl /tmp/nginx.conf.tpl


# REDIRECTION DES LOGS & ERREURS
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php7.0-fpm.log

# SCRIPT DE DEMARRAGE
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

# BIBLIOTHEQUES COMMUNES
RUN apt-get install -y gettext-base

CMD ["/entrypoint.sh"]

EXPOSE 80
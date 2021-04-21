# Installation et configuration d'un serveur Nginx Proxy avec support SSL

Références:
https://github.com/evertramos/nginx-proxy-automation
https://hub.docker.com/r/jwilder/nginx-proxy
https://olex.biz/2019/09/hosting-with-docker-nginx-reverse-proxy-letsencrypt/#nginx-reverse-proxy-and-ssl
https://github.com/nginx-proxy/acme-companion

## Server proxy Nginx
Avant toute nouvelle installation, il faut tout d'abord lancer un conteneur Docker basé sur nginx-proxy.
Celui-ci fera aussi de proxy/HA sur les instances clientes.

Créer le réseau "proxy", utilisé par les conteneurs de l'application:
```
sudo docker network create proxy
```

Lancer les conteneurs nginx-proxy et letsencrypt (certificats SSL)
```
docker-compose -f docker-compose-proxy.yml
```


## Rôle des dossiers et fichiers
```
./data # Dossier créé automatiquement, qui contient les certificats et autres configurations dynamiquement générés.
./conf.d/proxy.conf # Options pour le proxy Nginx
```

## Lancer les services:
```
docker-compose up -d
```
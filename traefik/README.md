# Installation et configuration de Traefik

Voir plus d'infos sur:

* [https://doc.traefik.io/traefik](https://doc.traefik.io/traefik/)/
* [https://www.it-connect.fr/tuto-traefik-reverse-proxy-avec-docker/](https://www.it-connect.fr/tuto-traefik-reverse-proxy-avec-docker/)

Traefik est un load-balancer automtique gérant les services déployés via Docker. Il gère également de façon automatique (client ACME) la création et le renouvellement des certificats SSL nécessaires pour les connexions HTTPS.

## Installer un nouveau service

Traefik détecte automatiquement les nouveaux services lancés sur Docker. Ceux-ci doivent néamoins déclarer certains "labels" pour être reconnu par Traefik et pour une bonne configuration.


Exemple d'un docker-compose.yml:

```
services: 

[...]
      nginx:
          - image: nginx/latest
labels: # TRAEFIK
      - traefik.enable=true # Activation du service dans Traefik
      - traefik.docker.network=proxy # Nom du réseau "proxy"
      #- traefik.http.routers.owncloud.rule=Host(`${OWNCLOUD_DOMAIN:-cloud.pingat.com}`) # ATTENTION: traefik.http.routers.[APP_NAME].XXX
      - traefik.http.routers.owncloud.rule=Host(`${OWNCLOUD_DOMAIN}`)
      - traefik.http.routers.owncloud.entrypoints=websecure
      - traefik.http.services.owncloud.loadbalancer.server.port=8080 # NECESSAIRE ICI car Owncloud écoute sur le port 8080
      - traefik.http.routers.owncloud.tls=true # Activation du SSL
      - traefik.http.routers.owncloud.tls.certresolver=letencrypt # Client ACME
```

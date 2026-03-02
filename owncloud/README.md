# Owncloud sur Cloud Pingat

Installation de l'application Owncloud via Docker et derriére un proxy Traefik/

Voir [https://doc.owncloud.com/server/next/admin_manual/installation/docker/#docker-compose-yaml-file](https://doc.owncloud.com/server/next/admin_manual/installation/docker/#docker-compose-yaml-file)

## Configuration du service

Modifier le fichier .env

* OWNCLOUD_DOMAIN: Nom de domaine (ou sous-domaine) principal où est installé Owncloud
* OWNCLOUD_TRUSTED_DOMAINS: liste (séparés par une virgule) des nom de domaines (ou sous-domaines) où Owncloud doit répondre
* HTTP_PORT: laisser 80, Traefik ne prendra pas cette valeur.

### Définir le dossier de stockage des fichiers

Le dossier de stockage d'Owncloud est définit dans le fichier docker-compose.yml.

Par défaut c'est le dossier ./data. Le dossier de stockage des fichiers est ./data/files. Le cas échéant, on peut monter un dossier existant via docker-compose.yml

```
volumes:
      - ./data:/mnt/data
      - ./data/files:/var/www/owncloud/data
```

## Lancer le service

* [ ]  root@docker# cd /opt/owncloud/
* [ ]  root@docker# docker compose up -d

## Exécuter des commandes occ

* [ ]  root@docker# cd /opt/owncloud/
* [ ]  root@docker# docker compose exec owncloud occ "command"

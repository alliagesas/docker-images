# Configuration du service Collabora (Online Office)

L'image docker de Collabora est disponible à l'adresse suivate, ainsi que la documentation [https://hub.docker.com/r/collabora/code](https://hub.docker.com/r/collabora/code)

La configuration complète est disponible sur [https://sdk.collaboraonline.com/docs/installation/CODE_Docker_image.html](https://sdk.collaboraonline.com/docs/installation/CODE_Docker_image.html)

Il existe plusieurs variables d'environnement qu'il faut paramétrer pour lancer le service Collabora: (voir fichier [docker-compose.yml](docker-compose.yml)). Pour les modifier, il faut utiliser le fichier .env placer à la racine du projet (au même niveau que docker-compose.yml)

Pour la configuration derrière un proxy (Apache / NGinx / NGinx-proxy-auto) voir [https://sdk.collaboraonline.com/docs/installation/Proxy_settings.html](https://sdk.collaboraonline.com/docs/installation/Proxy_settings.html)

# Adresse FQDN du serveur collabora
COLLABORA_VIRTUAL_HOST=collabora.eiffidev.alliage-maintenance.com
# Mettre l'adresse FQDN du serveur Collabora (collabora.mondomaine.com) pour activer le support SSL, sinon laisser vide
COLLABORA_VIRTUAL_HOST_SSL=
# Numéro de port d'écoute du service
COLLABORA_PORT=9980
# ATTENTION, les urls ci-dessous doivent échapper les "points". Eg: www.domaine.com => www\.domaine\.com
COLLABORA_ALIAS_GROUP1=https://collabora\.eiffidev\.alliage-maintenance\.com
COLLABORA_ALIAS_GROUP2=https://eiffidev\.alliage-maintenance\.com,https://dev\.eiffidev\.alliage-maintenance\.com
# Nom de l'utilisateur administrateur
COLLABORA_ADMIN_USER=admin
# Mot de passe de l'administrateur
COLLABORA_ADMIN_PASSWORD=admin
## Visualier les logs

En cas d'erreurs les logs sont visibles via la commande: `root@host:~/eiffidev# docker logs -f collabora`

## Relancer Collabora

`root@host:~/collabora# docker-compose down && docker-compose up -d --build`

## Erreurs fréquentes:

En cas d'erreur, vérifier que vous avez bien accès à Collabora depuis votre navigateur: http(s)://[COLLABORA_URL/, il doit s'afficher OK.

Erreur 503 Service Temporarily Unavailable: le service nginx-proxy (web frontal) ne trouve pas collabora, vérifier la variable "VIRTUAL_HOST" dans les fichiers [.env](../.env) et [docker-compose.yml](docker-compose.yml) du dossier collabora, puis relancer le service Collabora (voir ci-dessous). Patientez quelques secondes (max 1min) avant de retenter d'accéder à Collabora.

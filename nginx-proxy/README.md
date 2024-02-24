# Installation du composant nginx-proxy, serveur Web frontal

Nginx-proxy est un micro-service tournant sous Docker. Celui-ci reçoit toutes les connexions clients en frontal, et distribue les demandes aux sous-service (Nginx, PHP, Mysql, etc...)

La documentation complète est disponible à l'adresse suivante: [https://github.com/evertramos/nginx-proxy-automation](https://github.com/evertramos/nginx-proxy-automation)

Au 1er lancement, lancer le script [setup.sh](setup.sh) directement en console, puis suivez les indications affichées.

## Lancement des sous-applications ou sites

Chaque sous-site, ou application doit être lancée depuis des containers Docker avec les variables d'environnement suivantes:

```
VIRTUAL_HOST=your.domain.com
LETSENCRYPT_HOST=your.domain.com
LETSENCRYPT_EMAIL=your.email@your.domain.com
NETWORK=proxy
```

* VIRTUAL_HOST: adresse FQDN de votre application ou site (sans le http:// !)
* LETSENCRYPT_HOST: adresse FQDN de l'application SI elle doit être proposée via https- (certificat SSL). Celui-ci sera alors automatiquement généré et renouvelé.
* LETSENCRYPT_EMAIL: adresse email recevant les notifications lors du renouvellement du certificat SSL. Non requis si le certificat SSL n'est pas utilisé.
* NETWORK: nom du réseau au sein des services Docker. "proxy" par défaut. Ne pas changer sauf si vous savez ce que vous faites.

Ces variables doivent être définies dans le fichier .env de chaque application et/ou service.

## Relancer le service nginx-proxy

Dans certains cas, il est nécessaire de relancer le service, par exemple lors de modifications manuelles dans la configuration.

```
root@host:~/eiffidev# docker exec -it proxy-web-auto nginx -s reload
```

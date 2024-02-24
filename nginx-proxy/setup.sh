#!/usr/bin/env bash

# Get current script dirname
SCRIPT_PWD=`pwd`

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $DIR

# Suppression du dossier s'il existe déjà
[ -d proxy ] && rm -fR proxy
## Création du dossier de stockage du composant
mkdir proxy
## Récupération du code source
git clone --recurse-submodules https://github.com/evertramos/nginx-proxy-automation.git proxy
## Lancement de la 1ere installation
cd proxy/bin
## ... attention, le paramétre --user-nginx-conf-files est TRES important ici, il permet de configurer les realip et fichiers uploadés (100Mo)
./fresh-start.sh --use-nginx-conf-files --yes --default-email="tech@alliage-maintenance.com"

# Redémarrage des services
cd ../
docker-compose down && docker-compose up -d --build

cd $SCRIPT_PWD
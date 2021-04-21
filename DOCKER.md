# Paquets & logiciels requis

## Docker & Docker-compose
```
# Mise à jour des paquets
apt-get update && apt-get upgrade -y

# Suppression des paquets existants
apt-get remove docker docker-engine docker.io containerd runc

# Installer Docker via Docker's repository
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Add Docker's repository
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Install Docker package
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
```
## Git
```
apt-get update -y && apt-get install git
```

## Gestion des conteneurs Docker
Les conteneurs peuvent être manipulés et gérés via une application "Portainer", ou directement en lignes de commandes.

### Application Portainer
```
# Installer Portainer
$ docker volume create portainer_data
$ docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```
Il suffit ensuite d'ouvrir un navigateur http://localhost:9000 pour accéder à Portainer et gérer les conteneurs.
    
### Administration en lignes de commandes
Toutes ces commandes doivent être exécutées dans le répertoire de l'application et sous l'utilisateur root ou ayant droits.
    
```cd /home/Batigam-API```

1. Démarrage initial
    ```
    docker-compose up -d
    ```
2. Arrêt des services
    ```
    docker-compose down
    ```
3. Redémarrage des services
    ```
    docker-compose down
    docker-compose up -d
    ```
    
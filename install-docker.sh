#!/bin/bash
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
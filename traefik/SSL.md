# Gestion des certificats SSL sous Traefik

## 1. Créer la CA et signer le certificat serveur

```bash
umask 077

mkdir -p ~/pingat-pki
cd ~/pingat-pki
```

### Clé privée et certificat racine de la CA

```bash
openssl genrsa -out pingat-root-ca.key 4096
openssl req -x509 -new -sha256 \
-key pingat-root-ca.key \
-days 3650 \
-out pingat-root-ca.crt \
-subj "/C=FR/O=Pingat/CN=Pingat Intranet Root CA"
```

### Clé et demande de certificat du serveur Traefik

```bash
openssl genrsa -out pingat.lan.key 2048
openssl req -new -sha256 \
-key pingat.lan.key \
-out pingat.lan.csr \
-subj "/C=FR/O=Pingat/CN=pingat.lan"
```

### Extensions du certificat : le SAN doit contenir le nom utilisé par les clients

```bash
cat > pingat-wildcard.ext <<'EOF'
basicConstraints = critical,CA:FALSE
keyUsage = critical,digitalSignature,keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = DNS:*.pingat.lan,DNS:pingat.lan,DNS:*.intranet.pingat.lan
EOF
```

### Signature par la CA

```bash
openssl x509 -req -sha256 \
-in pingat.lan.csr \
-CA pingat-root-ca.crt \
-CAkey pingat-root-ca.key \
-CAcreateserial \
-out pingat.lan.crt \
-days 397 \
-extfile pingat-wildcard.ext
```

### Vérifier le certificat et son nom

```bash
openssl verify -CAfile pingat-root-ca.crt pingat.lan.crt
openssl x509 -in pingat.lan.crt -noout -ext subjectAltName
```

Conservez pingat-root-ca.key hors du serveur Traefik, idéalement hors ligne et sauvegardée de manière sécurisée. Ne la distribuez jamais aux postes clients. Les clients ne reçoivent que pingat-root-ca.crt.

## 2. Installer la CA sur les postes clients

Distribuez pingat-root-ca.crt aux postes par votre outil de gestion ou stratégie de domaine. Par exemple, sur Debian/Ubuntu :

```bash
sudo install -m 0644 pingat-root-ca.crt
/usr/local/share/ca-certificates/pingat-root-ca.crt
sudo update-ca-certificates
```

Sur Windows en invite de commandes administrateur :

```dos
certutil -addstore -f Root pingat-root-ca.crt
```

Pour un parc Windows joint à un domaine, préférez le déploiement via GPO dans Autorités de certification racines de confiance. Les applications qui utilisent leur propre magasin de certificats peuvent demander une installation spécifique.

## 3. Configurer Traefik

Exemple pour Traefik v2/v3 avec le fournisseur de fichiers. Sur l’hôte, placez les fichiers ainsi :

```text
./traefik/
├── traefik.yml
├── dynamic/
│   └── tls.yml
├── certs/
│   └── pingat.lan.crt
│   └── pingat.lan.key
```

Copiez les fichiers serveur depuis le répertoire de création :

```bash
cp ~/pingat-pki/pingat.lan.crt ./traefik/certs/
cp ~/pingat-pki/pingat.lan.key ./traefik/certs/
chmod 600 ./traefik/certs/pingat.lan.key
```

traefik.yml — configuration statique :

```yaml
entryPoints:
web:
address: ":80"
http:
redirections:
entryPoint:
to: websecure
scheme: https
websecure:
address: ":443"
providers:
docker:
exposedByDefault: false
file:
directory: /etc/traefik/dynamic
watch: true
```

dynamic/tls.yml — configuration dynamique du certificat :

```yaml
tls:
certificates:

- certFile: /certs/pingat.lan.crt
  keyFile: /certs/pingat.lan.key

options:
default:
minVersion: VersionTLS12
```

Avec Docker Compose, montez les fichiers et dossiers correspondants dans le conteneur Traefik :

```yaml
services:
traefik:
image: traefik:v3.0
command:
- "--configFile=/etc/traefik/traefik.yml"
  ports:
- "80:80"
- "443:443"
  volumes:
- "/var/run/docker.sock:/var/run/docker.sock:ro"
- "./traefik/traefik.yml:/etc/traefik/traefik.yml:ro"
- "./traefik/dynamic:/etc/traefik/dynamic:ro"
- "./traefik/certs:/certs:ro"
  Pour votre application, ajoutez par exemple ces labels à son service :

yaml

labels:

- "traefik.enable=true"
- "traefik.http.routers.pingat.rule=Host(`pingat.lan`)"
- "traefik.http.routers.pingat.entrypoints=websecure"
- "traefik.http.routers.pingat.tls=true"
- "traefik.http.services.pingat.loadbalancer.server.port=8080"
  Remplacez 8080 par le port réellement écouté par l’application. Le certificat est chargé depuis la configuration dynamique du fournisseur de fichiers ; Traefik sélectionne le certificat selon le nom transmis par le client (SNI).
  traefik.io
```

Enfin, assurez-vous que le DNS interne résout pingat.lan vers l’adresse IP de Traefik. Après démarrage, vérifiez depuis un poste ayant confiance dans la CA :

```bash
curl -v https://pingat.lan/
```

Le certificat serveur expirera après 397 jours dans cet exemple : avant l’échéance, régénérez le certificat serveur et remplacez les fichiers montés dans Traefik. Citez le certificat racine sur les postes une seule fois, tant que cette CA reste la même.

### Recharger Traefik aprés modification ou renouvellement du certificat:

```bash
# touch /opt/traefik/traefik/dynamic/dynamic.yml
```

## Renouveler le certificat

À l’approche de l’échéance, réémettez le certificat serveur, pas la CA. La racine pingat-root-ca.crt reste installée sur les postes et n’a pas à être renouvelée. Les commandes ci-dessous supposent que votre CA et son fichier de série sont dans ~/pingat-pki, et que Traefik monte ./traefik/certs sous /certs.

Dans un terminal, depuis le répertoire de la CA :
```bash
cd ~/pingat-pki
umask 077

# Générer une nouvelle clé et une nouvelle demande CSR
openssl genrsa -out pingat.lan.key 2048
openssl req -new -sha256 \
  -key pingat.lan.key \
  -out pingat.lan.csr \
  -subj "/C=FR/O=Pingat/CN=pingat.lan"

# Vérifier que les SAN couvrent les noms réellement utilisés
cat > pingat.lan.ext <<'EOF'
basicConstraints = critical,CA:FALSE
keyUsage = critical,digitalSignature,keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = DNS:pingat.lan,DNS:*.pingat.lan,DNS:*.intranet.pingat.lan
EOF

# Signer le nouveau certificat avec la CA existante
openssl x509 -req -sha256 \
  -in pingat.lan.csr \
  -CA pingat-root-ca.crt \
  -CAkey pingat-root-ca.key \
  -CAserial pingat-root-ca.srl \
  -out pingat.lan.crt \
  -days 397 \
  -extfile pingat.lan.ext
```
-CAserial pingat-root-ca.srl réutilise le fichier de série créé lors de la première émission. Gardez la clé privée de CA (pingat-root-ca.key) protégée et non accessible à Traefik. OpenSSL permet de signer une nouvelle demande avec le certificat et la clé de CA, en ajoutant les extensions précisées par -extfile.
Arch Linux

Vérifiez le certificat avant de le déployer :

```bash
openssl verify -CAfile pingat-root-ca.crt pingat.lan.crt
openssl x509 -in pingat.lan.crt -noout -dates -ext subjectAltName
```
Puis, depuis le répertoire de votre docker-compose.yml, remplacez les fichiers utilisés par Traefik :

```bash
cp ~/pingat-pki/pingat.lan.crt ./traefik/certs/pingat.lan.crt
cp ~/pingat-pki/pingat.lan.key ./traefik/certs/pingat.lan.key
chmod 600 ./traefik/certs/pingat.lan.key
```

### Déclencher le rechargement, si le fournisseur file surveille ce répertoire
```bash
touch ./traefik/dynamic/dynamic.yml
```

### Si le nouveau certificat n’est pas chargé, redémarrer Traefik
docker compose restart traefik
Contrôlez ensuite le certificat présenté en précisant un sous-domaine réellement utilisé :

```bash
openssl s_client \
-connect monapplication.pingat.lan:443 \
-servername monapplication.pingat.lan \
</dev/null 2>/dev/null \
| openssl x509 -noout -issuer -dates -ext subjectAltName
```
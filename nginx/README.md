# NGIX


## Présentation de Nginx

Nginx (prononcé "Engine X") est un serveur web open source performant, connu pour sa capacité à gérer un grand nombre de connexions simultanées tout en utilisant peu de ressources. En plus de servir des pages web, Nginx peut également être utilisé comme reverse proxy, load balancer et proxy cache.
Fonctionnalités principales de Nginx

    Serveur web : Servir des fichiers statiques et des applications web.
    Reverse proxy : Rediriger les requêtes HTTP/S vers un ou plusieurs serveurs en backend.
    Load balancing : Répartir les requêtes entrantes entre plusieurs serveurs pour optimiser l'utilisation des ressources.
    Proxy cache : Cacher les réponses des serveurs backend pour améliorer les performances et réduire la charge du serveur.

## Architecture de la configuration de Nginx

### Structure de base du dossier de configuration

- nginx.conf : Fichier principal de configuration.
- sites-available/ : Contient les fichiers de configuration pour les sites web (virtual hosts) disponibles.
- sites-enabled/ : Active les sites en incluant les fichiers de configuration depuis sites-available/.
- conf.d/ : Contient des fichiers de configuration supplémentaires ou spécifiques.
- mime.types : Définit les types MIME pour le contenu servi.
- snippets/ : Contient des extraits de configuration réutilisables.
- fastcgi_params : Paramètres FastCGI pour l'intégration avec des processus backend.
- proxy_params : Paramètres par défaut pour la configuration du reverse proxy.
- /var/log/nginx/ : Contient les logs des accès et des erreurs.

### Structure de base d'une configuration de Nginx
La configuratin commence par le fichier de configurtion par principal

### Le fichier de configuration principal

La configuration de Nginx se base principalement sur des blocs de directives organisés dans des fichiers de configuration. Le fichier principal de configuration se trouve généralement à l'emplacement suivant : `/etc/nginx/nginx.conf`.


La structure du fichier de conf principal `/etc/nginx/nginx.conf` se presente comme suite : 

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;

	# gzip_vary on;
	# gzip_proxied any;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	# gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}


#mail {
#	# See sample authentication script at:
#	# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#	# auth_http localhost/auth.php;
#	# pop3_capabilities "TOP" "USER";
#	# imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#	server {
#		listen     localhost:110;
#		protocol   pop3;
#		proxy      on;
#	}
#
#	server {
#		listen     localhost:143;
#		protocol   imap;
#		proxy      on;
#	}
#}
```
Explication des directives principales :

- events : Gère les événements liés aux connexions réseaux.
- http : Contient toutes les directives liées aux requêtes HTTP (sites web, virtual hosts, etc.).
- server : Représente un "virtual host", avec des paramètres spécifiques pour chaque serveur.
- location : Définit la manière dont Nginx doit traiter les requêtes à une URL donnée (ex. : / pour la racine).
- `include /etc/nginx/sites-enabled/*;` : inclut les les virtual host configuré dans `sites-evailables` et acitvé dans `sites-enabled`
- `include /etc/nginx/conf.d/*.conf;` : inclut les fichiers de configuration spécifiques et supplementaires


## Mise en place d'un Virtual Host avec Reverse Proxy

Un virtual host permet de configurer plusieurs sites web ou applications sur un même serveur, chacun avec son propre nom de domaine. Voici comment configurer un virtual host pour un site et utiliser Nginx comme reverse proxy pour rediriger les requêtes vers un serveur backend (par exemple une application sur un autre port).

### Coniguration en http

- Étape 1 : Création d'une fichier `/etc/nginx/sites-available/my-site.local`

```bash
sudo nano /etc/nginx/sites-available/my-site.local
```
- Étape 2 : Ajouter la configuration du Virtual Host avec inclusion des `fichiers de confuration des virtual host` (mis en place dans un dossier personnalisé : par exemple `/etc/ngnix/locations`)

```conf
server {
    # Écouter sur le port 80 (HTTP)
    listen 80;
    server_name nginx.localhost.com;

    # listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;


    # Inclusion des fichiers location pour une configuration modulaire
    include /etc/nginx/locations/my-site.conf;

    <!-- location / {
        proxy_pass http://localhost:3000; # Adresse de l'application backend
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    } -->

    # Fichiers statiques (optionnel, si ton backend sert des fichiers statiques)
    location /static/ {
        root /var/www/doc-statics;
    }

    # Gestion des erreurs (optionnel)
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```
- Étape 3 : Création d'un dossier location pour y placer la configuration des proxie

```bash
sudo nano /etc/nginx/sites-available/locations/my-site.conf
```
Avec les config de locations :

```conf

location /alpha {
    proxy_pass http://localhost:8080/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

location /beta {
    proxy_pass http://localhost:8080/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

- Étape 4 : Activer le site

Crée un lien symbolique dans le dossier /etc/nginx/sites-enabled/ pour activer ton site :

```bash
sudo ln -s /etc/nginx/sites-available/my-site.local /etc/nginx/sites-enabled/
```

Étape 5 : Vérifier la configuration et redémarrer Nginx

Vérifie la configuration pour t'assurer qu'il n'y a pas d'erreurs :

```bash
sudo nginx -t
```

- Puis, redémarre Nginx pour appliquer les changements :

```bash
sudo systemctl restart nginx
```

### Coniguration en https : 

`/etc/nginx/sites-available/my-site.local`
```conf
server {
    # Écouter sur le port 80 (HTTP) et rediriger vers HTTPS
    listen 80;
    server_name nginx.localhost.com;
    
    # Rediriger tout le trafic HTTP vers HTTPS
    return 301 https://$host$request_uri;
}

server {
    # Écouter sur le port 443 (HTTPS) avec SSL
    listen 443 ssl;
    server_name nginx.localhost.com;

    # Chemins vers les certificats SSL
    ssl_certificate /etc/ssl/certs/my-autosigne-cert/my-site.localhost.com+4.pem;
    ssl_certificate_key /etc/ssl/my-autosigne-cert/my-site.localhost.com+4-key.pem;

    # Inclusion des fichiers location pour une configuration modulaire
    include /etc/nginx/locations/my-site.conf;

    # Servir une page HTML statique à partir de /var/www/my-site-nginx/
    location / {
        root /var/www/my-site-nginx;
        index index.html;
        try_files $uri $uri/ =404; # Sert le fichier index.html ou renvoie une erreur 404 si le fichier n'existe pas
    }
    # Fichiers statiques (optionnel, si ton backend sert des fichiers statiques)
    location /static/ {
        root /var/www/doc-statics;
    }

    # Gestion des erreurs (optionnel)
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    # Sécurisation SSL recommandée
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # HTTP Strict Transport Security (HSTS)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

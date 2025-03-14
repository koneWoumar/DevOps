# Apache2

Apache2 est un serveur web très polyvalent qui permet de réaliser diverses tâches pour la gestion, l’optimisation, et la sécurité des sites web. Voici quelques-unes des principales tâches que vous pouvez accomplir avec Apache2, avec une explication pour chaque tâche :

1. Servir des pages web :

    Description : C'est la fonction principale d'Apache. Il sert des fichiers statiques (HTML, CSS, JavaScript) ou dynamiques (PHP, Python) aux utilisateurs qui accèdent au site web via un navigateur.
    Utilisation : Vous configurez des hôtes virtuels (Virtual Hosts) dans le répertoire sites-available/ pour servir plusieurs sites à partir d'un même serveur Apache.
    Exemple : Afficher une page HTML lorsque vous accédez à http://example.com.

2. Redirection :

    Description : La redirection permet de rediriger automatiquement les utilisateurs d'une URL vers une autre. Il existe différents types de redirections, comme les redirections temporaires (302) ou permanentes (301).
    Utilisation : Vous pouvez configurer des redirections pour des pages déplacées, des changements de nom de domaine, ou forcer l'accès en HTTPS.
    Exemple :
        Redirection permanente :
```bash
Redirect 301 /oldpage.html http://www.example.com/newpage.html
```    

3. Reverse Proxy :

    Description : Apache peut agir comme un reverse proxy, c'est-à-dire qu'il reçoit les requêtes des utilisateurs et les redirige vers d'autres serveurs, tout en agissant comme un intermédiaire entre le client et le serveur final. Cela permet de répartir la charge, améliorer la sécurité, ou faire de la mise en cache.
    Utilisation : Vous pouvez configurer un reverse proxy pour acheminer les requêtes vers une application web qui tourne sur un autre serveur (ou un autre port).
    Exemple :
        Configurer un reverse proxy pour un serveur qui tourne sur localhost:8080 :

```bash
ProxyPass "/app" "http://localhost:8080/"
ProxyPassReverse "/app" "http://localhost:8080/"
```

4. Load Balancing (Équilibrage de charge) :

    Description : Apache peut répartir la charge entre plusieurs serveurs backend, pour garantir une meilleure performance et disponibilité des services web.
    Utilisation : Utile pour des architectures distribuées où le trafic est réparti sur plusieurs serveurs.
    Exemple :
Configuration de l'équilibrage de charge :

```bash
<Proxy balancer://mycluster>
    BalancerMember http://backend1.example.com
    BalancerMember http://backend2.example.com
</Proxy>

ProxyPass "/balancer" "balancer://mycluster"
ProxyPassReverse "/balancer" "balancer://mycluster"
```
5. Virtual Hosts (Hôtes Virtuels) :

    Description : Les hôtes virtuels permettent de configurer plusieurs sites web sur un seul serveur Apache, chacun ayant son propre nom de domaine.
    Utilisation : Très utile si vous souhaitez héberger plusieurs domaines sur un même serveur. Chaque hôte virtuel a sa propre configuration dans les répertoires sites-available/ et sites-enabled/.
    Exemple :
        Exemple de configuration d’un hôte virtuel :

```bash
<VirtualHost *:80>
    ServerName www.example.com
    DocumentRoot /var/www/html/example
</VirtualHost>
```
6. SSL / HTTPS (Certificats SSL) :

    Description : Apache permet de configurer des certificats SSL pour sécuriser les communications entre les clients et le serveur via HTTPS. Cela permet d'éviter que les données transmises ne soient interceptées.
    Utilisation : Vous pouvez configurer SSL avec des certificats auto-signés ou des certificats émis par une autorité de certification (comme Let's Encrypt).
    Exemple :
        Configuration de SSL avec un certificat :
```bash
<VirtualHost *:443>
    ServerName www.example.com
    DocumentRoot /var/www/html/example

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/example.crt
    SSLCertificateKeyFile /etc/ssl/private/example.key
</VirtualHost>
```
7. Gestion des URL (mod_rewrite) :

    Description : Le module mod_rewrite permet de réécrire les URLs de manière flexible. Cela peut être utilisé pour des redirections, des alias, ou pour rendre les URLs plus lisibles.
    Utilisation : Vous pouvez l'utiliser pour transformer des URLs complexes en des formes plus simples et optimisées pour le SEO.
    Exemple :
Réécriture des URLs pour les rendre plus propres :
```bash
RewriteEngine On
RewriteRule ^old-page$ /new-page [R=301,L]
```
8. Authentification et autorisation :

    Description : Apache permet de configurer des mécanismes d'authentification et d'autorisation pour restreindre l'accès à certaines ressources ou à des utilisateurs authentifiés uniquement.
    Utilisation : Vous pouvez mettre en place une authentification basée sur des fichiers .htpasswd pour protéger certaines sections de votre site web.
    Exemple :
Protéger un répertoire avec une authentification :

```bash
<Directory /var/www/html/private>
    AuthType Basic
    AuthName "Restricted Content"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>
```
9. Compression des fichiers (mod_deflate) :

    Description : Le module mod_deflate permet de compresser les fichiers avant de les envoyer aux utilisateurs. Cela réduit la taille des fichiers transmis, améliorant ainsi les temps de chargement des pages.
    Utilisation : Vous pouvez compresser les fichiers HTML, CSS, JavaScript, et d'autres fichiers texte.
    Exemple :
Activer la compression Gzip :

```bash
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript
</IfModule>
```
10. Gestion du cache (mod_cache) :

    Description : Le module mod_cache d'Apache permet de mettre en cache les réponses HTTP pour améliorer les performances et réduire la charge sur le serveur.
    Utilisation : Utile pour les sites web où les réponses ne changent pas souvent, ce qui permet d'améliorer la rapidité d'accès.
    Exemple :
Activer le cache pour les ressources statiques :

```bash
<IfModule mod_cache.c>
    CacheQuickHandler on
    CacheEnable disk /
    CacheRoot "/var/cache/apache2/cache"
</IfModule>
```
11. Serveur de fichiers statiques :

    Description : Apache peut servir directement des fichiers statiques (images, vidéos, documents) aux utilisateurs. Cela est souvent utilisé en complément de serveurs d'applications pour servir des ressources.
    Utilisation : Vous pouvez spécifier un répertoire spécifique pour héberger vos fichiers statiques.
    Exemple :
        Configuration d'un répertoire de fichiers statiques :

```bash
<Directory /var/www/static>
  Options Indexes FollowSymLinks
  AllowOverride None
  Require all granted
</Directory>
```


## Configuration Structure

```bash
/etc/apache2/
|-- apache2.conf     # main config file
|	`--  ports.conf 
|-- mods-enabled     # symbolic link pointing to the activated mods in `mods-available`
|	|-- *.load 
|	`-- *.conf 
|-- conf-enabled     # symbolic link pointing to the activated conf in `conf-available`
|	`-- *.conf 
`-- sites-enabled    # symbolic link pointing to the activated site in `site-available`
    `-- *.conf
```

1. apache2.conf (ou httpd.conf) :

    Rôle : Il s'agit du fichier de configuration principale d'Apache2. Il contient les directives globales qui s'appliquent à tout le serveur web. Ce fichier définit les règles par défaut concernant les paramètres globaux du serveur, la gestion des modules, des journaux, et la sécurité.

    Contenu typique :
        Chemins vers les fichiers de configuration supplémentaires.
        Paramètres globaux comme les niveaux de journalisation, les timeout, les limites de connexion, etc.
        Inclusion des autres fichiers de configuration via des directives Include (ex. IncludeOptional sites-enabled/*.conf).

    Bien que apache2.conf soit le fichier de configuration principal, il inclut d'autres fichiers comme ceux des sites et des modules, qui permettent de personnaliser davantage la configuration du serveur.

2. sites-available/ :

    Rôle : Ce répertoire contient les fichiers de configuration des sites web disponibles sur le serveur. Chaque site web ou application web peut avoir son propre fichier de configuration ici. Cependant, les fichiers dans ce dossier ne sont pas activés par défaut.

    Utilité : Ce dossier permet de gérer plusieurs sites web sur un même serveur Apache en utilisant la fonctionnalité des hôtes virtuels (Virtual Hosts). Par exemple, un fichier de configuration pour www.exemple.com serait placé ici.

```bash
/etc/apache2/sites-available/
├── 000-default.conf
└── exemple.com.conf
```
3. sites-enabled/ :

    Rôle : Ce dossier contient les fichiers de configuration des sites web activés sur Apache. Apache ne prend en compte que les sites présents dans ce répertoire. En réalité, les fichiers ici ne sont souvent que des liens symboliques vers les fichiers dans sites-available/.

    Utilité : Lorsqu'un site est activé avec la commande a2ensite, un lien symbolique du fichier correspondant de sites-available/ est créé dans sites-enabled/. Cela permet de désactiver facilement un site en supprimant simplement ce lien symbolique (via la commande a2dissite).

    Exemple :

```bash
/etc/apache2/sites-enabled/
├── 000-default.conf -> ../sites-available/000-default.conf
└── exemple.com.conf -> ../sites-available/exemple.com.conf
```

4. mods-available/ :

    Rôle : Ce répertoire contient les modules Apache disponibles, mais non activés. Les modules sont des extensions qui ajoutent des fonctionnalités supplémentaires à Apache (comme SSL, réécriture d'URL, gestion des fichiers compressés, etc.).

    Utilité : Ce dossier permet de répertorier tous les modules installés sur Apache, mais ils ne sont pas actifs tant que vous ne les activez pas explicitement.

    Exemple :

```bash
/etc/apache2/mods-available/
├── rewrite.load
├── ssl.load
└── headers.load
```

5. mods-enabled/ :

    Rôle : Ce répertoire contient les modules activés pour Apache. Comme pour les sites, ce sont souvent des liens symboliques vers les fichiers dans mods-available/.

    Utilité : Lorsqu'un module est activé avec la commande a2enmod, un lien symbolique vers son fichier dans mods-available/ est créé ici. Cela permet à Apache de charger ce module lors de son démarrage. Pour désactiver un module, il suffit de supprimer le lien symbolique (via a2dismod).

    Exemple :

```bash
/etc/apache2/mods-enabled/
├── rewrite.load -> ../mods-available/rewrite.load
└── ssl.load -> ../mods-available/ssl.load
```

## Important Commands apache2

### Gestion du processus apache2 (ubuntu)
- Start apache2
```bash
sudo systemctl start apache2.service
```
- Restart apache2
```bash
sudo systemctl restart apache2.service
```
- Show status of apache2
```bash
sudo systemctl status apache2.service
```
- Show the log of apache2
```bash
journalctl -xeu apache2.service
# ou
sudo tail -f /var/log/apache2/error.log
```
- Reload apache2
```bash
sudo systemctl reload apache2
```
### Gestion des config apache2
- Activate/desactivate a site
```bash
sudo a2ensite my_site.conf
#
sudo a2disite my_site.conf
```
- Activate/desactivate a mods
```bash
sudo a2enmod my_mods
#
sudo a2dimod my_mods
```
- Verifier que les config apache2 sont correcte
```bash
sudo apache2ctl configtest
```
- Activate a config in conf-availble
```bash
sudo a2enconf proxy-arrow
```

## Structure of a Virtual host (for http)

```apache
<VirtualHost *:80>
    ServerName mon-site.com
    ServerAdmin webmaster@mon-site.com
    DocumentRoot /var/www/mon-site

    # Redirection temporaire (302) de /ancien vers /nouveau
    Redirect 302 /ancien /nouveau

    # Redirection permanente (301) de /old-page vers /new-page
    Redirect 301 /old-page /new-page

    # Reverse Proxy sans <Location>
    # Redirige les requêtes vers /service1 vers un service interne
    ProxyPass /service1 http://localhost:8080/
    ProxyPassReverse /service1 http://localhost:8080/

    # Reverse Proxy avec <Location>
    # Redirige les requêtes vers /api vers une API externe
    <Location /api>
        ProxyPass "https://api.externe.com/"
        ProxyPassReverse "https://api.externe.com/"
    </Location>

    # Load balancing entre plusieurs serveurs
    # Permet d'équilibrer la charge entre plusieurs backends
    <Proxy balancer://mycluster>
        BalancerMember http://backend1:8080
        BalancerMember http://backend2:8080
        ProxySet lbmethod=byrequests
    </Proxy>

    # Reverse proxy vers le cluster de backends
    ProxyPass /loadbalancer balancer://mycluster/
    ProxyPassReverse /loadbalancer balancer://mycluster/

    # Autres configurations possibles
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

```
Détails des cas d'utilisation
1. Redirection permanente (301)

    Usage : Utilisé pour rediriger de manière permanente une URL vers une nouvelle URL. Les moteurs de recherche savent que la page a été déplacée et mettront à jour leurs index.

2. Redirection temporaire (302)

    Usage : Utilisé pour rediriger temporairement une URL vers une nouvelle URL. Les moteurs de recherche ne mettront pas à jour leurs index.

3. Reverse Proxy sans <Location>

    Usage : Redirige les requêtes d'un chemin spécifique vers un service interne. Dans cet exemple, les requêtes vers /service1 sont redirigées vers un service s'exécutant sur localhost sur le port 8080.

4. Reverse Proxy avec <Location>

    Usage : Utilisé pour configurer des paramètres spécifiques pour un chemin donné. Dans cet exemple, les requêtes vers /api sont redirigées vers une API externe.

5. Load Balancing

    Usage : Permet de répartir la charge entre plusieurs serveurs backend. Cela améliore la disponibilité et la répartition de la charge.

Autres configurations

    Logging : Les lignes ErrorLog et CustomLog configurent la journalisation des erreurs et l'accès. Cela permet de suivre les requêtes et d'identifier les problèmes.

Voir les documentation officiel [ici](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass)

## Virtual host configuration in http


- Creating a config file `/etc/apache2/site-availabe/my-site.conf` for the virtual host

```apache
<VirtualHost *:80>
    ServerName localhost
    ServerAdmin admin@localhost
    DocumentRoot /var/www/html

    # activation de config pour le reverse proxy
    ProxyRequests On
    SSLProxyEngine On

    # Inclusion du fichier de configuration externalisé
    Include /etc/apache2/conf-available/proxy-my-site.conf

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

- Creating the config file `/etc/apache2/conf-available/proxy-my-site.conf` and defining in it all the proxy configuration

```apache
<Location /go>
    ProxyPass "https://google.com/"
    ProxyPassReverse "https://google.com/"
</Location>

<Location /yo>
    ProxyPass "https://youtube.com/"
    ProxyPassReverse "https://youtube.com/"
</Location>
```

- Activate necessary module if not done
```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
```

- Activate the site
```bash
sudo a2ensite my_site.conf
```

- Activate the proxy configuration
```bash
sudo a2enconf proxy-arrow
```


- Restart or relaod apache2
```bash
sudo systemctl restart apache2
```


## Virtual host configuration in https
Pour la configuration d'un virtual host en https, il faudra un certificat SSL valide, d'où la section suivante pour en savoir plus : 

### Obtention d'un certificat SSL/TLS

#### Comprendre la certification SSL/TLS et la sécurisation des communications


A. Qu'est-ce qu'une Autorité de Certification (CA) ?

Une Autorité de Certification (CA) est une organisation qui émet des certificats numériques utilisés pour vérifier l'identité d'un site web et sécuriser les communications. Les CA agissent comme un tiers de confiance entre les utilisateurs et les serveurs web, en garantissant que le certificat d’un site web est valide et qu’il correspond à son propriétaire.
B. Fonctionnement du chiffrement SSL/TLS

Le SSL (Secure Sockets Layer) et son successeur TLS (Transport Layer Security) sont des protocoles de sécurité utilisés pour chiffrer les communications entre un client (navigateur) et un serveur (site web). Voici comment cela fonctionne :

    Établissement de la connexion sécurisée (Handshake) :
        Lorsqu'un client se connecte à un site web via HTTPS, le serveur envoie son certificat SSL au client pour prouver son identité. Ce certificat contient la clé publique du serveur.
        Le client vérifie la validité du certificat via une Autorité de Certification (CA), comme Let's Encrypt, pour s'assurer que le serveur est bien celui qu'il prétend être.

    Échange de clés :
        Une fois le certificat validé, le client et le serveur utilisent la cryptographie asymétrique pour échanger une clé symétrique (clé de session) qui servira pour chiffrer et déchiffrer les données pendant la session.
        Le serveur utilise sa clé privée pour déchiffrer les messages chiffrés avec sa clé publique par le client.

    Chiffrement et déchiffrement des données :
        Après l'échange de la clé de session, le client et le serveur passent au chiffrement symétrique, plus rapide. La clé symétrique est utilisée pour chiffrer toutes les communications entre eux pendant la session.
        Les données sont donc sécurisées, empêchant les interceptions de tiers pendant le transfert.

C. Clés publiques et privées

    Clé publique : Utilisée pour chiffrer les données envoyées au serveur. Elle est contenue dans le certificat SSL et partagée avec tout le monde.
    Clé privée : Utilisée par le serveur pour déchiffrer les données chiffrées avec la clé publique. Elle doit rester secrète et n'est jamais partagée.

Grâce à ce mécanisme, toutes les communications entre le navigateur et le serveur sont chiffrées et sécurisées.

#### Obtenir un certificat ssl/tls pour un domaine name valide qui n'est pas local

A. Ce qu'il faut pour obtenir un certificat

Pour obtenir un certificat SSL/TLS auprès d'une CA comme Let's Encrypt, il faut :

    Un nom de domaine (FQDN) valide (ex. : www.mon-site.com).
    Accès root au serveur où le site est hébergé.
    Certbot, un outil gratuit et automatique qui aide à obtenir et installer des certificats SSL/TLS.

B. Installation de Certbot

Certbot est un client ACME (Automated Certificate Management Environment) recommandé par Let's Encrypt pour l'obtention de certificats SSL gratuits.

    Installer Certbot :
        Sur Ubuntu/Debian :
```bash
sudo apt update
sudo apt install certbot python3-certbot-apache
```
Sur CentOS/RHEL :

```bash
sudo yum install certbot python-certbot-apache
```
    

Obtenir un certificat avec Certbot : Une fois Certbot installé, exécute cette commande pour obtenir un certificat SSL pour ton site :

```bash
sudo certbot --apache -d example.com -d www.example.com
```


    Remplace example.com par ton nom de domaine.
    Si tu utilises Nginx, utilise --nginx au lieu de --apache.

Validation et installation :

    Certbot communique avec Let's Encrypt pour valider que tu es bien le propriétaire du domaine.
    Une fois validé, Certbot télécharge et installe automatiquement le certificat SSL pour ton site dans la configuration d'Apache ou Nginx.

Renouvellement automatique : Les certificats Let's Encrypt sont valables pendant 90 jours, mais Certbot gère automatiquement leur renouvellement. Tu peux forcer un renouvellement avec la commande suivante :

```bash
sudo certbot renew
```


#### Mise en place d'un certificat ssl/tls pour un domaine local cas d'environnement de developpement

Dans le cas d'un environnemnt de developpement en local ou le client est le `navigateur` et le serveur est le couple `le navigateur-reverse-proxy` le reverse proxy pouvant etre apache ou ngnix .

Pour mettre en place, un certificat ssl/tls valide en local, il faut : 
- Créer une Autorité de certification local (CA) qui n'est rien d'autre qu'une clé privé et une clé publique
- Generé une une clé de certification signé avec ce CA local (pouvant utilisé openssl)
- Utilisé ce certificat dans les config du reverse proxy(c'est la configuration du serveur)
- Ajouté ce CA ou CA reconnu prise en charge par le navigateur qui par defaut ne prend en compte que les CA publique (c'est la config coté client)

Il existe cependant un outil qui automatise création de CA privé et la génération de certificat local ainsi que son installation dans les CA prise en compte par les navigateur : c'est `mkcert`

mkcert est un utilitaire simple et automatisé pour générer et installer des certificats SSL locaux. Il est idéal pour générer rapidement un certificat de CA racine et des certificats signés automatiquement sans nécessiter de configuration complexe d'OpenSSL.

Pour y arriver : 

- Installer mkcert:

```bash
sudo apt install libnss3-tools
sudo wget https://dl.filippo.io/mkcert/latest?for=linux/amd64 -O /usr/local/bin/mkcert
sudo chmod +x /usr/local/bin/mkcert
```

- Installer la CA locale

```bash
mkcert -install
```

- Générer un certificat SSL

```bash
mkcert example.com "*.example.com" localhost 127.0.0.1 ::1
```
ou 

```bash
mkcert nginx.localhost.com "*.localhost.com" apache.localhost.com localhost 127.0.0.1 ::1
```

- Plus d'info sur la documentation officiel de mkcert at :
[mcert github projet](https://github.com/FiloSottile/mkcert)



-  Utiliser les certificats (par exemple dans ngnix)

```ngnix
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /chemin/vers/certificat/localhost.pem;
    ssl_certificate_key /chemin/vers/certificat/localhost-key.pem;
}
```


### Mise en place de la configuration du virtual host

- Creating a config file `/etc/apache2/site-availabe/my-site.conf` for the virtual host


```apache
<IfModule mod_ssl.c>
    <VirtualHost *:443>
        ServerAdmin admin@my-site.localhost.com
        ServerName my-site.localhost.com

        DocumentRoot /var/www/my-site


        # activation du module ssl
        SSLEngine on


        # activation de config pour le reverse proxy
        ProxyRequests On
        SSLProxyEngine On


        # specifié le ceritificat et sa clé privé
        SSLCertificateFile /etc/ssl/certs/my-autosigne-cert/server.crt
        SSLCertificateKeyFile /etc/ssl/certs/my-autosigne-cert/server.key


        <FilesMatch "\.(cgi|shtml|phtml|php)$">
            SSLOptions +StdEnvVars
        </FilesMatch>

        <Directory /usr/lib/cgi-bin>
            SSLOptions +StdEnvVars
        </Directory>


        # Inclusion du fichier de configuration externalisé
        Include /etc/apache2/conf-available/proxy-my-site.conf


        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

    </VirtualHost>
</IfModule>

```

- Creating the config file `/etc/apache2/conf-available/proxy-my-site.conf` and defining in it all the proxy configuration

```apache
<Location /go>
    ProxyPass "https://google.com/"
    ProxyPassReverse "https://google.com/"
</Location>

<Location /yo>
    ProxyPass "https://youtube.com/"
    ProxyPassReverse "https://youtube.com/"
</Location>
```

- Activate necessary module if not done
```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod ssl
```

- Activate the site
```bash
sudo a2ensite my-site.conf
```

- Activate the proxy configuration
```bash
sudo a2enconf proxy-arrow
```


- Restart or relaod apache2
```bash
sudo systemctl restart apache2
```
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

## Virtual host configuration

### Sitting up  a simple Virtual host

- Creating a config file `/etc/apache2/site-availabe/my_site.conf` for the virtual host

```apache
<VirtualHost *:80>
    ServerName localhost
    ServerAdmin admin@localhost
    DocumentRoot /var/www/html

    # activation de config pour le reverse proxy
    ProxyRequests On
    SSLProxyEngine On

    # Configuration d'un chemin
    <Location /api>
        ProxyPass "https://google.com/"
        ProxyPassReverse "https://google.com/"
    </Location>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

- Activate the site
```bash
sudo a2ensite my_site.conf
```
- Activate necessary module if not done
```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
```
- Restart or relaod apache2
```bash
sudo systemctl restart apache2
```
###  Externalisation of the proxy configuration in conf-evailable

- Remplacing the content `/etc/apache2/site-availabe/my_site.conf` of by :

```apache
<VirtualHost *:80>
    ServerName localhost
    ServerAdmin admin@localhost
    DocumentRoot /var/www/html

    # activation de config pour le reverse proxy
    ProxyRequests On
    SSLProxyEngine On

    # Inclusion du fichier de configuration externalisé
    Include /etc/apache2/conf-available/proxy-arrow.conf

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

- Creating the config file `/etc/apache2/conf-available/proxy-arrow.conf` and defining in it all the proxy configuration

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

- Activate the configuration

```bash
sudo a2enconf proxy-arrow
```

- Relaod apache2
```bash
sudo systemctl reload apache2
```

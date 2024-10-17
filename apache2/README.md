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


/etc/apache2/ <br>
|-- apache2.conf <br>
|	`--  ports.conf <br>
|-- mods-enabled <br>
|	|-- *.load <br>
|	`-- *.conf <br>
|-- conf-enabled <br>
|	`-- *.conf <br>
`-- sites-enabled <br>
    `-- *.conf <br>


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


## Virtual host configuration


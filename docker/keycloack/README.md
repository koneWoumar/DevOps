# Keycloack

Keycloak est une solution open-source de gestion d'identité et d'accès (IAM) qui fournit des fonctionnalités comme l'authentification, l'autorisation, et la gestion des utilisateurs pour les applications. Voici un guide pour bien démarrer.

## Presentation

### 1. Concepts clés
#### 1.1 Realm

Un realm est une partition dans Keycloak. Il permet d'isoler les configurations, utilisateurs, et applications.

- Default Realm : Keycloak propose un realm par défaut appelé master. Il est utilisé pour gérer l'instance Keycloak elle-même.
- Créer un realm :
    Connectez-vous à l'interface d'administration.
    Accédez à Manage -> Realm.
    Cliquez sur Create Realm, donnez-lui un nom, et sauvegardez.

#### 1.2 Clients

Un client représente une application (front-end ou back-end) utilisant Keycloak pour l'authentification.

- Créer un client :
Dans le realm, allez dans Clients.
Cliquez sur Create, définissez un Client ID (identifiant unique pour l'application), et choisissez un type :
OpenID Connect (OIDC) : Pour les applications web modernes.
SAML : Pour les intégrations utilisant SAML.
Configurez l'URL de redirection pour le client (par ex. http://localhost:3000 pour un front-end).

#### 1.3 Utilisateurs

Les utilisateurs sont des individus pouvant se connecter à vos applications.

- Ajouter un utilisateur :
Accédez à Users -> Add User.
Renseignez les informations nécessaires (ex. nom d’utilisateur, email).
Une fois l’utili####sateur créé, définissez son mot de passe dans l’onglet Credentials.

#### 1.4 Groupes et Rôles

- Rôles : Définissent les permissions pour les utilisateurs.
    Les rôles peuvent être créés au niveau du realm ou au niveau du client.
- Groupes : Permettent de structurer les utilisateurs et d’attribuer des rôles en masse.

- Créer un rôle :
Accédez à Roles -> Add Role.
Donnez un nom au rôle et sauvegardez.

- Créer un groupe :
Allez dans Groups -> New Group.
Associez des utilisateurs ou des rôles au groupe.

### 2. Authentification et Protocoles

Keycloak prend en charge :

- OpenID Connect (OIDC) : Basé sur OAuth 2.0.
- SAML : Pour les systèmes hérités.

### 4. Fonctionnalités avancées
#### 4.1 Authentification

Keycloak offre des mécanismes d'authentification comme :
- Mot de passe (Username/Password).
- Authentification multi-facteurs (MFA) via OTP.
- Intégration sociale (Google, Facebook, GitHub).

#### 4.2 Authorization Services

Pour configurer des politiques d’autorisation basées sur des rôles, groupes ou attributs, Keycloak propose des outils graphiques puissants.

#### 4.3 Personnalisation

- Thèmes : Modifiez l’apparence des pages de connexion et des emails.
- Scripts d’authentification : Implémentez vos propres workflows d’authentification avec des scripts JavaScript.


## Industrialisation

Cette section se base sur keycloak 26.0.5 , la version conteneurisée.


### Docker-compose

#### Configurations

##### docker-compose.yaml
```yaml
  mysql:
    image: quay.io/keycloak/keycloak:${KEYCLOACK_VERSION}
    container_name: proverbs-auth
    env_file:
      - .env
    network_mode: host
    command: > 
      start --import-realm
    volumes:    
      - ./realm:/opt/keycloak/data/import
      - /etc/ssl/certs/my-autosigne-cert/:/etc/x509/https:ro
    deploy:
      resources:
        limits:
          memory: ${MEM_LIMIT}                       
        # reservations:
        #   memory: ${MEM_RESERVATION}                
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:${KC_HTTP_PORT} || exit 1"]
      interval: ${HEALTHCHECK_INTERVAL}
      timeout: ${HEALTHCHECK_TIMEOUT}
      retries: ${HEALTHCHECK_RETRIES}
      start_period: ${HEALTHCHECK_START_PERIOD}
```
##### .env

```conf
## Configuration for production and deve mode

#------------------Docker compose config--------------------#
MEM_LIMIT=1024M
MEM_RESERVATION=512M
HEALTHCHECK_START_PERIOD=5s
HEALTHCHECK_INTERVAL=30s
HEALTHCHECK_TIMEOUT=10s
HEALTHCHECK_RETRIES=3
KEYCLOACK_VERSION=26.0.5
#------------------Keycloack Configuration--------------------#

#Database config
KC_DB=mysql
KC_DB_URL="jdbc:mysql://127.0.0.1:3306/proverbs_db"
KC_DB_USERNAME=root
KC_DB_PASSWORD="00932"
#Admin User auth config
KC_BOOTSTRAP_ADMIN_USERNAME=admin
KC_BOOTSTRAP_ADMIN_PASSWORD="admin123"
#Debug level config
KC_LOG_LEVEL=INFO
#starting option
kc_starting_option="--import-realm"
#Http(s) config
KC_HTTP_PORT=8080
KC_HTTPS_PORT=8443
KC_HTTPS_CERTIFICATE_FILE=/etc/x509/https/nginx.localhost.com+5.pem          # comment for dev mode
KC_HTTPS_CERTIFICATE_KEY_FILE=/etc/x509/https/nginx.localhost.com+5-key.pem  # comment for prod mod
KC_HOSTNAME_STRICT=false
KC_HTTP_ENABLED="true"
KC_PROXY_HEADERS="xforwarded"
KC_HTTP_RELATIVE_PATH="/auth"
#Realm imporation config
KC_OVERRIDE=false


# -------------------------------------------Commentaire-----------------------------#

# Ces configuration c-dessus retenues fonctionnement :

# En http avec l'url de base pour keycloak = http://localhost:8080
# En https avec l'url de base pour keycloak = https://domaine:{kc_https_port}

# Derriere un reverese proxy nginx pour https://domaine_name/ --> https://domaine_name:{kc_https_port}
# avec pour config du reverse proxy:
# location / {
#     proxy_pass https://web.localhost.com:8443/;
#     proxy_set_header Host $host;
#     proxy_set_header X-Real-IP $remote_addr;
#     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#     proxy_set_header X-Forwarded-Proto $scheme;
# }

# Derriere un reverese proxy nginx pour https://domaine_name/ --> http://domaine_name:{kc_http_port}

# avec pour config du reverse proxy:
# location / {
#     proxy_pass http://localhost.com:8080/;
#     proxy_set_header Host $host;
#     proxy_set_header X-Real-IP $remote_addr;
#     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#     proxy_set_header X-Forwarded-Proto $scheme;
# }

# Remarque : dans ce cas de figure ou keycloak est en http derriere nginx
# il faut obligatoirement avoir la variable "KC_PROXY_HEADERS="xforwarded""
# pour que la console admin puisse fonctionner

#--------------------------------------documentations------------------------------#

## Toutes les options de configuration pour keycloak
# https://www.keycloak.org/server/all-config#category-proxy

## La documentation de keycloak
# https://www.keycloak.org/guides#getting-started


#--------------------------------------Remarque------------------------------------#

#Pour executer le projet en mode dev, il faut commenter les veriable indiquant les certificats
#KC_HTTPS_CERTIFICATE_FILE=/etc/x509/https/nginx.localhost.com+5.pem          # comment for dev mode
#KC_HTTPS_CERTIFICATE_KEY_FILE=/etc/x509/https/nginx.localhost.com+5-key.pem  # comment for prod mod
```

Ces configurations retenues fonctionnemnt avec keycloak comme suite : 

- En http avec base-url = https://domaine_name:8443/
- En https avec base-url = http://domaine_name:8080/

- Derriere Nginx pour base-url = https://domaine_name/ ( https://domaine_name/ --> https://domaine_name:{kc_https_port}/ )
```conf
location / {
    proxy_pass https://web.localhost.com:8443/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```
- Derriere un reverese proxy nginx pour base-url = https://domaine_name/ ( https://domaine_name/ --> http://domaine_name:{kc_http_port} )

```conf
location / {
    proxy_pass http://localhost.com:8080/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

##### Remarque : 
Dans ce cas de figure ou keycloak est en http derriere nginx
il faut obligatoirement avoir la variable `KC_PROXY_HEADERS="xforwarded"`
pour que la console admin puisse fonctionner


##### ℹ️ Informations 

Pour rendre keycloak accessible derriere Ngnix via un chemin par exemple /auth, il faut :

- Ajouter la variable `KC_HTTP_RELATIVE_PATH="/auth"`, dans le .env
- Ajuster la configuration du reverse proxy Nginx:
```conf
location /auth {
    proxy_pass http://localhost.com:8080/auth;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```
- Ajuster la configuration du back (pour l'introspection)
```conf
# l'url de base doit se terminer par /
KEYCLOAK_URL=https://web.localhost.com/auth/ # l'url de base de keycloak 
```
- Ajuster la configuration du front (pour l'authentification)
```conf
# cela marche sans forcement avoir le "/" à la fin
KEYCLOAK_URL=https://web.localhost.com/auth # l'url de base de keycloak
```

##### Importation et Exportation de realm 

Il est important d'exporter un realm avec toutes ses données pour demarrer de nouveaux container, lorsque la base de donnée n'est pas conservée, avec les configurations deja en exportées depuis un autre realm.

###### Exportation:

on peut importer un realm dans un dossier ce qui est recommandé pour les realm ayant enormement de donnée oubien dans un fichier directement.
Voir la [doc-ici](https://www.keycloak.org/server/importExport).

Nous allons traiter le cas d'export d'import de realm dans un fichier.

Cela pourrait se faire comme suite:
- Executer la commande d'exportation depuis un terminal 
```bash
docker exec -it <nom-du-conteneur> /opt/keycloak/bin/kc.sh export --realm=my-realm --file=/tmp/my-realm.json
```
- Copier le fichier exporté à l'exterieur du container
```bash
docker cp <nom-du-conteneur>:/tmp/my-realm.json ./my-realm.json
```

###### Importation:

Lorque l'option `--import-realm` est ajouté à l'option de demarrage du container keycloak, il va automatiquement importer tous les realm qui se trouvent dans le dossier `/opt/keycloak/data/import` qui est à l'interieur du container.
il suffit donc :
- de monté un volume des realm à importer dans ce dossier
```yml
volumes:    
    - ./realm:/opt/keycloak/data/import
```
- ajuster la commande de demarrage du container
```yml
command: > 
    start --import-real
```
- Il est possible de changer le dossier de lecture des realm par defaut avec des variable predefine par keycloak (`KC_DIR`). On peut aussi importer un seul realm au lieu d'un ensemble en utilisant la variable (`KC_FILE`).
```yml
```

- La variable `KC_OVERRIDE` permet de dire à keyclok s'il doit ecrasser les données des realm existant ou pas.

#### Execution

- En mode production

```bash
docker compose up -d --force-recreate
docker logs -f auth
```
- En mode dev

Il faut commenter les varaibles `KC_HTTPS_CERTIFICATE_KEY_FILE` et `KC_HTTPS_CERTIFICATE_FILE` puis executer :

```bash
docker compose up -d --force-recreate
docker logs -f auth
```

## Documentations

(All Config option for keycloak)[https://www.keycloak.org/server/all-config#category-proxy]
(Documentation for keycloak)[https://www.keycloak.org/guides#getting-started]
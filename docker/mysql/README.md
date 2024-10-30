# MySQL : Présentation et Configuration

## Présentation

MySQL est un système de gestion de base de données relationnelle (SGBDR) très répandu, surtout utilisé pour des applications web. MySQL utilise SQL (Structured Query Language) pour manipuler les données et offre une bonne performance pour des systèmes à lecture intensive.
Configuration Principale

## Gestion des bases de données, des utilisateur et priviléges

Toutes les base de données sont independantes ainsi que les utilisateurs. Un utilisateur doit alors avoir des priviléges sur les bases de données, ou table ou colonne des bases de données qu'il doit manipuler.

### Gestion des Bases de Données

    Structure : MySQL utilise une architecture avec plusieurs bases de données logiques indépendantes, chacune ayant ses tables, vues, et routines. Il n'existe pas de hiérarchie formelle entre les bases de données dans MySQL ; chaque base de données est autonome.
    Fichier de stockage : Par défaut, MySQL stocke les données dans des fichiers de tables (.ibd pour InnoDB) et de métadonnées spécifiques au moteur de stockage.

### Gestion des Utilisateurs et Permissions

    Comptes d’utilisateurs : MySQL gère les utilisateurs au niveau global. Les comptes sont créés avec CREATE USER et identifiés par un nom d'utilisateur et un hôte (username@host). Les utilisateurs peuvent avoir des privilèges distincts sur différentes bases de données, tables, ou colonnes.
    Permissions : MySQL utilise des privilèges détaillés (comme SELECT, INSERT, UPDATE, etc.) pour contrôler l'accès des utilisateurs. Les privilèges peuvent être définis au niveau global (toutes les bases de données), base de données spécifique, table, ou même colonne.
    Relations utilisateurs-bases de données : Les utilisateurs n'ont pas de relation explicite avec des bases de données spécifiques ; les permissions d'accès sont déterminées par les privilèges accordés. Les utilisateurs peuvent accéder à une ou plusieurs bases de données en fonction des privilèges assignés

## Configuration de base de mysql

#### fichier de configuration

Le fichier de configuration principal de MySQL, nommé généralement my.cnf, contient les options de configuration qui contrôlent le comportement du serveur MySQL. Sur les systèmes Linux, ce fichier se trouve souvent dans les répertoires suivants : `/etc/my.cnf`, `/etc/mysql/my.cnf`, ou `/usr/local/mysql/etc/my.cnf`.

Voici la structure typique de ce fichier et une explication des options les plus importantes :
Structure du Fichier my.cnf

Le fichier est divisé en sections pour différents composants et services MySQL, comme [mysqld] pour le serveur MySQL, [client] pour les clients MySQL, et [mysql] pour l’interface en ligne de commande.

```ini
[client]
# Configuration du client MySQL
user = your_user
password = your_password
host = localhost
port = 3306

[mysqld]
# Configuration du serveur MySQL
port = 3306
bind-address = 0.0.0.0
datadir = /var/lib/mysql
socket = /var/run/mysqld/mysqld.sock
log_error = /var/log/mysql/error.log

# Gestion de la mémoire
key_buffer_size = 16M
innodb_buffer_pool_size = 128M
innodb_log_file_size = 50M
query_cache_size = 64M

# Paramètres de performance
max_connections = 151
table_open_cache = 2000
thread_cache_size = 50
max_allowed_packet = 16M

[mysql]
# Configuration pour le client mysql
no-auto-rehash
```

#### Options Importantes et Explications

Section [client]

- Cette section configure les paramètres par défaut pour les clients MySQL.

    user : Nom d’utilisateur par défaut pour les connexions client.
    password : Mot de passe de l’utilisateur. (Peut être omis pour des raisons de sécurité.)
    host : Hôte MySQL par défaut ; localhost pour une connexion locale.
    port : Port de connexion par défaut, généralement 3306.

Section [mysqld]

- Cette section configure les paramètres du serveur MySQL.

    port : Le port sur lequel le serveur écoute, par défaut 3306.
    bind-address : Définit l’adresse IP à laquelle MySQL doit être lié. 0.0.0.0 permet à MySQL d’écouter sur toutes les interfaces réseau, alors que 127.0.0.1 limite la connexion aux utilisateurs locaux.
    datadir : Répertoire où sont stockées les bases de données MySQL.
    socket : Chemin du socket Unix pour les connexions locales.
    log_error : Emplacement du fichier de log d’erreurs. Ce fichier est important pour surveiller les problèmes du serveur.

- Gestion de la Mémoire

    key_buffer_size : Définit la taille du cache de clés utilisé pour les tables MyISAM. Cette option est importante pour les performances de lecture/écriture avec MyISAM.
    innodb_buffer_pool_size : Taille de la mémoire utilisée par InnoDB pour mettre en cache les données et index. Plus cette valeur est élevée, mieux InnoDB peut gérer les grandes bases de données.
    innodb_log_file_size : Taille du fichier de journal InnoDB. Des fichiers de log plus grands permettent de réduire les I/O, mais peuvent allonger le temps de récupération.

- Paramètres de Performance

    max_connections : Nombre maximal de connexions simultanées autorisées. Si ce nombre est atteint, MySQL refusera les nouvelles connexions.
    table_open_cache : Nombre maximum de tables ouvertes en cache. Plus la valeur est élevée, plus les performances sont améliorées pour les serveurs qui manipulent de nombreuses tables.
    thread_cache_size : Nombre de threads en cache pour les connexions réutilisables, ce qui améliore les performances en réduisant la surcharge de création de threads.
    max_allowed_packet : Taille maximale autorisée pour les paquets de données. Utilisé pour contrôler la taille des messages envoyés entre le client et le serveur.

Section [mysql]

- Cette section est destinée à l’interface de ligne de commande mysql.

    no-auto-rehash : Cette option désactive le rehashing automatique des commandes, ce qui accélère le démarrage de l’interface MySQL.

- Commande pour Tester et Appliquer les Changements

Une fois le fichier de configuration mis à jour, il est recommandé de redémarrer le serveur pour que les modifications prennent effet :

bash

sudo systemctl restart mysql

Pour vérifier que le fichier de configuration est correctement chargé, utilisez la commande suivante pour afficher les paramètres actifs :

bash

mysql --help | grep my.cnf

Ce fichier my.cnf permet d'ajuster MySQL selon les besoins spécifiques, qu’il s’agisse d’optimiser les performances, de gérer la sécurité, ou de configurer les connexions réseau.



## Commands importante mysql

1. Connexion à MySQL

- Pour vous connecter à MySQL depuis un terminal avec un nom d’utilisateur (user) et un mot de passe (password), utilisez :

```bash
mysql -u user -p
```

- Exemple avec une base de données spécifique :

```bash
mysql -u user -p database_name -h hostname/ipaddr -p port
```

2. Gestion des Bases de Données

- Créer une base de données :

```bash
CREATE DATABASE database_name;
```

- Sélectionner une base de données :

```sql
USE database_name;
```

- Lister les bases de données :

```sql
SHOW DATABASES;
```

Supprimer une base de données :

```sql
DROP DATABASE database_name;
```

3. Gestion des Tables

- Créer une table :

```sql
CREATE TABLE table_name (
    id INT AUTO_INCREMENT PRIMARY KEY,
    column1_name VARCHAR(255),
    column2_name INT
);
```

- Afficher les tables d'une base de données :

```sql
SHOW TABLES;
```

Modifier une table :

- Ajouter une colonne :

```sql
ALTER TABLE table_name ADD column_name VARCHAR(255);
```

- Supprimer une colonne :

```sql
ALTER TABLE table_name DROP COLUMN column_name;
```

- Renommer une colonne :

```sql
ALTER TABLE table_name CHANGE old_column_name new_column_name VARCHAR(255);
```

- Supprimer une table :

```sql
DROP TABLE table_name;
```

4. Gestion des Lignes (Données)

- Insérer des données :

```sql
INSERT INTO table_name (column1_name, column2_name) VALUES ('value1', 123);
```

Mettre à jour des données :

```sql
UPDATE table_name SET column1_name = 'new_value' WHERE id = 1;
```

- Supprimer des données :

```sql
DELETE FROM table_name WHERE id = 1;
```

Afficher les données :

```sql
SELECT * FROM table_name;
```

5. Gestion des Utilisateurs

- Créer un utilisateur :

```sql
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
```

- Accorder des privilèges :

```sql
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost';
```

- Supprimer les privilèges d’un utilisateur :

```sql
REVOKE ALL PRIVILEGES ON database_name.* FROM 'username'@'localhost';
```
- 
Supprimer un utilisateur :

```sql
DROP USER 'username'@'localhost';
```

- Voir les privilèges :

```sql
SHOW GRANTS FOR 'username'@'localhost';
```

6. Exemple de Script SQL à Exécuter depuis le Terminal

Vous pouvez créer un fichier SQL (par exemple script.sql) et y écrire les commandes pour effectuer plusieurs actions.
Contenu du fichier script.sql :

```sql
-- Sélectionner une base de données
USE example_db;

-- Créer une table
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255),
    salary DECIMAL(10, 2)
);

-- Insérer des données
INSERT INTO employees (name, position, salary) VALUES ('Alice', 'Developer', 60000.00);
INSERT INTO employees (name, position, salary) VALUES ('Bob', 'Designer', 50000.00);

-- Afficher les données
SELECT * FROM employees;

-- Mettre à jour un salaire
UPDATE employees SET salary = 65000.00 WHERE name = 'Alice';

-- Supprimer un employé
DELETE FROM employees WHERE name = 'Bob';

```

- Exécution du script SQL depuis le terminal

Pour exécuter ce script, utilisez la commande suivante dans votre terminal :

```bash
mysql -u user -p example_db < script.sql
```

Cela exécute toutes les commandes du fichier script.sql sur la base de données example_db.


## Deploiement rapide de ce projet

To deploy this projet you need : 

- To update the next variables
```conf
# Docker compose configuration
MEM_LIMIT=256M
MEM_RESERVATION=128M
HEALTHCHECK_START_PERIOD=5s
HEALTHCHECK_INTERVAL=30s
HEALTHCHECK_TIMEOUT=10s
HEALTHCHECK_RETRIES=3
MYSQL_VERSION=8.0  
MYSQL_DATA_VOLUME_DIR=/opt/docker_app_config_dir/mysql/mysql_data
MYSQL_PORT=3306

### Mysql configuration
MYSQL_ROOT_PASSWORD=arrow123
MYSQL_DATABASE=avatar
MYSQL_USER=arrow
MYSQL_PASSWORD=arrow123
```

- Run this command :
```bash
docker compose up -d
```

## Operation

To connect to the database, you need to run : 

```bash
mysql -u user -p
```
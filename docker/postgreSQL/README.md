# PostgreSQL

## Présentation

PostgreSQL est un SGBDR avancé et orienté vers la conformité aux normes ACID (Atomicité, Cohérence, Isolation, Durabilité). Il est souvent préféré pour des applications nécessitant des transactions complexes, des types de données avancés, et une extensibilité avec des fonctionnalités personnalisées (procédures stockées, etc.).

## Gestion des bases de données, des utilisateur et priviléges

Dans Postgre, il y'a des bases de donnée et des roles.
Un role represente un utilisateur pour une base de donnée.
Un role peut avoir les priviléges sur plusieurs base de donnée et tables de base donnée.
Chaque base de donnée a son ensemble de role.


### Gestion des Bases de Données

Structure : PostgreSQL est organisé en clusters. Un cluster PostgreSQL est un ensemble de bases de données gérées par une instance de PostgreSQL. Chaque cluster contient plusieurs bases de données logiques, qui peuvent être isolées les unes des autres.
Fichier de stockage : PostgreSQL stocke chaque cluster dans un répertoire de données principal, et chaque base de données est divisée en tablespaces (emplacements physiques de stockage). Par défaut, tous les objets d'une base de données (tables, index, etc.) sont stockés ensemble, mais les tablespaces permettent de distribuer les données sur différents emplacements.


### Gestion des Utilisateurs et Permissions

- Rôles et utilisateurs : PostgreSQL utilise des rôles pour gérer les utilisateurs et groupes. Un rôle peut être un utilisateur individuel ou un groupe de rôles (pour gérer plusieurs utilisateurs avec des permissions partagées). Les utilisateurs sont créés avec CREATE ROLE et peuvent être configurés pour avoir ou non la permission de se connecter (login).
- Permissions : Les permissions peuvent être assignées pour une base de données entière, ou à un niveau plus granulaire (tables, vues, fonctions, etc.). Les rôles peuvent recevoir des permissions spécifiques avec des commandes comme GRANT.
Relations utilisateurs-bases de données : Les rôles dans PostgreSQL peuvent posséder des bases de données, mais l'accès est explicitement contrôlé par des privilèges. Chaque base de données a son propre ensemble d'utilisateurs avec des permissions qui ne s'étendent pas aux autres bases de données.


## Configuration de postgreSQL

#### fichier de configuration principal

Le fichier de configuration principal de PostgreSQL, appelé postgresql.conf, contrôle le comportement du serveur PostgreSQL. Ce fichier se trouve généralement dans le répertoire de données de PostgreSQL, souvent situé dans `/etc/postgresql/<version>/main/postgresql.conf` sur les systèmes Linux Debian/Ubuntu ou `/var/lib/pgsql/data/postgresql.conf` sur les distributions basées sur Red Hat/CentOS.

Voici la structure typique de postgresql.conf et les explications des options clés.
Structure du Fichier postgresql.conf

Le fichier est organisé par catégories comme Paramètres de Connexion, Gestion de la Mémoire, Optimisation de la Performance, et Journaux et Logs. Chaque paramètre peut être activé ou désactivé en supprimant ou ajoutant un # en début de ligne.

```ini

# -----------------------------------------------------------------
# Paramètres de connexion
# -----------------------------------------------------------------
listen_addresses = '*'
port = 5432
max_connections = 100

# -----------------------------------------------------------------
# Paramètres de mémoire
# -----------------------------------------------------------------
shared_buffers = 128MB
work_mem = 4MB
maintenance_work_mem = 64MB

# -----------------------------------------------------------------
# Paramètres de performance
# -----------------------------------------------------------------
effective_cache_size = 256MB
max_worker_processes = 8
max_parallel_workers_per_gather = 2

# -----------------------------------------------------------------
# Journaux et logs
# -----------------------------------------------------------------
log_directory = 'pg_log'
log_filename = 'postgresql-%Y-%m-%d.log'
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d '

# -----------------------------------------------------------------
# Paramètres de sécurité
# -----------------------------------------------------------------
ssl = on
password_encryption = scram-sha-256
```

#### Options Importantes et Explications

- Paramètres de Connexion

    listen_addresses : Détermine les adresses IP sur lesquelles le serveur écoute. * permet à PostgreSQL d'écouter sur toutes les interfaces réseau, tandis que localhost limite les connexions aux utilisateurs locaux.
    port : Définit le port sur lequel PostgreSQL écoute, généralement 5432.
    max_connections : Nombre maximal de connexions simultanées autorisées. Ajuster cette valeur selon les besoins en termes de charge.

- Paramètres de Mémoire

    shared_buffers : Quantité de mémoire dédiée pour le cache des données PostgreSQL. Une valeur plus élevée peut améliorer les performances, particulièrement pour les bases de données volumineuses.
    work_mem : Quantité de mémoire utilisée par les opérations de tri et de jointure. Définir une valeur adaptée selon la complexité des requêtes.
    maintenance_work_mem : Mémoire utilisée pour les opérations de maintenance comme l’indexation ou le VACUUM.

- Paramètres de Performance

    effective_cache_size : Estimation de la mémoire totale que le système d’exploitation utilise pour le cache de disque. Cela aide le planificateur de requêtes PostgreSQL à déterminer la quantité de données à charger.
    max_worker_processes : Nombre maximal de processus de travail, affectant les capacités de parallélisme. Augmenter cette valeur permet de gérer des requêtes complexes.
    max_parallel_workers_per_gather : Limite le nombre de travailleurs parallèles dans une requête. Cela optimise le traitement de requêtes de grande taille.

- Journaux et Logs

    log_directory : Répertoire où les fichiers de log seront enregistrés. Cela aide à la surveillance des erreurs et des connexions.
    log_filename : Format du nom des fichiers de log, par exemple postgresql-%Y-%m-%d.log pour inclure la date.
    log_line_prefix : Format des lignes de log, avec des options comme %t (timestamp), %p (PID), %u (utilisateur) et %d (base de données).

- Paramètres de Sécurité

    ssl : Active ou désactive SSL pour les connexions sécurisées (on pour activer, off pour désactiver).
    password_encryption : Définit la méthode d’encryption pour les mots de passe des utilisateurs. scram-sha-256 est recommandé pour une meilleure sécurité.

- Appliquer et Tester les Changements

Après avoir modifié postgresql.conf, il est nécessaire de redémarrer le serveur PostgreSQL pour que les changements prennent effet :

```bash
sudo systemctl restart postgresql
```
Pour vérifier que PostgreSQL écoute correctement sur les adresses configurées, vous pouvez utiliser la commande suivante :

```bash
psql -U username -d database_name -h server_ip -p port_number
```
La configuration de postgresql.conf est essentielle pour ajuster les performances, la sécurité, et la gestion des connexions de PostgreSQL.


## Command important pour postgreSQL

1. Connexion à PostgreSQL

Pour vous connecter à PostgreSQL avec un nom d'utilisateur (user) et une base de données spécifique (database_name), utilisez :

- sur localhost:

```bash
psql -U user -d database_name
```

- Si PostgreSQL demande un mot de passe, ajoutez -W :

```bash
psql -U user -W -d database_name
```

- sur un host distant
```bash
psql -U user -W -d database_name -h server_dns -p port_number
```

2. Gestion des Bases de Données

- Créer une base de données :

```sql
CREATE DATABASE database_name;
```

- Sélectionner une base de données : Vous pouvez spécifier la base de données lors de la connexion ou utiliser \c (connect) dans la console PostgreSQL.

```sql
\c database_name
```

- Lister les bases de données :

```sql
\l
```

- Supprimer une base de données :

```sql
DROP DATABASE database_name;
```

3. Gestion des Tables

- Créer une table :

```sql
CREATE TABLE table_name (
    id SERIAL PRIMARY KEY,
    column1_name VARCHAR(255),
    column2_name INT
);
```

- Afficher les tables d'une base de données :

```sql
\dt
```

Modifier une table :

- Ajouter une colonne :

```sql
ALTER TABLE table_name ADD COLUMN column_name VARCHAR(255);
```

- Supprimer une colonne :

```sql
ALTER TABLE table_name DROP COLUMN column_name;
```

Renommer une colonne :

```sql
ALTER TABLE table_name RENAME COLUMN old_column_name TO new_column_name;
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

- Mettre à jour des données :

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

5. Gestion des Utilisateurs et Rôles

- Créer un utilisateur (rôle avec connexion) :

```sql
CREATE ROLE username WITH LOGIN PASSWORD 'password';
```

- Accorder des privilèges à un utilisateur :

```sql
GRANT ALL PRIVILEGES ON DATABASE database_name TO username;
```

- Supprimer les privilèges d’un utilisateur :

```sql
REVOKE ALL PRIVILEGES ON DATABASE database_name FROM username;
```

- Supprimer un utilisateur :

```sql
DROP ROLE username;
```

- Voir les privilèges :

```sql
\du
```

6. Exemple de Script SQL à Exécuter depuis le Terminal

Vous pouvez créer un fichier SQL (par exemple script.sql) pour exécuter plusieurs actions sur PostgreSQL.
Contenu du fichier script.sql :

```sql
-- Sélectionner une base de données
\c example_db;

-- Créer une table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255),
    salary NUMERIC(10, 2)
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
psql -U user -d example_db -f script.sql
```

Cela exécute toutes les commandes dans script.sql sur la base de données example_db.




## Deploiement rapide de ce projet

To deploy this projet you need : 

- To update the next variables
```conf
# docker compose config
MEM_LIMIT=256M
MEM_RESERVATION=128M
HEALTHCHECK_START_PERIOD=5s
HEALTHCHECK_INTERVAL=30s
HEALTHCHECK_TIMEOUT=10s
HEALTHCHECK_RETRIES=3
POSTGRESQL_VERSION=13
POSTGRESQL_DATA_VOLUME_DIR=/opt/docker_app_config_dir/mysql/postgres_data
POSTGRESQL_PORT=5432

# PostgreSQL config
POSTGRES_DB=avatar_db
POSTGRES_USER=avatar
POSTGRES_PASSWORD=avatar123
```

- Run this command :
```bash
docker compose up -d
```

## Operation

To connect to the database, you need to run : 

```bash
psql -U user -W -d database_name
```
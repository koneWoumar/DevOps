# Oracle Database – Guide de Prise en Main

## Présentation

Oracle Database est un SGBD relationnel puissant, utilisé dans des environnements critiques pour la gestion de grandes quantités de données. Il est particulièrement apprécié pour ses capacités avancées en clustering, réplication, sécurité et performance.

### Cas d’usage typiques :
- Systèmes d'information d'entreprises
- Applications bancaires
- Logiciels ERP/CRM
- Systèmes embarqués critiques

---

## Architecture d'une base Oracle

Voici les composants clés de l’architecture Oracle :

| Terme | Description |
|-------|-------------|
| **SID** (System Identifier) | Identifiant d'une instance Oracle. Il relie les processus et la mémoire partagée. |
| **SERVICE_NAME** | Nom logique utilisé pour accéder à la base via le réseau. |
| **Instance** | Ensemble des processus et de la mémoire partagée qui accède à une base physique. |
| **Datafiles** | Fichiers contenant les données utilisateur et système. |
| **Controlfiles** | Fichiers critiques contenant la structure de la base (état, SCN, datafiles, etc.). |
| **Redo Logs** | Fichiers enregistrant les changements pour assurer la récupération. |
| **Listener** | Processus réseau qui écoute les connexions distantes à la base Oracle. |
| **TNSNAMES.ORA** | Fichier client contenant les configurations de connexions Oracle (équivalent d’un DNS Oracle). |

---

## Mise en place d’une base de données Oracle (from scratch)


### 🧩 1. Première connexion au SGBD Oracle

Après installation (par ex. via RPM sur Red Hat), l’utilisateur `oracle` est créé. Pour se connecter :

```bash
sqlplus / as sysdba
```
Cette commande permet de se connecter en tant qu’administrateur sans mot de passe, grâce à l’authentification OS .

### 📦 2. À ce stade : qu’avons-nous ?


L’instance Oracle est démarrée.
Mais aucune base de données n’est encore montée.
Nous devons créer une base (base physique) et l’instance associée. (peut avoir plusieur instance associé?)

### 🛠️ 3. Création d’une Base de Données

1. #### Création du fichier d'initialisation (init<SID>.ora)

Ce fichier se situe en général dans /opt/oracle/product/23ai/dbhomeFree/dbs/

- /opt/oracle/product/23ai/dbhomeFree/dbs/init<SID>.ora :
```ini
db_name='gazelle'
memory_target=1G
processes=150
audit_file_dest='/opt/oracle/admin/gazelle/adump'
db_recovery_file_dest='/opt/oracle/fast_recovery_area'
db_recovery_file_dest_size=2G
control_files='/opt/oracle/oradata/gazelle/control01.ctl'
```

2. #### Creation des fichiers physique et exportation d'ORACLE_SID


export ORACLE_SID=gazelle

3. #### Démarrer l’instance en mode nomount

```bash
# Connection
sqlplus / as sysdba

# Demarrer en precisant le fichier d'initialisation
STARTUP NOMOUNT PFILE='/opt/oracle/product/23ai/dbhomeFree/dbs/initGAZELLE.ora'

# Demarrer en montant la base de donnée
STARTUP NOMOUNT;
```

4. #### Création de la base

```sql
CREATE DATABASE gazelle
USER SYS IDENTIFIED BY "password"
USER SYSTEM IDENTIFIED BY "password"
LOGFILE GROUP 1 ('/opt/oracle/oradata/gazelle/redo01.log') SIZE 50M,
        GROUP 2 ('/opt/oracle/oradata/gazelle/redo02.log') SIZE 50M
MAXLOGFILES 5
MAXDATAFILES 100
DATAFILE '/opt/oracle/oradata/gazelle/system01.dbf' SIZE 700M REUSE
SYSAUX DATAFILE '/opt/oracle/oradata/gazelle/sysaux01.dbf' SIZE 550M
UNDO TABLESPACE UNDOTBS1 DATAFILE '/opt/oracle/oradata/gazelle/undotbs01.dbf' SIZE 200M
DEFAULT TEMPORARY TABLESPACE temp TEMPFILE '/opt/oracle/oradata/gazelle/temp01.dbf' SIZE 100M;
```

#### 🚀 5- Démarrage d’une instance Oracle
Une base Oracle peut avoir plusieurs instances ?
Non. Une instance est unique par base de données, sauf en mode RAC (Real Application Cluster).

- Se connecter à la base
```bash
export ORACLE_SID=gazelle
sqlplus / as sysdba
```
- Démarrage de l’instance :
```sql
STARTUP;
```

#### -6 📡 Configuration de Listener et TNS

listener.ora :*

```sql
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = red-hat.local)(PORT = 1521))
    )
  )

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = gazelle)
      (ORACLE_HOME = /opt/oracle/product/23ai/dbhomeFree)
      (SID_NAME = gazelle)
    )
  )
```

tnsnames.ora (côté client) :

```conf
gazelle =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = red-hat.local)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = gazelle)
    )
  )
```

## Mise d'un base de donnée via docker compose

### Fichiers de doployments

- Fichier docker compose :

```yaml
version: '3.1'
services:
  oracle-db:
    image: container-registry.oracle.com/database/enterprise:latest
    environment:
      - ORACLE_SID=${ORACLE_SIDE}
      - ORACLE_PDB=${DB_NAME}
      - ORACLE_PWD=${DB_PWD}
    ports:
      - 1521:1521
    volumes:
      - oracle-data:/opt/oracle/oradata
      - oracle-backup:/opt/oracle/backup
    healthcheck:
      test: ["CMD", "sqlplus", "-L", "sys/${DB_PWD}@//localhost:1521/ORCLCDB as sysdba", "@healthcheck.sql"]
      interval: 30s
      timeout: 10s
      retries: 5

volumes:
  oracle-data:
  oracle-backup:
```

- Fichier .env
```conf
ORACLE_SIDE=GAZASIDE
DB_NAME=gaza
DB_PWD=gaza_123
```
### Prerequis
-  Aller sur [oralce-officiel-container-registry](https://container-registry.oracle.com/ords/f?p=113:10:22727848753910:::::)
-  Creer un compte gratuitement (you need just an email addr and phone number)
-  Accepter les conditions d'utilisation des images dockers qu'on veut telecharger
clik on Tabase , then accepte conditions for images you want to use, you can follow [this link for that](https://container-registry.oracle.com/ords/f?p=113:1:22727848753910:::1:P1_BUSINESS_AREA:3&cs=3Sk9CLuh-JLDCc_sI79MzN_AOMyeukYWU5Kur7Stfs_HiH7gzBLM8srJJY4i0ClUFaAHzjJNbKWLiinKCuN8Yvg)

-  Faire un docker login sur son host qui va executer le docker compose
```bash
docker login 
docker login container-registry.oracle.com
Username: kone.wolouho@gmail.com
Password: ***** --> my account passwd here
Login Succeeded
```

## Installation de l'instant client sur un machine cliente

- Telechar les packages de l'instant client et sql-plus sur [https://www.oracle.com/database/technologies/instant-client/downloads.html](https://www.oracle.com/database/technologies/instant-client/downloads.html)

- Decompresser dans un dossier de votre choix par exemple `/oracle/instant_client`
- Configurer le client sur le profile de l'utilisateur en ajoutant dans `~/.bashrc`
```conf
export ORACLE_HOME=~/oracle/instantclient/instantclient_21_13
export PATH=$ORACLE_HOME:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
```


## 📘 Oracle Database – Commandes d'Administration de Base

### 🔐 Connexions

#### 1. Connexion via authentification OS (sans mot de passe)
```bash
sqlplus / as sysdba
```

#### 2. Connexion via TNS (service défini dans `tnsnames.ora`)
```bash
sqlplus user/password@TNS_ALIAS
```

#### 3. Connexion sans TNS (Easy Connect)
```bash
sqlplus user/password@//host:port/SERVICE_NAME
```

---

### 🔍 Informations système

#### 🔎 Afficher le nom de la base de données (CDB)
```sql
SELECT name FROM v$database;
```

#### 🔎 Afficher la liste des PDB (Pluggable Databases)
```sql
SELECT pdb_name, status FROM dba_pdbs;
```

#### 🔎 Afficher les utilisateurs (schemas)
```sql
SELECT username FROM dba_users;
```

---

### 📂 Tables & Colonnes

#### 🔎 Afficher les tables accessibles par l'utilisateur courant
```sql
SELECT table_name FROM user_tables;
```

#### 🔎 Afficher toutes les tables dans la base
```sql
SELECT owner, table_name FROM all_tables;
```

#### 🔎 Afficher les colonnes d’une table
```sql
DESC nom_table;
-- ou
SELECT column_name, data_type FROM user_tab_columns WHERE table_name = 'NOM_TABLE';
```

---

### 🏗️ Manipulations de schéma

#### ➕ Créer une table
```sql
CREATE TABLE employes (
    id NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    poste VARCHAR2(50),
    salaire NUMBER
);
```

#### ➕ Ajouter une colonne à une table existante
```sql
ALTER TABLE employes ADD email VARCHAR2(100);
```

---

### 📝 Manipulation de données

#### ➕ Insérer un enregistrement
```sql
INSERT INTO employes (id, nom, poste, salaire) 
VALUES (1, 'Jean Dupont', 'Développeur', 40000);
```

#### 🛠️ Modifier un enregistrement
```sql
UPDATE employes 
SET salaire = 45000 
WHERE id = 1;
```

#### ❌ Supprimer un enregistrement
```sql
DELETE FROM employes WHERE id = 1;
```

#### 🔎 Afficher tous les enregistrements d’une table
```sql
SELECT * FROM employes;
```

---

### 👮 Gestion des utilisateurs

#### ➕ Créer un utilisateur
```sql
CREATE USER gazelle IDENTIFIED BY MonMotDePasse;
```

#### 🛡️ Donner des privilèges (rôles standards)
```sql
GRANT CONNECT, RESOURCE TO gazelle;
```

#### 🛡️ Donner l'accès à une base (dans une CDB)
```sql
ALTER SESSION SET CONTAINER = ORCLPDB1;
CREATE USER gazelle IDENTIFIED BY MonMotDePasse;
GRANT CONNECT, RESOURCE TO gazelle;
```

#### 🔒 Verrouiller / déverrouiller un utilisateur
```sql
ALTER USER gazelle ACCOUNT LOCK;
ALTER USER gazelle ACCOUNT UNLOCK;
```

#### ❌ Supprimer un utilisateur
```sql
DROP USER gazelle CASCADE;
```

#### 🛡️ Attribuer un rôle personnalisé
```sql
GRANT dba TO gazelle;
```

---

### 🚦 État de la base de données

#### 🔎 Voir l’état de l’instance
```sql
SELECT status FROM v$instance;
```

#### 🔄 Démarrer une instance
```sql
STARTUP;
-- ou avec fichier paramètre
STARTUP PFILE='/chemin/init.ora';
```

#### ⛔ Arrêter l’instance
```sql
SHUTDOWN IMMEDIATE;
```

---

### 🛠️ Autres opérations utiles

#### 🔄 Changer le mot de passe d’un utilisateur
```sql
ALTER USER gazelle IDENTIFIED BY NouveauMotDePasse;
```

#### 🧽 Vider une table
```sql
TRUNCATE TABLE employes;
```

#### 📌 Voir les rôles d’un utilisateur
```sql
SELECT * FROM dba_role_privs WHERE grantee = 'GAZELLE';
```

---

### 📦 Export/Import (via `expdp` / `impdp`)

#### ➤ Exporter un schéma
```bash
expdp gazelle/MonMotDePasse schemas=gazelle directory=DATA_PUMP_DIR dumpfile=gazelle.dmp logfile=gazelle_exp.log
```

#### ➤ Importer un schéma
```bash
impdp gazelle/MonMotDePasse schemas=gazelle directory=DATA_PUMP_DIR dumpfile=gazelle.dmp logfile=gazelle_imp.log
```

---

### 🧠 Astuces

- Toutes les commandes SQL peuvent être exécutées depuis `sqlplus` ou un outil graphique comme SQL Developer.
- Pour créer une table dans une **PDB**, n’oublie pas de vous connecter à la bonne PDB avec :
```sql
ALTER SESSION SET CONTAINER=ORCLPDB1;
```

---

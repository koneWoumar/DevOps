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


2. #### Exporter la variable ORACLE_SID

export ORACLE_SID=gazelle

3. #### Démarrer l’instance en mode nomount

sqlplus / as sysdba
STARTUP NOMOUNT;

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

#### 6- ⚙️ Opérations diverses

##### 👤 Création d’un utilisateur
```sql
CREATE USER dev IDENTIFIED BY devpassword
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

GRANT CONNECT, RESOURCE TO dev;
```

##### 📡 Configuration de Listener et TNS

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

##### 🔐 Connexion avec un utilisateur

```
sqlplus dev/devpassword@gazelle
```

##### ✍️ CRUD – Opérations de base

###### -- Création d'une table

```sql
CREATE TABLE employes (
  id NUMBER PRIMARY KEY,
  nom VARCHAR2(100),
  salaire NUMBER
);
```

###### -- Insertion

```sql
INSERT INTO employes (id, nom, salaire) VALUES (1, 'Alice', 3000);
```
###### -- Affichage

```sql
SELECT * FROM employes;
```
###### -- Modification
```sql
UPDATE employes SET salaire = 3200 WHERE id = 1;
```
###### -- Suppression

```sql
DELETE FROM employes WHERE id = 1;
```

#### 🧠 Remarques et subtilités

Le nom du fichier init<SID>.ora doit correspondre au ORACLE_SID.
STARTUP NOMOUNT permet d’exécuter des opérations d’administration comme la création d’une base.
db_recovery_file_dest doit exister sur le système de fichiers.
En cas d’erreur ORA-01034 ou ORA-01507, la base n’est souvent pas montée ou les fichiers de contrôle sont absents.
L'ordre typique : STARTUP NOMOUNT → CREATE DATABASE → MOUNT → OPEN.

## Memo des commandes importants

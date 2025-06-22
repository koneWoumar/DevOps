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

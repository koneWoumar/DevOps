# ANSIBLE

## Introduction à Ansible

Ansible est un outil d'automatisation open source qui simplifie la gestion de la configuration, le déploiement d'applications, et l'orchestration des tâches complexes sur des infrastructures IT. Grâce à son approche "sans agent", il ne nécessite pas l'installation d'un logiciel supplémentaire sur les machines gérées, rendant sa mise en place simple et rapide. Ansible fonctionne en utilisant SSH pour se connecter à des hôtes distants et exécuter des commandes définies dans des playbooks.
Concepts de base d'Ansible :

- Inventory : Un fichier listant les hôtes et groupes de machines que vous souhaitez gérer.
- Playbook : Un fichier écrit en YAML décrivant les tâches à exécuter sur un ou plusieurs hôtes.
- Module : Des unités de travail, appelées dans les tâches pour effectuer des actions comme installer des paquets, copier des fichiers, ou redémarrer des services.
- Task : Une action individuelle exécutée sur un ou plusieurs hôtes (par exemple, "installer Apache").
- Role : Un ensemble organisé de tâches, variables et fichiers utilisés pour configurer une partie spécifique d'une infrastructure.

## Installation sur Ubuntu/Debian


```bash
sudo apt update
sudo apt install ansible
ansible --version
```

## Structure d'un projet Ansible

- Tout projet ansible a pour structure : 

/~/my-ansible-project/
├── ansible.cfg        # Configuration locale du projet
├── inventory          # Inventaire des hôtes du projet
├── playbook.yml       # Playbook à exécuter
└── roles/             # Dossier contenant des rôles (si nécessaire)


- Le repertoire de travail par defaut de ansible est `/etc/ansible/` avec pour structure: 

/etc/ansible/
├── ansible.cfg
├── inventory
├── playbook.yml
└── roles/

- ansible va t'il chercher toutes les configurations dans le fichier local en priorité sinon dans le dossier de travail par defaut qui est `/etc/ansible/` .



## Ansible - Principaux Modules

Ansible propose une vaste gamme de **modules** qui permettent d'automatiser diverses tâches sur les systèmes, réseaux, cloud, et plus encore. Ces modules permettent de gérer des serveurs, d'exécuter des commandes, de copier des fichiers, de gérer des utilisateurs, des packages, et bien plus.

Ci-dessous, vous trouverez une liste des modules principaux d'Ansible classés par catégories, avec une brève description de leurs fonctionnalités.

---

#### 1. **Modules système**
Ces modules permettent d'administrer et de gérer les configurations des systèmes d'exploitation.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `command`            | Exécute une commande sur un hôte distant.                                   |
| `shell`              | Exécute des commandes dans le shell.                                        |
| `user`               | Gère les utilisateurs et les groupes du système.                            |
| `cron`               | Gère les tâches planifiées dans la crontab.                                 |
| `service`            | Démarre, arrête, redémarre et gère les services sur le système.             |
| `package`            | Gère les packages installés sur le système (compatibilité avec plusieurs gestionnaires de paquets : yum, apt, etc.). |

---

#### 2. **Modules de gestion de fichiers**
Ces modules permettent de gérer les fichiers et répertoires à distance.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `copy`               | Copie des fichiers depuis le système local vers les hôtes distants.          |
| `file`               | Gère les permissions, propriétaires et liens de fichiers.                   |
| `fetch`              | Récupère un fichier depuis un hôte distant.                                 |
| `template`           | Génére un fichier à partir d’un modèle Jinja2 et le déploie sur l'hôte.      |
| `lineinfile`         | Gère des lignes spécifiques dans des fichiers texte.                        |
| `synchronize`        | Synchronise des fichiers et répertoires à l'aide de rsync.                  |

---

#### 3. **Modules réseau**
Ces modules sont utilisés pour gérer les appareils réseau.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `uri`                | Interagit avec des services web via HTTP/HTTPS (API REST, téléchargement, etc.). |
| `net_ping`           | Vérifie la connectivité réseau à partir d'un hôte vers une cible.            |
| `firewalld`          | Gère la configuration du pare-feu `firewalld`.                              |
| `iptables`           | Gère les règles de pare-feu iptables sur les hôtes.                         |

---

#### 4. **Modules cloud**
Ces modules facilitent la gestion des services dans les environnements cloud.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `ec2`                | Gère les instances EC2 sur AWS.                                             |
| `gce`                | Gère les instances Google Cloud Engine.                                     |
| `azure_rm`           | Gère les services Azure (machines virtuelles, disques, réseaux, etc.).      |

---

#### 5. **Modules de gestion de bases de données**
Ces modules permettent de gérer les bases de données et leurs utilisateurs.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `mysql_db`           | Gère les bases de données MySQL/MariaDB.                                     |
| `mysql_user`         | Gère les utilisateurs et permissions de MySQL/MariaDB.                       |
| `postgresql_db`      | Gère les bases de données PostgreSQL.                                        |
| `postgresql_user`    | Gère les utilisateurs et rôles PostgreSQL.                                   |

---

#### 6. **Modules de gestion des conteneurs**
Ces modules sont utilisés pour gérer les conteneurs Docker ou Kubernetes.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `docker_container`   | Gère les conteneurs Docker (démarrer, arrêter, supprimer, etc.).             |
| `docker_image`       | Gère les images Docker (construction, téléchargement, suppression).         |
| `k8s`                | Gère les ressources Kubernetes (pods, services, déploiements).               |
| `helm`               | Gère les déploiements Helm dans Kubernetes.                                 |

---

#### 7. **Modules de contrôle des hôtes distants**
Ces modules permettent de vérifier l’état ou d’obtenir des informations sur les hôtes.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `ping`               | Vérifie si un hôte est accessible via Ansible.                              |
| `setup`              | Récupère des informations sur les hôtes (inventaire des faits).             |
| `wait_for`           | Attend qu'une condition soit remplie (port ouvert, fichier présent, etc.).  |

---

#### 8. **Modules de gestion de configuration**
Ces modules permettent d’appliquer des configurations sur les systèmes.

| Module               | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `ansible.builtin.include_role` | Inclut un rôle dans une tâche Ansible.                           |
| `ansible.builtin.import_role`  | Importe un rôle dans un playbook Ansible.                        |
| `ansible.builtin.include_vars` | Charge un fichier de variables dans un playbook Ansible.         |

---

Pour une liste complète et à jour des modules, vous pouvez consulter la [documentation officielle d'Ansible](https://docs.ansible.com/ansible/latest/collections/index.html).


## Ansible - Principales Commandes

Ansible fournit une série de **commandes** qui permettent d'exécuter des tâches d'automatisation sur des systèmes distants, de gérer les configurations, et bien plus encore. Ces commandes sont au cœur de l'utilisation d'Ansible pour déployer, configurer, et administrer des systèmes.

Ci-dessous, vous trouverez une liste des commandes principales d'Ansible, avec une description de leur utilisation.

---

#### 1. **`ansible`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible`              | Exécute des tâches Ad-hoc sur un ou plusieurs hôtes. Permet d'exécuter des modules sur des systèmes distants sans utiliser de playbooks. |
| **Exemple**            | `ansible all -m ping` <br> Vérifie la connectivité avec tous les hôtes définis dans l'inventaire. |

---

#### 2. **`ansible-playbook`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-playbook`      | Exécute un playbook Ansible, qui est un fichier YAML contenant une série de tâches structurées. |
| **Exemple**            | `ansible-playbook site.yml` <br> Lance un playbook nommé `site.yml`. |

---

#### 3. **`ansible-inventory`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-inventory`     | Gère et interroge l'inventaire des hôtes d'Ansible. Permet de lister les hôtes ou les groupes d’hôtes. |
| **Exemple**            | `ansible-inventory --list` <br> Affiche la liste des hôtes et des groupes dans l'inventaire. |

---

#### 4. **`ansible-galaxy`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-galaxy`        | Permet de télécharger, installer et gérer des rôles ou des collections Ansible provenant d'Ansible Galaxy ou d'autres sources. |
| **Exemple**            | `ansible-galaxy install geerlingguy.apache` <br> Installe le rôle `apache` de l'utilisateur `geerlingguy` depuis Ansible Galaxy. |

---

#### 5. **`ansible-doc`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-doc`           | Affiche la documentation des modules Ansible directement dans le terminal. |
| **Exemple**            | `ansible-doc apt` <br> Affiche la documentation du module `apt`. |

---

#### 6. **`ansible-vault`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-vault`         | Permet de chiffrer, déchiffrer et gérer des fichiers sensibles (comme des mots de passe ou des clés) via Ansible Vault. |
| **Exemple**            | `ansible-vault encrypt secrets.yml` <br> Chiffre un fichier `secrets.yml` pour le protéger. |

---

#### 7. **`ansible-config`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-config`        | Affiche la configuration courante d'Ansible et permet de valider ou d'obtenir de l'aide sur les fichiers de configuration. |
| **Exemple**            | `ansible-config view` <br> Affiche la configuration actuelle d'Ansible. |

---

#### 8. **`ansible-pull`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-pull`          | Permet d'exécuter des playbooks en mode "pull" en clonant un dépôt Git et en exécutant les tâches à partir de celui-ci. |
| **Exemple**            | `ansible-pull -U https://github.com/monrepo/playbook.git` <br> Exécute un playbook à partir d'un dépôt Git. |

---

#### 9. **`ansible-test`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-test`          | Permet de tester des rôles, modules, collections ou autres composants d'Ansible. Utilisé principalement pour le développement et le test de contenu Ansible. |
| **Exemple**            | `ansible-test units` <br> Exécute des tests unitaires sur des modules ou des rôles. |

---
#### 10. **`ansible-lint`**

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `ansible-lint`          | Vérifie la syntaxe des playbooks et identifie les problèmes potentiels en se basant sur les meilleures pratiques Ansible. |
| **Exemple**            | `ansible-lint playbook.yml` <br> Analyse le fichier `playbook.yml` pour identifier les erreurs de syntaxe et les pratiques non recommandées. |

---


Pour plus de détails sur l'utilisation de ces commandes, consultez la [documentation officielle d'Ansible](https://docs.ansible.com/).


## Notions avancées Ansible

### Module personnalisé

### Role
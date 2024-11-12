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

`/~/my-ansible-project/`<br>
├── ansible.cfg        # Configuration locale du projet<br>
├── inventory          # Inventaire des hôtes du projet<br>
├── playbook.yml       # Playbook à exécuter<br>
└── roles/             # Dossier contenant des rôles (si nécessaire)<br>


- Le repertoire de travail par defaut de ansible est `/etc/ansible/` avec pour structure: 

`/etc/ansible/`<br>
├── ansible.cfg<br>
├── inventory<br>
├── playbook.yml<br>
└── roles/<br>

- ansible va t'il chercher toutes les configurations dans le fichier local en priorité sinon dans le dossier de travail par defaut qui est `/etc/ansible/` .



## Ansible - Principaux Modules

Ansible propose une vaste gamme de **modules** qui permettent d'automatiser diverses tâches sur les systèmes, réseaux, cloud, et plus encore. Ces modules permettent de gérer des serveurs, d'exécuter des commandes, de copier des fichiers, de gérer des utilisateurs, des packages, et bien plus.

Ci-dessous, vous trouverez une liste des modules principaux d'Ansible classés par catégories, avec une brève description de leurs fonctionnalités.

---

#### 1. **Modules système**
Ces modules permettent d'administrer et de gérer les configurations des systèmes d'exploitation.

# Ansible - Principaux Modules

Ansible offre une variété de modules qui permettent d'exécuter différentes tâches d'administration système, de gestion de configuration et d'automatisation. Voici une table récapitulant les modules les plus utilisés, avec une description de leurs usages.

| Module                | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| **`apt`**             | Gère les paquets sur les systèmes basés sur APT (Debian, Ubuntu). <br> **Exemple** : `apt: name=nginx state=present` (Installe le paquet `nginx`). |
| **`yum`**             | Gère les paquets sur les systèmes basés sur YUM (RedHat, CentOS). <br> **Exemple** : `yum: name=httpd state=latest` (Installe ou met à jour le paquet `httpd`). |
| **`service`**         | Gère les services sur les systèmes Linux (démarrer, arrêter, redémarrer un service). <br> **Exemple** : `service: name=nginx state=started` (Démarre le service `nginx`). |
| **`systemd`**         | Gère les services et les unités Systemd. <br> **Exemple** : `systemd: name=nginx state=started` (Démarre le service `nginx` avec Systemd). |
| **`user`**            | Gère les utilisateurs et les groupes système. <br> **Exemple** : `user: name=john state=present` (Crée un utilisateur nommé `john`). |
| **`group`**           | Gère les groupes système. <br> **Exemple** : `group: name=admin state=present` (Crée un groupe `admin`). |
| **`copy`**            | Copie des fichiers depuis l'hôte de contrôle vers les hôtes distants. <br> **Exemple** : `copy: src=/path/to/file dest=/path/to/destination` (Copie un fichier vers la destination spécifiée). |
| **`template`**        | Gère les fichiers de modèles avec des variables Jinja2. <br> **Exemple** : `template: src=template.j2 dest=/etc/config.conf` (Rend un fichier modèle avec des variables et le copie vers l'hôte distant). |
| **`shell`**           | Exécute des commandes shell sur les hôtes distants. <br> **Exemple** : `shell: echo "Hello World"` (Exécute une commande shell `echo`). |
| **`command`**         | Exécute une commande sur l'hôte distant (sans interprétation de shell). <br> **Exemple** : `command: /usr/bin/uptime` (Exécute la commande `uptime`). |
| **`file`**            | Gère les permissions et les propriétés des fichiers et répertoires. <br> **Exemple** : `file: path=/path/to/file mode=0644 state=touch` (Crée ou modifie un fichier avec les permissions spécifiées). |
| **`lineinfile`**      | Gère les lignes spécifiques dans un fichier texte. <br> **Exemple** : `lineinfile: path=/etc/hosts line="127.0.0.1 localhost"` (Ajoute une ligne dans le fichier `/etc/hosts`). |
| **`cron`**            | Gère les tâches planifiées via `cron`. <br> **Exemple** : `cron: name="Backup" minute="0" hour="2" job="/path/to/backup.sh"` (Ajoute une tâche planifiée qui exécute une sauvegarde). |
| **`git`**             | Gère les dépôts Git. <br> **Exemple** : `git: repo=https://github.com/repo.git dest=/path/to/dest version=master` (Clone un dépôt Git). |
| **`docker_container`**| Gère les conteneurs Docker (démarrer, arrêter, supprimer). <br> **Exemple** : `docker_container: name=webapp image=nginx state=started` (Lance un conteneur Nginx nommé `webapp`). |
| **`docker_image`**     | Gère les images Docker (télécharger, construire, supprimer). <br> **Exemple** : `docker_image: name=nginx source=pull` (Télécharge l'image Nginx depuis Docker Hub). |
| **`setup`**           | Récupère les faits (informations système) des hôtes. <br> **Exemple** : `setup:` (Collecte les informations système des hôtes distants). |
| **`debug`**           | Affiche des messages de débogage ou des informations dans un playbook. <br> **Exemple** : `debug: msg="Hello, World!"` (Affiche un message dans la sortie Ansible). |
| **`wait_for`**        | Attend qu'une condition soit remplie (par exemple, attendre qu'un port soit ouvert). <br> **Exemple** : `wait_for: port=80 timeout=300` (Attend que le port 80 soit accessible). |
| **`synchronize`**     | Synchronise des fichiers et des répertoires entre deux hôtes (basé sur `rsync`). <br> **Exemple** : `synchronize: src=/local/path dest=/remote/path` (Synchronise un répertoire). |
| **`stat`**            | Récupère des informations sur un fichier ou un répertoire. <br> **Exemple** : `stat: path=/path/to/file` (Vérifie si un fichier existe). |
| **`fetch`**           | Télécharge des fichiers depuis des hôtes distants vers l'hôte de contrôle. <br> **Exemple** : `fetch: src=/path/on/remote dest=/path/on/local` (Télécharge un fichier depuis l'hôte distant). |

---

Ces modules sont parmi les plus utilisés dans les playbooks Ansible, offrant une grande flexibilité pour la gestion des systèmes et des applications.


Pour une liste complète et à jour des modules, vous pouvez consulter la [documentation officielle d'Ansible](https://docs.ansible.com/ansible/latest/collections/index.html).


## Ansible - Principales Commandes

Ansible fournit une série de **commandes** qui permettent d'exécuter des tâches d'automatisation sur des systèmes distants, de gérer les configurations, et bien plus encore. Ces commandes sont au cœur de l'utilisation d'Ansible pour déployer, configurer, et administrer des systèmes.

Ci-dessous, vous trouverez une liste des commandes principales d'Ansible, avec une description de leur utilisation.

---

#### 1. **`ansible`**

# Ansible - Principales Commandes

Ansible propose plusieurs commandes pour exécuter des tâches d'automatisation, gérer les configurations, et bien plus. Cette table récapitule les commandes les plus courantes avec une description de leur usage.

| Commande               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| **`ansible`**           | Exécute des tâches Ad-hoc sur un ou plusieurs hôtes. Permet d'exécuter des modules sans utiliser de playbooks. <br> **Exemple** : `ansible all -m ping` (Vérifie la connectivité avec tous les hôtes définis dans l'inventaire). |
| **`ansible-playbook`**  | Exécute un playbook Ansible (fichier YAML contenant une série de tâches structurées). <br> **Exemple** : `ansible-playbook site.yml` (Lance un playbook nommé `site.yml`). |
| **`ansible-inventory`** | Gère et interroge l'inventaire des hôtes d'Ansible (permet de lister les hôtes ou les groupes d’hôtes). <br> **Exemple** : `ansible-inventory --list` (Affiche la liste des hôtes et des groupes). |
| **`ansible-galaxy`**    | Permet de télécharger, installer et gérer des rôles ou des collections depuis Ansible Galaxy ou d'autres sources. <br> **Exemple** : `ansible-galaxy install geerlingguy.apache` (Installe le rôle `apache` depuis Galaxy). |
| **`ansible-doc`**       | Affiche la documentation des modules Ansible directement dans le terminal. <br> **Exemple** : `ansible-doc apt` (Affiche la documentation du module `apt`). |
| **`ansible-vault`**     | Chiffre, déchiffre et gère des fichiers sensibles via Ansible Vault. <br> **Exemple** : `ansible-vault encrypt secrets.yml` (Chiffre un fichier `secrets.yml` pour le protéger). |
| **`ansible-config`**    | Affiche la configuration courante d'Ansible et permet de valider ou d'obtenir de l'aide sur les fichiers de configuration. <br> **Exemple** : `ansible-config view` (Affiche la configuration actuelle d'Ansible). |
| **`ansible-pull`**      | Exécute des playbooks en mode "pull" en clonant un dépôt Git et en exécutant les tâches à partir de celui-ci. <br> **Exemple** : `ansible-pull -U https://github.com/monrepo/playbook.git` (Exécute un playbook depuis un dépôt Git). |
| **`ansible-test`**      | Teste des rôles, modules, collections ou autres composants Ansible (principalement utilisé pour le développement). <br> **Exemple** : `ansible-test units` (Exécute des tests unitaires sur des modules ou des rôles). |
| **`ansible-lint`**      | Vérifie la syntaxe des playbooks et identifie les problèmes potentiels basés sur les bonnes pratiques Ansible. <br> **Exemple** : `ansible-lint playbook.yml` (Analyse un playbook pour détecter les erreurs). |

---

Ces commandes sont essentielles pour travailler avec Ansible. Elles couvrent l'exécution de tâches ad-hoc, l'exécution de playbooks, la gestion des inventaires, et plus encore.



Pour plus de détails sur l'utilisation de ces commandes, consultez la [documentation officielle d'Ansible](https://docs.ansible.com/).


## Playbook ansible

les différentes parties d'un playbook :
1. Hosts

Définit sur quels hôtes ou groupes d’hôtes les tâches seront exécutées. Vous pouvez utiliser un groupe d'hôtes défini dans le fichier d'inventaire, des noms spécifiques d'hôtes, ou encore all pour tous les hôtes.

2. Tasks

Une liste de tâches qui doivent être exécutées sur les hôtes spécifiés. Chaque tâche est une action spécifique (comme installer un package, copier un fichier, etc.). Chaque tâche doit utiliser un module Ansible.

3. Roles

Un moyen d'organiser les tâches dans des sous-répertoires (plus structuré et réutilisable). Les rôles contiennent des tâches, des handlers, des fichiers, etc., pour faciliter l'automatisation complexe.

4. Vars

Définit des variables qui peuvent être utilisées dans les tâches. Ces variables peuvent être définies directement dans le playbook ou récupérées d’un fichier externe.

5. Handlers

Similaire aux tâches, mais les handlers ne sont exécutés que lorsqu'ils sont déclenchés par une autre tâche via le mot-clé notify. Utilisé, par exemple, pour redémarrer un service après une modification de configuration.

6. Become

Permet d'exécuter des tâches avec des privilèges élevés (comme sudo). Cela est nécessaire pour certaines actions comme l'installation de paquets ou la modification de configurations système.

7. Environment

Définit les variables d'environnement spécifiques pour les tâches.


#### Exemple :

````yml
---
- name: Installation et configuration d'un serveur web
  hosts: webservers              # Spécification des hôtes sur lesquels exécuter le playbook
  become: yes                    # Prendre les privilèges root pour certaines tâches
  vars:                          # Variables définies dans le playbook
    apache_pkg: apache2
    document_root: /var/www/html

  roles:
    - common                     # Appel d'un rôle commun à tous les serveurs
    - webserver                  # Appel du rôle "webserver"

  tasks:                         # Liste des tâches pour les hôtes spécifiés
    - name: Installer Apache
      ansible.builtin.apt:        # Module apt pour gérer les packages
        name: "{{ apache_pkg }}"
        state: present
      notify:                     # Appel de la notification pour les handlers
        - Restart Apache

    - name: Créer le répertoire du document root
      ansible.builtin.file:       # Module file pour créer un répertoire
        path: "{{ document_root }}"
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'

    - name: Déployer la page d'accueil
      ansible.builtin.copy:       # Module copy pour copier un fichier sur les hôtes distants
        src: index.html
        dest: "{{ document_root }}/index.html"
        mode: '0644'

    - name: Vérifier si Apache fonctionne
      ansible.builtin.service_facts: # Collecter des informations sur les services
    - name: Assurer qu'Apache est actif
      ansible.builtin.systemd:
        name: "{{ apache_pkg }}"
        state: started
        enabled: yes

  handlers:                      # Handlers pour exécuter des actions conditionnelles
    - name: Restart Apache
      ansible.builtin.systemd:
        name: "{{ apache_pkg }}"
        state: restarted

  environment:                   # Variables d'environnement
    PATH: /usr/local/bin:/usr/bin:/bin

  pre_tasks:                     # Tâches à exécuter avant le bloc "tasks"
    - name: Mettre à jour le cache des paquets
      ansible.builtin.apt:
        update_cache: yes
      when: ansible_facts['os_family'] == "Debian"

  post_tasks:                    # Tâches à exécuter après le bloc "tasks"
    - name: Afficher un message de réussite
      ansible.builtin.debug:
        msg: "L'installation et la configuration d'Apache sont terminées."

  tags:                          # Tags pour filtrer les tâches à exécuter
    - webserver_setup
    - apache

  ignore_errors: yes             # Ignorer les erreurs lors de l'exécution de ce playbook

````

## Role
Un rôle dans Ansible est une manière de structurer vos playbooks de manière modulaire et réutilisable. Les rôles permettent de diviser vos tâches en plusieurs fichiers, en organisant la configuration par composant ou service. Cela facilite la gestion, la maintenance et le partage de configurations complexes.

### Structure d'un Rôle Ansible

Lorsqu'un rôle est créé dans Ansible, une structure de répertoires est utilisée pour organiser les différents éléments. Voici la structure typique d'un rôle Ansible :

```python
my_role/
├── defaults/
│   └── main.yml            # Variables par défaut
├── files/
│   └── ...                 # Fichiers à copier sur l'hôte
├── handlers/
│   └── main.yml            # Handlers (notamment pour redémarrer les services)
├── meta/
│   └── main.yml            # Métadonnées du rôle (dépendances, etc.)
├── tasks/
│   └── main.yml            # Liste des tâches principales
├── templates/
│   └── ...                 # Templates Jinja2 à déployer
├── tests/
│   └── ...                 # Playbooks de tests pour le rôle
├── vars/
│   └── main.yml            # Variables spécifiques au rôle
└── README.md               # Documentation du rôle
```

### Description des éléments d'un rôle

- defaults/main.yml : Contient les variables par défaut du rôle. Ces variables peuvent être redéfinies à différents niveaux (inventaire, ligne de commande, etc.).

- files/ : Contient des fichiers statiques que vous souhaitez copier vers les hôtes. Par exemple, des fichiers de configuration ou des binaires.

- handlers/main.yml : Contient des handlers, qui sont des actions déclenchées par d'autres tâches (comme redémarrer un service après avoir modifié un fichier de configuration).

- meta/main.yml : Contient des informations sur le rôle, comme les dépendances (autres rôles dont celui-ci pourrait dépendre).

- tasks/main.yml : Le fichier le plus important, il contient la liste des tâches que le rôle exécutera.

- templates/ : Contient des templates Jinja2 qui peuvent être utilisés pour générer des fichiers de configuration ou autres fichiers dynamiques.

- vars/main.yml : Fichier où vous pouvez définir des variables spécifiques au rôle (variables qui ne changent pas souvent, contrairement à celles dans defaults).

- tests/ : Permet de définir des tests pour vérifier que le rôle fonctionne comme prévu.

### Exemple de rôle : Installation d'Apache 2

Créons un exemple de rôle pour installer Apache 2 sur un serveur Linux.
- Étape 1 : Créer la structure du rôle

Commencez par créer un rôle avec la commande suivante :

```bash
ansible-galaxy init apache_install
```

- Étape 2 : Configurer les tâches d'installation d'Apache

Dans le fichier tasks/main.yml, nous allons définir les tâches pour installer Apache 2.

```yml
# apache_install/tasks/main.yml
---
# Installer le paquet Apache 2
- name: Installer Apache 2
  apt:
    name: apache2
    state: present
    update_cache: yes

# Démarrer et activer le service Apache
- name: Démarrer Apache et activer au démarrage
  systemd:
    name: apache2
    state: started
    enabled: yes

# Copier un fichier index.html personnalisé (si nécessaire)
- name: Copier la page d'accueil
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
  notify:
    - Redémarrer Apache
```

- Étape 3 : Configurer les handlers

Le handler est utilisé pour redémarrer Apache si nécessaire (par exemple, après la modification de fichiers).

```yml
# apache_install/handlers/main.yml
---
# Handler pour redémarrer Apache
- name: Redémarrer Apache
  systemd:
    name: apache2
    state: restarted
```

- Étape 4 : Définir une page d'accueil personnalisée avec un template (definition des fichiers statiques du role)

Dans le dossier templates/, nous allons créer un fichier index.html.j2 qui servira de page d'accueil personnalisée.

```html
<!-- apache_install/templates/index.html.j2 -->
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Bienvenue sur Apache 2</title>
</head>
<body>
    <h1>{{ ansible_hostname }} est opérationnel !</h1>
    <p>Apache est installé et fonctionne correctement sur cette machine.</p>
</body>
</html>
```
- Étape 5 : Variables par défaut

Dans le fichier defaults/main.yml, vous pouvez définir des variables par défaut, comme le port Apache, des chemins ...

```yml
# apache_install/defaults/main.yml
---
apache_port: 80

```

Étape 6 : Lancer le rôle dans un playbook

Enfin, dans votre playbook, vous pouvez appeler ce rôle comme ceci :
```yml
# site.yml
---
- hosts: webservers
  become: yes
  roles:
    - apache_install
```

Étape 7 : Exécuter le playbook

Pour exécuter le rôle sur un serveur, lancez simplement :

```bash
ansible-playbook site.yml -i hosts
```

## Variable Dans ansible


## Module personnalisé
# Introduction aux Notions Systèmes Linux

## Notions Importantes

### Console vs Terminal vs Shell

- **Console** : Interface native d'interaction avec le système d'exploitation, fournie par l'OS en local.
- **Terminal** : Interface permettant d'interagir avec l'OS, émulée par des applications comme Terminator.
- **Shell** : Interpréteur de commande utilisé dans le terminal pour exécuter des commandes.

### Types de Fichiers sous Linux

- **Fichier standard (-)** : Contenu ordinaire comme texte, binaire, script, etc.
- **Répertoire (d)** : Contient des fichiers et d'autres répertoires.
- **Lien symbolique (l)** : Raccourci pointant vers un autre fichier ou dossier.
- **Fichier périphérique bloc (b)** : Représente des périphériques comme les disques.
- **Fichier périphérique caractère (c)** : Périphérique en lecture/écriture caractère par caractère (ex. terminal).
- **Fichier de socket (s)** : Point de communication pour l’échange de données entre processus.
- **Tube nommé FIFO (p)** : Canal de communication unidirectionnel entre processus.
- **Lien physique (hard link)** : Pointeur supplémentaire vers un fichier existant.

---

## Système de Fichiers

### Structure des Répertoires

- **/boot** : Fichiers nécessaires au démarrage du système (ex. noyau Linux, chargeur d’amorçage).
- **/lib** : Bibliothèques partagées essentielles pour les exécutables de /bin et /sbin.
- **/bin** : Commandes système de base accessibles à tous, même en mode de secours.
- **/sbin** : Commandes système réservées à l’administration (souvent root).
- **/dev** : Fichiers représentant les périphériques (disques, terminaux, ports, etc.).
- **/etc** : Fichiers de configuration du système et des services.
- **/var** : Données variables (logs, mails, caches, spool).
- **/opt** : Applications tierces installées manuellement.
- **/usr** : Logiciels et données non critiques installés par le gestionnaire de paquets.

---

## Gestion des Paquets et Dépendances

### Formats de Paquets

- **Archive (.tar)** : Ensemble de fichiers regroupés dans un seul fichier sans compression.
- **Zip (.gz/.tar.gz)** : Archive compressée.
- **Paquet (.deb)** : Archive contenant un logiciel distribuable et installable.
  - **.deb** contient :
    - `control.tar.gz` : Métadonnées (nom, version, dépendances, description).
    - `data.tar.gz` : Fichiers à installer sur le système.
    - `debian-binary` : Version du format Debian.

### Gestionnaire de Paquets et Dépendances

- **dpkg** : Installe un paquet sans gérer ses dépendances.
- **apt** : Installe un paquet et ses dépendances.

### Dépôts

- **Dépôt officiel (/etc/apt/sources.list)** : Maintenu par la distribution elle-même (ex. Ubuntu).
- **Dépôt tiers (/etc/apt/sources.d)** : Maintenu par une autre organisation ou développeur.
- **PPA (Personal Package Archive)** : Dépôt spécifique à Ubuntu, souvent hébergé sur Launchpad.net.

---

## Gestion des Services avec Systemd

### Système d'Init et Gestion des Services

- **systemd** : Orchestration du démarrage du système, gestion des cycles de vie et des ressources des processus.
- Chaque service a un fichier de configuration dans `/etc/systemd/system/`, définissant :
  - Chemin du binaire/exécutable.
  - Définition des limitations de ressources.
  
### Composants de systemd

- **journald** : Centralisation et gestion des logs système.
- **networkd** : Gestion des interfaces réseau (configurations IP, routage, VLAN, tunnels, etc.).
- **logind** : Gestion des sessions utilisateurs, des connexions, et des actions d'alimentation.

---

## Cgroups (Control Groups)

Les **Cgroups** sont des mécanismes du noyau permettant d'isoler, prioriser, limiter et surveiller l’utilisation des ressources (RAM, CPU, réseau, périphériques). Chaque cgroup est un dossier situé dans `/sys/fs/cgroup/`.

Exemples de fichiers de configuration dans un cgroup :
- `cfs_quota_us` : Limite le temps CPU.
- `memory.limit_in_bytes` : Limite de la mémoire.
- `net_cls.classid` : Classe de réseau affectée au cgroup.
- `devices.list`, `devices.allow`, `devices.deny` : Liste des périphériques autorisés/forbidden.


## Configuration Reseaux Linux

---

### 🔧 Qu’est-ce que `network-scripts` ?

**`network-scripts`** est un ensemble de scripts shell utilisés par les anciennes versions de **Red Hat** et ses dérivés (CentOS, Oracle Linux, etc.) pour **configurer le réseau**.

- Il repose sur des **fichiers de configuration `ifcfg-*`** situés dans un répertoire spécifique.
- Ces scripts sont **interprétés par le service `network`**, ou parfois par `NetworkManager` si configuré.
- Ce système est désormais **obsolète dans RHEL 9**, remplacé totalement par **NetworkManager**.

---

#### 📁 Fichiers de configuration

- Les fichiers sont stockés dans `/etc/sysconfig/network-scripts/`

- Par exemple : `ifcfg-eth0`, `ifcfg-enp0s3`

- Voici un exemple de configuration avec une **adresse IP statique** :

```ini
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=1.1.1.1
```

---

### 🔧 Qu’est-ce que NetworkManager ?

**NetworkManager** est un **gestionnaire de réseau dynamique** utilisé dans la plupart des distributions Linux modernes (RHEL, CentOS, Fedora, Ubuntu, Debian...).

- Il permet de **gérer automatiquement** les connexions réseau (filaire, Wi-Fi, VPN, etc.).
- Il **remplace les anciens scripts `network-scripts`** sur RHEL/CentOS depuis la version 8.
- Il peut être **utilisé en ligne de commande (`nmcli`), via l'interface graphique ou avec des fichiers de configuration**.

---

#### 📁 Fichiers de configuration

- Exemple de fichier `/etc/NetworkManager/system-connections/static-eth0.nmconnection` :

```ini
[connection]
id=static-eth0
type=ethernet
interface-name=eth0
autoconnect=true

[ipv4]
method=manual
addresses=192.168.1.100/24;192.168.1.1;
dns=8.8.8.8;1.1.1.1;
ignore-auto-dns=true

[ipv6]
method=ignore
```



### 🔧 Qu’est-ce que Netplan ?

**Netplan** est un outil d’abstraction de la configuration réseau introduit par **Ubuntu depuis la version 17.10**.

* Il permet de **décrire la configuration réseau dans un fichier YAML**.
* Il **génère automatiquement la configuration** pour le backend (renderer) réseau choisi : `NetworkManager` ou `systemd-networkd`.
* Il se situe **entre l’administrateur et les gestionnaires bas-niveau**, pour unifier la gestion réseau.

---

## 📁 Fichier de configuration Netplan

Les fichiers de configuration Netplan sont situés dans :

```
/etc/netplan/
```

Les fichiers doivent avoir une **extension `.yaml`**. Exemples : `01-netcfg.yaml`, `50-cloud-init.yaml`

---

## 🧱 Structure d’un fichier Netplan

Exemple simple (IP statique) avec renderer `networkd` :

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

### 🧹 Explication ligne par ligne

| Clé            | Rôle                                                |
| -------------- | --------------------------------------------------- |
| `network:`     | Racine de la configuration réseau                   |
| `version: 2`   | Version du format Netplan (actuellement toujours 2) |
| `renderer:`    | Backend utilisé : `networkd` ou `NetworkManager`    |
| `ethernets:`   | Déclaration des interfaces Ethernet                 |
| `enp0s3:`      | Nom de l’interface à configurer                     |
| `dhcp4:`       | Activer (yes) ou désactiver (no) le DHCP pour IPv4  |
| `addresses:`   | Adresse IP statique (CIDR)                          |
| `gateway4:`    | Adresse de la passerelle IPv4                       |
| `nameservers:` | Adresses DNS                                        |

---

## ⚙️ Les Renderers : `networkd` vs `NetworkManager`

| Renderer           | Description                                                       | Utilisation typique                   |
| ------------------ | ----------------------------------------------------------------- | ------------------------------------- |
| **networkd**       | Géré par **`systemd-networkd`**, léger et idéal pour les serveurs | Ubuntu Server, cloud-init, conteneurs |
| **NetworkManager** | Gère les connexions complexes (Wi-Fi, VPN, etc.) avec GUI         | Ubuntu Desktop, laptops               |

### 🔴 Choix du renderer

Il dépend du système :

* Ubuntu Server → `networkd`
* Ubuntu Desktop → `NetworkManager`

> 💡 Certains fichiers peuvent contenir plusieurs interfaces avec des renderers différents.

---

## 📘 Autres exemples

### 1. **DHCP automatique**

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: true
```

### 2. **Configurer une interface Wi-Fi (NetworkManager requis)**

```yaml
network:
  version: 2
  renderer: NetworkManager
  wifis:
    wlan0:
      dhcp4: true
      access-points:
        "NomDuRéseau":
          password: "motdepasse"
```

---

## 🔄 Appliquer la configuration Netplan

Après modification du fichier :

```bash
sudo netplan apply
```

⚠️ Pour tester sans l’appliquer définitivement :

```bash
sudo netplan try
```

> Reviendra à la configuration précédente si la connexion échoue dans les 120 secondes.

---

## 📂 Dossier généré par Netplan

Après `netplan apply`, les configurations sont **traduites** et envoyées vers :

* `/run/systemd/network/` si `networkd` est utilisé
* `/etc/NetworkManager/system-connections/` si `NetworkManager` est utilisé

---

## 🛠️ Outils utiles pour déboguer

* `ip a` → Voir les interfaces et adresses IP
* `netplan try` → Tester la conf temporairement
* `netplan generate` → Générer les fichiers sans les appliquer
* `journalctl -u systemd-networkd` → Logs de systemd-networkd
* `nmcli` → Outil CLI pour NetworkManager

---


## 🔥 Pare-feu sous Linux : de `iptables` à `ufw`

### 🧱 `iptables` (bas niveau)

#### Qu’est-ce que c’est ?

`iptables` est un outil en ligne de commande pour gérer le pare-feu **netfilter** (un framework du noyau Linux pour filtrer les paquets TCP/IP) du noyau Linux et le routage des paquets avec la NAT (traduction d’adresses réseau)

#### Les tables d'iptables

`iptables` dispose de 5 tables principales pour gérer différentes facettes du trafic réseau :

- **filter** : Pare-feu (géré par `ufw` pour autoriser/filtrer les paquets)
- **nat** : Traduction d’adresses (parfois géré par `ufw` pour le NAT et le redirectionnement)
- **mangle** : Modification des paquets (non géré par `ufw`)
- **raw** : Bypass du suivi des connexions (non géré par `ufw`)
- **security** : Politiques SELinux (non géré par `ufw`)

🛡️ **ufw** (surcouche à `iptables`) gère principalement la table `filter`, permettant de faciliter la gestion du pare-feu et du trafic entrant/sortant.


#### Fonctionnement :

Il agit sur des **tables** composées de **chaînes** (*chains*) et de **règles** (*rules*) qui définissent quoi faire avec les paquets réseau : `ACCEPT`, `DROP`, `REJECT`, etc.

#### Exemple simple :

```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

Cette règle autorise les connexions SSH entrantes (port 22).

#### Limite :

* Syntaxe complexe
* Peu intuitive, surtout pour les débutants

### Les

---

### 🔄 `ufw` (Uncomplicated Firewall)

#### Qu’est-ce que c’est ?

`ufw` est une interface **simplifiée** pour gérer `iptables`, principalement utilisée sur **Ubuntu**.

#### Avantages :

* Syntaxe claire et facile à utiliser
* Bonne abstraction pour les configurations simples
* Activé automatiquement sur certaines distributions Ubuntu Server

#### Exemples courants :

```bash
ufw enable                # Active le pare-feu
ufw allow 22/tcp          # Autorise SSH
ufw deny 80               # Bloque le port HTTP
ufw status verbose        # Affiche les règles en cours
```

#### Important :

* `ufw` **ne remplace pas** `iptables` : il le **contrôle** en arrière-plan
* Ne pas **mélanger** configuration `iptables` et `ufw` simultanément (risque de conflits)
* Sous Redhat `ufw` --> `firewalld`

--- 


## Commande Linux


### 🔐 **Gestion des utilisateurs :**

| Commande  | Description                                                        |
| --------- | ------------------------------------------------------------------ |
| `useradd` | Crée un nouvel utilisateur.                                        |
| `usermod` | Modifie un utilisateur existant.                                   |
| `userdel` | Supprime un utilisateur du système.                                |
| `passwd`  | Définit ou change le mot de passe d’un utilisateur.                |
| `id`      | Affiche l’UID, GID et les groupes d’un utilisateur.                |
| `whoami`  | Affiche le nom de l’utilisateur courant.                           |
| `who`     | Liste les utilisateurs connectés.                                  |
| `w`       | Montre qui est connecté et ce qu’ils font.                         |
| `login`   | Lance une session utilisateur (nécessite souvent des droits root). |

---

### 👥 **Gestion des groupes :**

| Commande   | Description                                                      |
| ---------- | ---------------------------------------------------------------- |
| `groupadd` | Crée un nouveau groupe.                                          |
| `groupmod` | Modifie un groupe existant.                                      |
| `groupdel` | Supprime un groupe.                                              |
| `groups`   | Affiche les groupes d’un utilisateur.                            |
| `gpasswd`  | Gère les membres d’un groupe (ajout, suppression, mot de passe). |

---

### 🔒 **Gestion des permissions :**

| Commande | Description                                                         |
| -------- | ------------------------------------------------------------------- |
| `chmod`  | Change les permissions d’un fichier ou dossier.                     |
| `chown`  | Change le propriétaire et/ou le groupe d’un fichier.                |
| `chgrp`  | Change uniquement le groupe d’un fichier.                           |
| `umask`  | Définit les permissions par défaut lors de la création de fichiers. |
| `ls -l`  | Affiche les permissions des fichiers de façon détaillée.            |

---

### 🌍 **Gestion des variables d'environnement :**

| Commande   | Description                                                                 |
| ---------- | --------------------------------------------------------------------------- |
| `export`   | Définit une variable d’environnement disponible pour les processus enfants. |
| `env`      | Affiche l’environnement complet.                                            |
| `printenv` | Affiche la valeur d’une variable d’environnement.                           |
| `set`      | Affiche les variables d’environnement et shell.                             |
| `unset`    | Supprime une variable d’environnement.                                      |

---

### 🗓 **Manipulation de la date :**

| Commande      | Description                                                         |
| ------------- | ------------------------------------------------------------------- |
| `date`        | Affiche ou modifie la date et l’heure système.                      |
| `timedatectl` | Gère l’heure, la date, le fuseau horaire et la synchronisation NTP. |
| `hwclock`     | Lit ou écrit l’horloge matérielle (BIOS).                           |

---

### 🔍 **Commandes de recherche :**

| Commande  | Description                                                          |
| --------- | -------------------------------------------------------------------- |
| `find`    | Recherche de fichiers selon critères (nom, taille, date…).           |
| `locate`  | Recherche rapide à partir d’une base indexée (nécessite `updatedb`). |
| `which`   | Trouve le chemin d’une commande dans le `PATH`.                      |
| `whereis` | Trouve les fichiers binaires, sources et manuels d’une commande.     |
| `grep`    | Recherche un motif dans un fichier ou un flux.                       |

---

### ⚙️ **Gestion des services :**

| Commande     | Description                                                                 |
| ------------ | --------------------------------------------------------------------------- |
| `systemctl`  | Gère les services (`start`, `stop`, `enable`, `status`…).                   |
| `service`    | Ancienne interface pour gérer les services (wrapper autour de `systemctl`). |
| `journalctl` | Affiche les logs système de `systemd` (journal système).                    |

---

### ⚖️ **Gestion des processus :**

| Commande  | Description                                                     |
| --------- | --------------------------------------------------------------- |
| `ps`      | Affiche les processus en cours.                                 |
| `top`     | Affiche en temps réel les processus, consommation CPU/mémoire.  |
| `htop`    | Version améliorée et interactive de `top`.                      |
| `kill`    | Envoie un signal à un processus (par exemple pour le terminer). |
| `killall` | Termine tous les processus ayant un certain nom.                |
| `nice`    | Lance un processus avec une priorité donnée.                    |
| `renice`  | Modifie la priorité d’un processus déjà lancé.                  |

---

### 📊 **Gestion des ressources (RAM, CPU, disque) :**

| Commande       | Description                                                        |
| -------------- | ------------------------------------------------------------------ |
| `free`         | Affiche la mémoire utilisée et disponible.                         |
| `vmstat`       | Statistiques mémoire, swap, CPU…                                   |
| `iostat`       | Statistiques d’entrées/sorties disque.                             |
| `iotop`        | Affiche les processus les plus consommateurs d’I/O.                |
| `df`           | Affiche l’espace disque utilisé par les systèmes de fichiers.      |
| `du`           | Affiche l’espace utilisé par les fichiers/répertoires.             |
| `uptime`       | Affiche le temps depuis le dernier démarrage et la charge système. |
| `top` / `htop` | Également utiles pour surveiller l’usage CPU/RAM en direct.        |


---

## Logs et Monitoring

| Commande     | Description                                                                 |
| ------------ | --------------------------------------------------------------------------- |
| `journalctl` | Affiche les journaux système collectés par `systemd-journald`, avec filtres possibles (par service, unité, date, etc.). |
| `dmesg`      | Affiche les messages du noyau (buffer de démarrage, périphériques détectés, erreurs matériel). |
| `top`        | Affiche en temps réel les processus en cours, leur consommation CPU, mémoire. |
| `htop`       | Version interactive et améliorée de `top`, avec navigation au clavier, tri, et couleurs. |
| `iotop`      | Affiche la consommation d’entrées/sorties disque par processus, en temps réel. |
| `vmstat`     | Affiche des statistiques sur la mémoire, le swap, le CPU, les processus, les IO, etc. |
| `iostat`     | Donne les statistiques d’utilisation CPU et des entrées/sorties des périphériques de stockage. |
| `netstat`    | Affiche les connexions réseau, les tables de routage, les statistiques d’interface (désuet, remplacé par `ss`). |
| `ss`         | Affiche les connexions réseau actives (plus rapide et plus moderne que `netstat`). |

---

## Réseau et Connectivité

| Commande     | Description                                                                 |
| ------------ | --------------------------------------------------------------------------- |
| `ip`         | Outil moderne de gestion des interfaces réseau, des routes, des adresses IP, etc. (remplace `ifconfig` et `route`). |
| `ifconfig`   | Ancien outil de configuration des interfaces réseau (obsolète sur de nombreuses distributions récentes). |
| `ping`       | Vérifie la connectivité réseau avec une machine distante via ICMP (envoie des paquets et mesure le temps de réponse). |
| `traceroute` | Affiche le chemin (les routeurs intermédiaires) emprunté par les paquets pour atteindre une destination. |
| `dig`        | Interroge les serveurs DNS pour obtenir des informations sur un nom de domaine (détaillé et puissant). |
| `nslookup`   | Interroge les serveurs DNS, plus simple que `dig`, mais moins flexible. |
| `netplan`    | Utilitaire de configuration réseau basé sur YAML utilisé dans Ubuntu pour gérer les interfaces réseau. |
| `nmcli`      | Interface en ligne de commande pour NetworkManager, permet de gérer les connexions réseau (wifi, ethernet, VPN...). |

---

## Archivage, Sauvegarde et Transfert

| Commande     | Description                                                                 |
| ------------ | --------------------------------------------------------------------------- |
| `tar`        | Utilitaire d’archivage qui permet de regrouper plusieurs fichiers en une seule archive `.tar` (souvent combiné avec `gzip` ou `bzip2`). |
| `zip`        | Compresse un ou plusieurs fichiers dans une archive `.zip`, avec ou sans mot de passe. |
| `rsync`      | Synchronise des fichiers et des répertoires localement ou à distance avec détection des différences (rapide et efficace). |
| `scp`        | Copie sécurisée de fichiers entre machines via SSH (simple, mais sans reprise en cas de coupure). |
| `sftp`       | Client FTP sécurisé via SSH, permet de transférer des fichiers avec des commandes interactives. |
| `dd`         | Fait une copie brute de blocs de données (disques, partitions, ISO…), souvent utilisé pour créer ou restaurer des images. |
| `cpio`       | Utilitaire d’archivage utilisé pour empaqueter et extraire des fichiers, souvent dans les systèmes `initramfs`. |
| `rclone`     | Outil de synchronisation de fichiers avec des services cloud (Google Drive, S3, Dropbox, etc.). |

---

## Sécurité et Authentification

| Commande     | Description                                                                 |
| ------------ | --------------------------------------------------------------------------- |
| `sudo`       | Exécute une commande avec les privilèges d’un autre utilisateur (par défaut root), tout en conservant les journaux d’audit. |
| `su`         | Change d’utilisateur ou devient root (nouvelle session shell sous l'identité cible). |
| `passwd`     | Modifie le mot de passe de l’utilisateur actuel ou d’un autre utilisateur (si root). |
| `ssh`        | Client SSH permettant de se connecter à un autre système de manière sécurisée via le réseau. |
| `sshd`       | Le démon SSH qui écoute les connexions entrantes (`/usr/sbin/sshd`), fournit l'accès distant sécurisé. |
| `fail2ban`   | Analyse les journaux pour bannir automatiquement les adresses IP en cas de comportements suspects (ex : tentatives de connexion SSH échouées). |
| `ufw`        | Interface simplifiée pour gérer `iptables`, utilisée pour configurer un pare-feu facilement sur Ubuntu. |
| `iptables`   | Outil avancé de configuration de pare-feu en ligne de commande basé sur le noyau Linux (règles de filtrage des paquets). |
| `auditctl`   | Utilitaire pour gérer les règles d'audit du noyau (surveillance des accès aux fichiers, exécutions, etc.). |
| `semanage`   | Commande utilisée avec SELinux pour gérer les politiques de sécurité (contextes, ports, etc.). |

---

## Gestion des Cron

| Commande       | Description                                                                |
| -------------- | -------------------------------------------------------------------------- |
| `crontab`      | Gère les tâches cron (édition, suppression, affichage des tâches programmées). |
| `cron`         | Service qui exécute les tâches cron programmées.                           |
| `crontab -e`   | Édite la table des tâches cron de l'utilisateur courant.                   |
| `crontab -l`   | Affiche les tâches cron programmées pour l'utilisateur courant.           |
| `crontab -r`   | Supprime les tâches cron programmées de l'utilisateur courant.            |

---


## Gestion de Flux de donnée

| Commande   | Description                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------- |
| `cat`      | Affiche le contenu d’un ou plusieurs fichiers (ou flux) sur la sortie standard.                   |
| `tac`      | Comme `cat` mais affiche les lignes en ordre inverse (bottom to top).                             |
| `head`     | Affiche les premières lignes d’un fichier ou d’un flux (par défaut 10).                           |
| `tail`     | Affiche les dernières lignes d’un fichier (peut suivre en temps réel avec `-f`).                  |
| `more`     | Affiche le contenu d’un fichier page par page.                                                    |
| `less`     | Pareil que `more`, mais plus interactif (navigation avant/arrière, recherche).                    |
| `cut`      | Coupe et extrait des colonnes ou champs de texte (par caractère ou délimiteur).                   |
| `awk`      | Langage de traitement de texte puissant, utilisé pour filtrer, transformer ou agréger des lignes. |
| `sed`      | Stream editor : permet de faire des recherches/remplacements et d’éditer en flux.                 |
| `tr`       | Traduit ou supprime des caractères (ex : majuscules en minuscules).                               |
| `sort`     | Trie les lignes d’un fichier ou flux (par ordre alphabétique, numérique, etc.).                   |
| `uniq`     | Supprime les lignes dupliquées consécutives (souvent après un `sort`).                            |
| `wc`       | Compte les mots, lignes, caractères ou octets d’un fichier ou d’un flux.                          |
| `diff`     | Compare deux fichiers ligne par ligne et affiche les différences.                                 |
| `cmp`      | Compare deux fichiers octet par octet (silencieux si identiques).                                 |
| `tee`      | Réplique un flux en sortie standard **et** dans un fichier.                                       |
| `xargs`    | Construit et exécute des commandes à partir d’un flux de données ou d’un fichier.                 |
| `split`    | Divise un fichier en plusieurs fichiers plus petits.                                              |
| `paste`    | Fusionne les lignes de plusieurs fichiers côte à côte (colonne par colonne).                      |
| `join`     | Joint deux fichiers sur une colonne commune (comme un "JOIN" SQL).                                |
| `nl`       | Numérote les lignes d’un fichier.                                                                 |
| `yes`      | Génère une chaîne répétée infiniment (utile pour automatiser une saisie).                         |
| `printf`   | Affiche du texte formaté (plus contrôlable que `echo`).                                           |
| `echo`     | Affiche une chaîne sur la sortie standard.                                                        |
| `rev`      | Inverse les caractères de chaque ligne d’un fichier.                                              |
| `grep`     | Recherche des motifs dans un fichier ou un flux, affiche les lignes correspondantes.              |
| `egrep`    | Version améliorée de `grep` supportant les expressions régulières étendues.                       |
| `fgrep`    | Version de `grep` qui ne traite pas les expressions régulières (littéral uniquement).             |
| `comm`     | Compare deux fichiers triés et affiche les lignes communes ou distinctes.                         |
| `strings`  | Extrait les chaînes imprimables contenues dans un fichier binaire.                                |
| `fold`     | Coupe les lignes longues à une certaine largeur (utile pour formater).                            |
| `fmt`      | Reformate des paragraphes pour respecter une largeur de ligne donnée.                             |
| `iconv`    | Convertit l’encodage d’un fichier texte (ex : UTF-8 vers ISO-8859-1).                             |
| `file`     | Détermine le type d’un fichier (texte, binaire, image, etc.).                                     |
| `stat`     | Donne des infos détaillées sur un fichier (taille, dates, permissions, etc.).                     |
| `basename` | Extrait le nom de fichier d’un chemin complet.                                                    |
| `dirname`  | Extrait le répertoire d’un chemin de fichier.                                                     |



## 🌍 Command Reseaux et Sécurité

### 📌 Commandes `ip`

| Commande                    | Description                                                                |
|----------------------------|-----------------------------------------------------------------------------|
| `ip a` ou `ip addr`        | Affiche les adresses IP de toutes les interfaces                            |
| `ip addr show dev eth0`    | Affiche les adresses IP de l'interface `eth0`                               |
| `ip addr add 192.168.1.10/24 dev eth0` | Ajoute une adresse IP à une interface                           |
| `ip addr del 192.168.1.10/24 dev eth0` | Supprime une adresse IP d'une interface                         |

### 🔗 Commandes `ip link`

| Commande                          | Description                                                          |
|----------------------------------|-----------------------------------------------------------------------|
| `ip link`                        | Liste les interfaces réseau                                           |
| `ip link show`                   | Affiche les informations détaillées des interfaces                    |
| `ip link set eth0 up`            | Active l'interface `eth0`                                             |
| `ip link set eth0 down`          | Désactive l'interface `eth0`                                          |
| `ip link set dev eth0 mtu 1400`  | Change la taille MTU de l'interface `eth0`                            |
| `ip link set dev eth0 promisc on`| Active le mode promiscuité (sniffing)                                 |

### 🛣️ Commandes `ip route`

| Commande                           | Description                                                          |
|-----------------------------------|-----------------------------------------------------------------------|
| `ip route`                        | Affiche la table de routage                                           |
| `ip route add default via 192.168.1.1` | Définit une passerelle par défaut                             |
| `ip route add 10.0.0.0/24 via 192.168.1.254` | Ajoute une route spécifique                                |
| `ip route del default`            | Supprime la route par défaut                                          |
| `ip route flush dev eth0`         | Vide toutes les routes associées à l’interface `eth0`                 |

---

### ⚙️ Commandes `netplan` et `dhclient`

| Commande                        | Description                                                          |
|--------------------------------|-----------------------------------------------------------------------|
| `netplan apply`                | Applique les modifications des fichiers YAML                          |
| `netplan try`                  | Applique temporairement (revert si problème dans 120s)                |
| `netplan generate`             | Génère les fichiers pour le renderer depuis les fichiers YAML         |
| `netplan info`                 | Affiche les informations de configuration netplan                     |
| `dhclient`                     | Demande une adresse IP via DHCP pour toutes les interfaces            |
| `dhclient etho`                | Demande une adresse IP via DHCP pour eth0                             |
| `dhclient -r etho`             | Libère l'adresse IP actuelle de l'interface eth0                      |



### ⚙️ Commandes  de gestion des connexion `netstats` and `ss` 

| Commande   | Description                                                                  |
|------------|------------------------------------------------------------------------------|
| `netstat` & `ss`  |  -t : TCP                                                             |
|                   |  -u : UDP                                                             |
|                   |  -l : listening (écoute uniquement)                                   |
|                   |  -n : adresses et ports numériques (pas de résolution DNS)            |



### 🔥 Commandes de gestion du parfeu UFW

| Commande                                                   | Description                                                                 |
|------------------------------------------------------------|-----------------------------------------------------------------------------|
| `sudo ufw enable`                                          | Active le pare-feu                                                          |
| `sudo ufw disable`                                         | Désactive le pare-feu                                                       |
| `sudo ufw status`                                          | Affiche l’état du pare-feu (actif/inactif)                                  |
| `sudo ufw status verbose`                                  | Affiche les règles actives de manière détaillée                             |
| `sudo ufw allow (in/out) <port>`                           | Autorise un port (ex : `sudo ufw allow 22`)  par defaut le sens est `in`    |
| `sudo ufw allow <port>/<protocole>`                        | Autorise un port en précisant TCP ou UDP (ex : `sudo ufw allow 80/tcp`)     |
| `sudo ufw allow from <IP>`                                 | Autorise une IP spécifique (ex : `sudo ufw allow from 192.168.1.100`)       |
| `sudo ufw allow from <IP> to any port <port>`              | Autorise une IP sur un port précis (ex : `sudo ufw allow from 10.0.0.5 to any port 22`) |
| `sudo ufw deny <port>`                                     | Bloque un port (ex : `sudo ufw deny 80`)                                    |
| `sudo ufw delete allow <port>`                             | Supprime une règle autorisant un port                                       |
| `sudo ufw reset`                                           | Réinitialise toutes les règles UFW                                          |
| `sudo ufw default deny incoming`                           | Refuse toutes les connexions entrantes par défaut                           |
| `sudo ufw default allow outgoing`                          | Autorise toutes les connexions sortantes par défaut                         |
| `sudo ufw app list`                                        | Liste les profils d’application supportés par UFW                           |
| `sudo ufw allow <nom_app>`                                 | Autorise une application (ex : `sudo ufw allow "OpenSSH"`)                  |
| `sudo iptables -L -v -n`                                   | Afficher les regles de iptable avec les regles(L) detaillée(-v) en num (-n) |
| `sudo iptables -L -v -n -t nat`                            | Afficher la table de nat 
| `sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT`       | ACCEPTER les paquets entrante (IN) pour un port from all remote ip          |
| `sudo iptables -A INPUT -p tcp --dport 80 -j DROP`         | DROPER les paquets entrants pour un port from all remote ip                 |
| `sudo iptables -A INPUT -p tcp --dport 80 -j DENIED`       | DENIED les paquets entrants pour un port from all remote ip                 |
| `sudo iptables -A INPUT -p tcp --dport 80 -s 192.1.1.1 -j DENIED`       | DENIED les paquets entrants pour un port from a given ipadres  |





## PROGRAMMATION BASH


### Variable

#### Les variables standard

<span style="color:blue">Declaration de variable de typée dynamiquement</span>

- chaine='ma chaine brute sans variable'
- chaine="ma chaine avec des $variables"
- variable=`ls -al`  # variable contenat qui va contenir retour d'une commande
- variable=25        # variable contenant un entier

<span style="color:blue">Declaration de variable de controlée avec `declare`</span>

- declare -r readOnlyVariable=value   <<>> readonly readOnlyVariable=value
- declare -i ingeterVariable=value
- declare -a tableVariable=(value1, value2 value3 value4)
- declare -A associatifTable=([key1]="value1" [key2]="value2" [key3]="value3")

<span style="color:blue">Substition et indirection</span>

- sustition : variable=$(command) --> replace une commande par une variable
- indirection : evaluer la valeur d'une variable ;
ab = c
c=valeur
retrouver valeur

#### Les variables spéciales

- les variables special :
s# , $0 , $1, $3, ${X}
 $$ --> le PID du process 
$*, $@ 

#### Les tableaux

tableau simple
t=() --> tableau vide
t[valeur]=valeur
t=("je" "suis" "25" 5)

tableau associatif
ta = (["cle"="valeur" "cle2"="valeur"])
key_set=${!ta}
ajout d'element
modification d'elements
taille du tableau
etendre un ancien tableau
fusion de deux tableaux ou concatenation
unset pour supprimer un element d'indice ou supprimer le tableau



### Operations
- arithmetic : 
$((num_tring operateur num_string)) par exemple : $((25 + 25))
operateur : +, -, *, **, /, %
a+=((1)) ?
- let var= 2+3 ?

- comparaison numerique
- comparaison chaine caractere
- appartenance à un ensemble
- operations sur les fichiers
- operations sur les chaines
- autres operations ?

## Conditions

- pour numerique
-lt
-le
-gt
-ge
-ne
-eq

- pour les chaine :
 =
 !=

- appartenance à un ensemble



- syntaxe 1 :

if test $vara -eq $varb ; then
  echo "yes"
fi

- syntaxe 2 : 

if [ $vara -eq $var2 ] ; then 
  echo "yes" 
fi

- syntaxe 3 : 

if [ $vara -eq $varb ] || [ $varc -eq $vard ] ; then 
  echo "something" here
fi

- syntax 4 : beaucoup moins portable : voir postx la norme

if [[ $ptr1 -eq 252 && ptr -eq 5 ]] ; then 
    echo "yes"
fi
- verificaiton sur les chaine:

-n $chaine : pas vide
-z $chaine : chaine vide

- verification sur  les fichier

-d fichier : si c'est un dossier
-f : est un fichier
-e : existe dans le repertoire spéficier
-r : disponible en lecture
-x dispobible en execution
-W : disponible en ecriture
-s si la taille est supperieur à O
---> trouver le man permettant de retrouver ces info

- autres verification possible dans le language bash du meme genre


- case : 

case $cmd in 
  1) echo "something" ; do something ;;
  2) echo "something" ;;
  *) echo "otherthing" ;;
esac

## Boucle

while ((condition))
do
something to do
done
 -continue
 -break
 -exit

until (( condition))
do
done

for tmp in sequence 
do
something
done

for ((i=0 ; i> 10 ; i++))
do
something
done


### Tableau


### Foncton



### Traitement sur les chaine 
- {}  --> permet de faire des operations sur les chaines
- longueur d'une chaine  : ${#chaine}
- mettre la chaine en majuscule : ${chaine}
- ${chaine,} --> premieres caracteres en miniscule
- ${chaine,,} --> toutes la chaine en miniscule
- ${chaine,,[W]} --> toutes les w en miniscule
- ${chaine^}  --> les premieres caracteres en majuscule
- ${chaine^^}  --> toutes les chaines en majuscule
- ${chaine:0:7} --> extraction de sous chaine allant de 0 à 7
- ${chaine//motif/remplaçant} --> remple tous les motif par remplaçant
- ${chaine//motif/} --> remplace tous les motif par rien donc supressio
  exemple : ${chaine// /} --> supprime toutes les espace vides
- ${chaine#H*o} --> suppression des sous chaines "H..o" le motif le plus court(avec le ## on aura le motif le plus long)

### Commande et Operations Utils

- read name ;
read - p "votre nom ?"  name
read - p "votre nom ?"  -n 5 name 
echo name ;
(option - p, -n, -t voir le man  read)



> 🟦 **Info importante** : Ce projet utilise Docker et Kubernetes.

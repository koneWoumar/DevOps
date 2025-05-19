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

### Definition et Notions

- **Archive (.tar)** : Ensemble de fichiers regroupés dans un seul fichier sans compression.
- **Zip (.gz/.tar.gz)** : Archive compressée.
- **Paquet (.deb)** : Archive contenant un ensemble de fichiers permettant l'installation automatique d'un logiciel et (eventuellement ses dependances)
  - **.deb** contient :
    - `control.tar.gz` : Métadonnées (nom, version, dépendances, description, post/pre-install script).
    - `data.tar.gz` : Fichiers à installer sur le système.
    - `debian-binary` : Version du format Debian.

### Type de Paquet
IL existe deux type de paquet :
- Paquet  binaire : Paquet distribué directement avec les binaire de l'application, ce sont des `paquet.deb`
- Paquet source : Paquet distribué avec les fichiers sources de l'application qu'il faut compiler avant l'installation avec pour avantage d'avoir un binaire plus optimisé pour le systeme guest.

### Gestionnaire de Paquets et Dépendances

- **dpkg** : Installe un paquet sans gérer ses dépendances.
- **apt** : Installe un paquet et ses dépendances.

### Dépôts

- **Dépôt officiel (/etc/apt/sources.list)** : Maintenu par la distribution elle-même (ex. Ubuntu).
- **Dépôt tiers (/etc/apt/sources.d)** : Maintenu par une autre organisation ou développeur.
- **PPA (Personal Package Archive)** : Dépôt spécifique à Ubuntu, souvent hébergé sur Launchpad.net.

### Mise en Place d'un Paquet Binaire Debian

On peut obtenir un paquet binaire soit à partir d'un paquet source soit en metant en mettant en place une architecture de paquet avec les données de l'application à distribuer.
- Dans le premiere cas, il faut telecharger le bianaire source, compiler, installer oubien en faire un paquet.
- Dans le second cas, il faut respecter l'architecture d'un paquet sous debian (cas de debian ici) : dossier et fichier à mettre en place puis transformer le dossier obtenu en paquet avec dpgk.


####  Debian package from source code


```bash
# Ici nous telechargeons le paquet source de zsh
wget https://sourceforge.net/projects/zsh/files/zsh/5.9/zsh-5.9.tar.xz
# Ensuite il faut installer 'build-essential' qui est un métapaquet qui contient les outils necessaires pour compiler un logiciel ecrit en c/c++ à savoir gcc, g++, make, dpkg-dev.
sudo apt update
sudo apt install build-essential
# Il faut en suite lancer le script d'auto-generation s'il existe dans le repertoire. Ce script va generer la configuration de make. S'il n'existe pas dans le dossier, cela voudrais dire que la config de make est deja en place.
./autogen.sh
# Il faut executer le script configure qui va configurer la compilation (optimisaiton pour le systeme actuel)
./configure
# On peut compiler maintenat le code source avec make
make -j$(nproc)
# Enfin on peut transformer le resultat obtenu en paquet debian 
sudo checkinstall
# On peut eventuellement installer directement le binaire obtenu avec make
sudo make install
```


####  Tutoriel

#####    Architecture du paquet à venir

```bash
myapp/
├── DEBIAN
│   ├── control          # Métadonnées du paquet (nom, version, dépendances, etc.)
│   ├── preinst          # Script exécuté avant l’installation
│   ├── postinst         # Script exécuté après l’installation
│   ├── prerm            # Script exécuté avant la suppression
│   └── postrm           # Script exécuté après la suppression
├── usr
│   └── local
│       └── bin
│           └── myapp.py        # Script exécutable de l’application
├── var
│   └── lib
│       └── myapp
│           └── myapp.data      # Données persistantes de l’application
└── etc
│    └── myapp
│        └── myapp.conf         # Fichier de configuration de l’application
└── lib
    └── systemd
        └── system
            └── myapp.service   # Fichier de configuration de service pour l'applis si on veut executer l'appli en tant que service (cela est optionnelle)
```
#####  Les fichiers du paquet à venir

- `/myapp/DEBIAN/control`
```conf
Package: myapp
Version: 1.0
Section: base
Priority: optional
Architecture: all
Depends: python3 (>= 3.6), bash, python3-flask
Maintainer: Ton Nom <ton.email@example.com>
Description: MyApp - une application simple en Python
 Une application exemple empaquetée au format .deb.
 Elle installe un script Python, un fichier de configuration
 et des données persistantes dans les emplacements standards.
```

- `/myapp/DEBIAN/preinst`
```bash
#!/bin/bash
echo "Préparation à l'installation de MyApp..."
```

- `/myapp/DEBIAN/postint`
```bash
#!/bin/bash
echo "MyApp a été installé."
echo "Pour lancer le service : python3 /usr/local/bin/myapp.py &"
```

- `/myapp/DEBIAN/prerm`
```bash
#!/bin/bash
echo "Suppression de MyApp en cours..."
```

- `/myapp/DEBIAN/postrm`
```bash
#!/bin/bash
echo "MyApp a été complètement supprimé."
```

- `/myapp/lib/systemd/system/myapp.service`
```

```

- `/myapp/usr/local/bin/myapp.py`
```py

```
- `/myapp/etc/myapp.conf`
```conf
#!/usr/bin/env python3
from flask import Flask, request
import datetime

# Lire configuration
conf_path = '/etc/myapp.conf'
with open(conf_path) as f:
    lines = f.readlines()
    port = int([l for l in lines if l.startswith('port')][0].split('=')[1].strip())
    chemin = [l for l in lines if l.startswith('chemin')][0].split('=')[1].strip()

data_path = "/var/lib/myapp/myapp.data"

app = Flask(__name__)

@app.route(chemin, methods=["GET"])
def hello():
    with open(data_path, "a") as f:
        f.write(f"{datetime.datetime.now()} - {request.url}\n")
    return "Ceci est un message de test depuis MyApp."

if __name__ == "__main__":
    app.run(port=port)

```
- `/myapp/var/lib/myapp/myapp.data`
```
# Les logs des requêtes seront automatiquement ajoutés ici par l’application.

```



#####  Creation du paquet et installation du paquet
```bash
# Creation du paquet .deb
dpkg-deb --build myapp
# Installation du paquet .deb
dpkg -i myapp.deb
```

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

### Exemple de configuration de service pour une applis

Pour configurer un service pour une application, il faut : 

- Créer un fichier de configurer de service pour l'application soit `/etc/systemd/system/mon-app.service` :

``` conf
[Unit]
Description=Mon application personnalisée
After=network.target
Requires=network.target
Wants=network-online.target
StartLimitIntervalSec=0
StartLimitBurst=5
Documentation=https://mon-app.example.com/docs


[Service]
# Type de processus
Type=simple
# Utilisateur et groupe
User=monutilisateur
Group=monutilisateur
# Dossier de travail
WorkingDirectory=/opt/mon-app
# Commande de démarrage
ExecStart=/opt/mon-app/start.sh
# Commande d’arrêt (optionnelle)
ExecStop=/bin/kill -s TERM $MAINPID
ExecReload=/bin/kill -HUP $MAINPID
# Variables d’environnement
Environment="ENV=production"
EnvironmentFile=-/etc/mon-app/env.conf
# Redémarrage automatique
Restart=on-failure
RestartSec=5
TimeoutStartSec=30
TimeoutStopSec=20
# Journalisation
StandardOutput=journal
StandardError=journal
SyslogIdentifier=mon-app
# Ressources CPU
CPUQuota=50%
CPUSchedulingPolicy=other
CPUSchedulingPriority=0
Nice=5
# Ressources mémoire
MemoryMax=512M
MemoryHigh=256M
MemorySwapMax=1G
OOMScoreAdjust=-500
# Ressources IO
IOSchedulingClass=best-effort
IOSchedulingPriority=4
# File descriptor & processus
LimitNOFILE=65536
LimitNPROC=4096
# Sécurité et confinement
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true
ProtectKernelModules=true
ProtectControlGroups=true
ReadOnlyPaths=/opt/mon-app
ReadWritePaths=/var/log/mon-app
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_CHOWN
AmbientCapabilities=CAP_NET_BIND_SERVICE
SystemCallFilter=~@debug @privileged
PrivateDevices=true
# Dépendances conditionnelles
ConditionPathExists=/opt/mon-app/start.sh


[Install]
WantedBy=multi-user.target
```
- Gerer le cycle de vie de l'applis en tant que service : 

```bash
# Gerer le cycle de vie de l'applis avec le systemcl
sudo systemctl daemon-reload      # ou daemon-reload si systemd déjà lancé
sudo systemctl enable mon-app     # active au démarrage
sudo systemctl start mon-app      # démarre immédiatement
systemctl status mon-app          # voir le status de l'applis
systemctl stop mon-app            # arreter l'applis
# Afficher les logs de l'applis avec le sous composant journald de systemd : 
# Systemd capture automatiquement les logs des services via stdout et stderr pour les envoyer à journald qui va les centraliser pour une gestion plus efficace.
journalctl -u mon-app -f

```

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

####    Les variables standard en Bash

- Declaration de variable de typée dynamiquement
```bash
chaine='ma chaine brute sans variable' 
chaine="ma chaine avec des $variables"
variable=`ls -al`  # variable contenat qui va contenir retour d'une commande
variable=25        # variable contenant un entier
```

- Declaration de variables controlées avec `declare`
```bash
declare -r readOnlyVariable=value # readonly variable
readonly readOnlyVariable=value   # readonly variable
declare -i ingeterVariable=value  # integrer variable
declare -a tableVariable=(value1, value2 value3 value4)  # a table variable
declare -A associatifTable=([key1]="value1" [key2]="value2" [key3]="value3")  # an associatif variable
```

- Sustition : affecté le retour d'une commande dans une variable 
```bash
variable=$(command)
user=$(whoami)
```

- Expansion : etendre la valeur d'une variable
```bash
variableNom="oumar"
variableExpandu="${variableNom}DevOps"
variableExpandu # --> oumarDevOps
```
- Indirection : acces à la valeur d'une variable dont le nom est contenu dans une autre variable
```bash
varAge=25
myVarName="varAge"
${!myVarName}  # --> 25
```

- Valeur par defaut
```bash
myvar=${variable:-default}  # if variable empty or non define, set myvar to default
myvar=${variable:+default}  # if variable define and non empty, affecte default to myvar
myvar=${variable?message}   # if variable empty or non define, give error with message
```

- Les variables spéciales : elles sont disposible dans un script en execution
```bash
$@   # liste des arguments sous forme mis dans un tableau
$*   # liste des arguments concatenée dans une chaine
$#   # le nombre d'argument passée au scipt
$1   # le 1er argument
$2   # le 2eme argument
$3   # le 3eme argument
$$   # le PID du scipt actuel
$?   # le code de retour de la dernière commande
$!   # le PID de la dernière commande
```

####    Les tableaux

- Tableau indicé

```bash
tab=() # declaration d'un tableau vide (- declare -a tab=() # typé à la declaration)
tab=("value1" "value2" "value3" 25 3 "value") # tableau initialisé à la declaration
tab[indice]=valeur   # affectation ou modification d'une valeur du tableau
${tab[indice]}   #--> valeur du tableau à l'indice `indice`
${tab[@]}        #-->  le tableau entier
${#tab[@]}       #--> la taille du tableau
tab=(${tab[@]} value1 value2)   # extension du tableau
tab=(${tab1[@]} ${tab2[@]})   # fusion de deux tableaux
unset ${tab[indice]}          # supprimer la valeur à l'indice `indice`
```

- Tableau associatif
```bash
taba=()  # declaration de tableau associatif vide (declare -A taba=() # declaration typée)
taba=(["key"]="valeur" ["key1"]="valeur1" ["key2"]="valeur2") # declaration et initialisation
taba[key]=value  # affectation d'un nouveau couple ou modification d'un ancien
${taba[key]} # --> valeur associée à `key` 
${taba[@]} # --> le tableau associatif complet
${#taba[@]} # --> la taille du tableau
```

####    operations arithmetriques

- Affectation d'une operation arithmetrique avec substition
```bash
myvar=$((num1 operateur num2)) 
myvar=$(($var1 operateur $var2))
myvar=$((2+3))
```
- Affectation d'une operation arithmetrique sans substition
```bash
let myvar=num1 operateur num2
let myvar=$varInt1+$varInt2
let myvar=2+3
```
- Les operateurs arithemetriques
```bash
+ ; - ; * ; ** ; / ; %
```

###     Conditions

####     syntaxe

- Syntaxe generale

```bash
#
if [ condition ] 
  then
  instruction
fi
#
if [ condition ]
then
  instructions
else
  instructions
fi
#
if [ condition1 ]||[ condition2 ]
then
  instructions
fi
#
if [ condition1 ]&&[ condition2 ]
then
  instructions
fi
#
```
- Exemples 

```bash
#
if test $vara -eq $varb ; then
  echo "yes"
fi
#
if [ $vara -eq $var2 ] ; then 
  echo "yes" 
fi
#
if [ $vara -eq $var2 ] ; then 
  echo "yes"
else
  echo "non"
fi
#
if [ $var1 -eq $var2 ]||[ $var3 -ne $var4 ] ; then
  echo "yes"
fi
#
#
if [ $var1 -eq $var2 ]&&[ $var3 -ne $var4 ] ; then
  echo "yes"
fi
#
```
####    comparaison
- Comparaison avec les nombres
```bash
-gt ; -ge # greater than ; greater or equal
-lt ; -le # lower than ; lower or equal
-eq ; -ne # equal ; enequal 
```
- Comparaison avec les string
```bash
== # equal
=! # different
```

####     Diverses Operations de Tests Utilisées Dans les Conditions

- Operation sur les chaines

```bash
-n $chaine # si la chaine existe et non vide
-z $chaine # si la chaine est vide ou non existante
```

- Operations sur les fichiers
```bash
-e fichier # si le fichier existe
-d fichier # si le fichier est un fichier standard
-f fichier # si le fichier est un dossier
-r fichier # si le fichier est disponible en lecture
-w fichier # si le fichier est disponible en ecriture
-x fichier # si le fichier est disponible en execution
-s fichier # si le fichier existe et n'est pas vide
-O fichier # si l'utilisateur courant est le proprietaire du fichier
-G fchier  # si le group proprietaire du fichier est celui du user courant
```


###    Boucle

- Boucle while
```bash
## Syntaxe :
while ((condition)) ; do
  # intruction
done

# continue : continuer la boucle, recommencer la boucle
# break    : quitter la boucle
# exit     : quitter arreter le script avec un code retour (0 ou 1)
# les operateurs : == ; != ; > ; >= ;< ; <=
# les operateurs logique : && ; ||

## Exemple :
let i=0
while (( i<10 )) ; do
  echo "${i}éme occurance"
  let i-=1
done
```

- Boucle until
```bash
util (( condition )) ; do
  # instructions
done

# continue : continuer la boucle, recommencer la boucle
# break    : quitter la boucle
# exit     : quitter arreter le script avec un code retour (0 ou 1)
# les operateurs : == ; != ; > ; >= ;< ; <=
# les operateurs logique : && ; ||

## Exemple :
let i=0
until (( i==10 )) ; do
  echo "${i}éme occurance"
  let i+=1
done
```

- Boucle for
```bash
for (( intialisation ; condition ; incrementation )) ; do
  # instructions
done

## Exemple

for ((i=0 ; i> 10 ; i++))
do
  #something
done
```

- Parcours d'ensemble ou sequence
```bash
# syntaxe generale
for var in ensemble; do
  # instructions
done

## sur une sequence
for i in 1 2 3 4 5; do
  echo "i = $i"
done

## sur des chaine de caractere
for couleur in rouge vert bleu; do
  echo "Couleur : $couleur"
done

## sur un tableau
fruits=("pomme" "banane" "cerise")
for fruit in "${fruits[@]}"; do
  echo "Fruit : $fruit"
done

## sur la sortie d'une commande
for user in $(cut -d: -f1 /etc/passwd); do
  echo "Utilisateur : $user"
done

## sur des fichiers d'un dossier
for fichier in *.txt; do
  echo "Fichier texte : $fichier"
done

## sur des fichiers depuis divers repertoire
for file in /var/log/*.log /tmp/*.log; do
  echo "Log : $file"
done
```
###     Foncton

- Definition de fonction
```bash
# Syntaxe classique
ma_fonction() {
  echo "Hello"
}

# Ou bien avec le mot-clé function
function ma_fonction {
  echo "Hello"
}

# Les variables dans une fonctions
function ma_fonction(){
    echo "numer of argument :$#"
    echo "list of argument in a table forma : $@"
    echo "list of argument in a string forma : $*"
    echo "PID of the process executing this fonction : $$"
    echo "command that lunched this process : $0"
    echo "argument i : $i" # i ={1,2,3,4,5,6,7,8,9}
}
```

- Appel de fonction
```bash
# appel sans argument
ma_fonction
# appel avec arguments
ma_fonction arg1 arg2 arg3
```


###    Traitement sur les chaine  

Les `{}` permettent d'executer des operations sur les chaines string.

- Longueur d'une chaine
```bash
str="Bonjour"
echo ${#str}      # → 7
```

- Changement de la case
```bash
str="bonjour"
echo ${str^}        # → Bonjour (1re lettre en majuscule)
echo ${str^^}       # → BONJOUR (tout en majuscule)
echo ${str,}        # → bonjour (1re lettre en minuscule)
echo ${str,,}       # → bonjour (tout en minuscule)
```

- Remplacement de motif
```bash
str="bonjour le monde"
echo ${str/le/LA}       # → bonjour LA monde (le 1er 'le' rencontré)
echo ${str//le/LA}      # → bonjour LA monde (tous les 'le')
```

- Remplacer un suffix/prefix
```bash
str="prefix_chaine_suffix"
echo ${str#/prefix/"new_prefix"}          # → new_prefix_chaine_suffix
echo ${str%/suffix/"new_suffix"}          # → prefix_chaine_new_suffix
#####
echo ${str#/prefix/}                      # → chaine_suffix
echo ${str%/suffix/}                      # → prefix_chaine
```

- Extraction de sous chaine
```bash
str="Bonjour"
echo ${str:1}     # → onjour
echo ${str:1:3}   # → onj (début à 1, longueur 3)
echo echo ${str::3} # --> bon
```

- Supression de prefix/suffix
```bash
str="fichier.tar.gz"
echo ${str#*.}    # → tar.gz (supprime le plus court préfixe avant le 1er .)
echo ${str##*.}   # → gz (supprime le plus long préfixe jusqu’au dernier .)
#########
str="fichier.tar.gz"
echo ${str%.*}    # → fichier.tar (supprime le plus court suffixe après le dernier .)
echo ${str%%.*}   # → fichier (supprime le plus long suffixe après le 1er .)
```


###    Commande et Operations Utils et Divers


####     Commande et pratiques utiles

- Lecture depuis le clavier via l'entrée standard

```bash
read -p "votre nom ?"  name
read -p "votre nom ?"  -n 5 name
read -p "votre non ?" -n 5 -t  name
echo name ;
#  -p  : message display
#  -n  : limiter le nonbre de caracare
#  -t  : 
```

- Equivalent non interactive d'une comandes inernal

```bash
# Modification du mot de pass d'un user
echo "user:password" | sudo chpasswd
# 
```

####     Expression reguliere

- Caractere spéciaux des expressions regulières

|Caractere special|Role du caractere dans les regex|
|-----------------|--------------------------------|
| [ xyz ] | ensemble ou classe de caractere |
| [ x-x ] | interval |
| . | n'importe quel caractere |
| * | 0 ou plusieurs fois |
| + | 1 ou plusieurs fois |
| ? | 0 ou 1 fois |
| {n,m} | entre n et m fois |
| '|' | ou logique |
| (...) | sous section |
| ^ | debut de ligne |
| $ | fin de ligne |

- Utilisation des expressions regulières
```bash
############### ensemble et interval
[xyz] # : un des caractere x, y ou z
[^xyz] # : tous les caractere sauf x, y et z
[a-z] # : un des caractere  alphabetique miniscule
[A-Z] # : un des caractere alphabetique majuscule
[0-9] # : un chiffre
[a-zA-Z0-9] # : un alphanumérique
############### repetitons de caractere
regex* # : regex repeter plusieurs fois
regex+ # : regex repeter une ou plusieurs fois
regex? # : regex repeter un ou zero
regex(n,m) # : regex repeter entre n et m fois
###############  debut de ligne
regex^ # : ligne commençant par regex 
regex$ # : ligne se terminat par regex
###############  sous ensemble
(chien|chat) # : match si "chien" ou "chat"
(ha){n,m}   # : match si "ha" répété entre n et m fois
(ha)?       # : match si "ha" répété au plus une fois
(ha)*       # : match si "ha" répété plusieurs fois ou zero fois
(ha)+       # : match si "ha" répété au moins une fois
regex(chien|chat) # : match si regexchien ou regexchat
```
- Exemples d'utilisation des expressins regulière
```bash
############### Ensemble et Interval
echo "alpha beta" | grep '[ae]'      # Match les lignes contenant 'a' ou 'e'
echo "bon" | grep '[^aeiou]'         # Match les consonnes
echo "Zebra" | grep '[a-z]'          # Match les lettres minuscules
echo "Zebra" | grep '[A-Z]'          # Match 'Z'
echo "Apt 407" | grep '[0-9]'        # Match les chiffres
echo "!@#Alpha4" | grep '[a-zA-Z0-9]'  # Match tout sauf les symboles
############### Repetition
echo "baaa" | grep 'ba*'     # Match 'ba', 'baa', 'baaa'
echo "color colour" | grep -E 'colou?r'   # Match les deux versions
echo "hahaha-1" "ha-ha-ha-2" | grep -E '(ha){2,3}'  # Match 'hahaha-1' et non ha-ha-ha
############### Debut et fin de ligne
echo "Start here" | grep '^Start'     # Match uniquement si la ligne commence par 'Start'
echo "finish" | grep 'sh$'            # Match si la ligne se termine par 'sh'
```

####     Traitement de flux avec `sed` ,`grep` ,`awk`

#### grep

Consulter des lignes correspondant à une regex dans un flu.

```bash
######### syntaxe
grep -option regex fichier
######### option
-c # : afficher pluto le nombre de ligne correspondante
-i # : ignorer la case
-E ou egrep # : utilisé la syntaxe etendu des regex 
```

####     sed

Modifier le contenu d'un fichier ou d'un flux ligne par ligne : `substitition` , `suppression`, `insertion`, `ajout`, `affichage`, `Remplacement`

- Substition

```bash
########## syntaxe
sed -option "s/regex/remplaçant/flag" fichier_flux
########## options:
-i # : save output directly in the file flux ou flux
-n # : desactiver l'affichage automatique de la sortie
-e # : appliquer plusieur commande les une apres les autres
-f # : la commande sed est lire depuis un fichier
######### flag
g # : 'global' remplacer toutes les occurrence trouvé sur les lignes
chiffre n # :  remplacer uniquement la nième occurrence sur les lignes
e # : evaluate' --> le remplaçant est retour d'une commande
w # : indiquer un fichier de sortie qui va contenir l'output de la commande
```

- Insertion, Ajout, Remplacement, Suppression et Affichage

--------------------------------------------
| Commandes | Usages | Exemples | Resultat |
|-----------|--------|----------|-----------|
| p, = | Printing de ligne du texte | sed '3p' fichier | Afficher la 3ème ligne|
| d | deleting line | sed '3d' fichir | Supprimer la 3ème ligne | 
| i | Insert before current line | sed '3i\sentence_to_insert' fichier | inserer "sentence_to_inser' avant la 3eme line et decaler le reste : elle se trouve donc à la 3eme ligne|
| a | Append after current line | sed '3a\text_to_append' fichier | ajouter "tesxt_to_append" apres la 3eme ligne : elle se trouve donc à la 4ème ligne|
| c | Change current line | sed '3c\new_text' | changer la 3eme ligne par "new text" |


####     awk


# Terraform

## Introduction à Terraform

Terraform est un outil d'infrastructure as code (IaC) open source qui permet de gérer et d'automatiser la création, la mise à jour, et la suppression d'infrastructures de manière déclarative. Terraform est principalement utilisé pour provisionner des ressources sur divers fournisseurs de cloud tels qu'AWS, Google Cloud, Azure, et bien d'autres. En écrivant des fichiers de configuration en langage HashiCorp Configuration Language (HCL), vous pouvez décrire l'infrastructure désirée et laisser Terraform s'occuper de la mise en œuvre.

---
**NOTE**
Il y'a souvent une guerre entre Ansible et Terraform. En effet, Ansible peut faire ce que Terraform fait mais pas de la meme maniere. 
Ansible excelle dans la configurations du systeme d'exploitation, dans l'installation et la configuration des outils et application dans le systeme (serveur).
Cependant Ansible a des limites dans le provisionning des infrastructures et la gestion de leur cycle de vie. En effet :

- Ansible n'a pas de base de donnée des états pour gerer de façon intelligente les mise à jour des objets (faire une differentielle entre l'état actuelle et l'état voulue)
- Il faut un code distincte pour créer, mettre à jour et supprimer les objets

Terraform excelle dans le provisionning et la gestion du cycle de vie des infrastructure sur les differentes provider de Cloud (AWS, GGP, OpenStack, ...), capable de deployer la meme infrastructure sur differentes provider de cloud tout en gerant la consistance de ces infrastructure.

---

## Installation sur Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y wget unzip
wget https://releases.hashicorp.com/terraform/{version}/terraform_{version}_linux_amd64.zip
unzip terraform_{version}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

## Concepts de base de Terraform

- Provider : Terraform utilise des "providers" pour interagir avec différents services cloud (par exemple, AWS, Azure, GCP). Chaque provider expose des types de ressources spécifiques.
- Resource : Une ressource représente une entité d'infrastructure gérée par Terraform, comme une instance de machine - virtuelle, une base de données ou un service réseau.
- Module : Un module est un ensemble de configurations réutilisables. Il permet de regrouper des ressources et de les appeler dans d'autres configurations.
- State : Terraform conserve un état (fichier de state) pour savoir quelles ressources sont déjà créées, mises à jour ou supprimées. Cet état est essentiel pour garantir la cohérence des déploiements.

## Terraform - Structure et organisation

Terraform recommande d'organiser les configurations en séparant les variables (fichier variables.tf), les outputs (fichier outputs.tf), et les configurations de base (fichier main.tf). De plus, pour des infrastructures plus grandes et complexes, il est recommandé d'utiliser des modules pour réutiliser des blocs de code, comme la configuration réseau, la gestion des rôles IAM, ou les bases de données.

### Structure d'un projet Terraform

Un projet Terraform est souvent structuré de manière à organiser les différents fichiers de configuration, les variables, et les outputs :

```css
/~/my-terraform-project/
├── main.tf               # Fichier principal contenant les configurations des ressources
├── variables.tf          # Fichier de définition des variables
├── outputs.tf            # Fichier de sortie pour exporter les informations des ressources créées
└── terraform.tfstate     # Fichier d'état généré par Terraform pour suivre les ressources gérées
```
Par défaut, le répertoire de travail est le dossier contenant les fichiers .tf, mais il est possible de configurer Terraform pour utiliser des backends distants comme S3 pour stocker l’état.

### Fichier de configuration principal de Terraform

Le fichier de configuration principal de Terraform (main.tf) permet de définir, gérer et provisionner des infrastructures.

#### Structure de base

```css
# 1. Provider
provider "PROVIDER_NAME" {
  # Configuration du provider
}

# 2. Variables
variable "VARIABLE_NAME" {
  # Définition de la variable
}

# 3. Data Sources
data "PROVIDER_NAME_resource" "RESOURCE_NAME" {
  # Définition de la source de données
}

# 4. Ressources
resource "PROVIDER_NAME_resource" "RESOURCE_NAME" {
  # Définition de la ressource
}

# 5. Outputs
output "OUTPUT_NAME" {
  # Définition des sorties d'informations
}
```
#### Explications des sections

- Provider : Le provider configure l’accès au service cloud sur lequel vous souhaitez déployer l’infrastructure. Ici, pour OpenStack, il peut contenir des informations d'authentification (comme auth_url, username, password, tenant_name).

- Variables : Les variables permettent de rendre la configuration flexible et réutilisable en paramétrant certaines valeurs (comme le type de machine, l’image à utiliser, le nom de l'instance, etc.).

- Data Sources : Les data sources (ou sources de données) permettent de récupérer des informations de l'infrastructure existante ou des données utiles (comme l’ID d’une image Debian sur OpenStack).

- Ressources : Les ressources sont les éléments de l’infrastructure que Terraform gère, comme des instances, des réseaux ou des disques. Dans ce cas, nous utiliserons la ressource openstack_compute_instance_v2 pour créer une instance.

- Outputs : Les outputs permettent d’afficher certaines informations en sortie, utiles pour la gestion ou l'accès à l'infrastructure, comme l'IP publique de l'instance déployée.

#### Exemple
Voici un exemple de fichier main.tf configuré pour déployer une instance Debian sur une installation OpenStack locale : 

###### Deployment d'une debian sur un OpenStack local

```css
# 1. Provider - configuration pour OpenStack
provider "openstack" {
  auth_url    = "http://localhost:5000/v3"
  region      = "RegionOne"
  tenant_name = "my_project"
  user_name   = "admin"
  password    = "admin_password"
  domain_name = "default"
}

# 2. Variables - pour personnaliser les configurations
variable "instance_name" {
  description = "Nom de l'instance OpenStack"
  type        = string
  default     = "debian-instance"
}

variable "flavor_name" {
  description = "Type de machine OpenStack (flavor)"
  type        = string
  default     = "m1.small"
}

variable "network_name" {
  description = "Nom du réseau auquel l'instance sera connectée"
  type        = string
  default     = "public"
}

# 3. Data Source - récupération de l'ID de l'image Debian
data "openstack_images_image_v2" "debian_image" {
  name = "debian-10"
}

# 4. Resource - création de l'instance
resource "openstack_compute_instance_v2" "debian_instance" {
  name            = var.instance_name
  image_id        = data.openstack_images_image_v2.debian_image.id
  flavor_name     = var.flavor_name
  key_pair        = "my_keypair"
  network {
    name = var.network_name
  }

  # Tags pour identification
  tags = ["Terraform", "Debian", "OpenStack"]
}

# 5. Outputs - afficher l'IP publique de l'instance
output "instance_public_ip" {
  description = "Adresse IP de l'instance Debian"
  value       = openstack_compute_instance_v2.debian_instance.access_ip_v4
}

```

###### Explication du fichier de configuration

- Provider OpenStack : Ce bloc configure les informations d'authentification et de connexion au serveur OpenStack local.

- Variables :
    instance_name : Le nom de l'instance Debian.
    flavor_name : Le type de machine (flavor) choisi pour l’instance, ici m1.small.
    network_name : Le réseau auquel l’instance sera connectée, ici public.

- Data Source :
    openstack_images_image_v2 : Cette source de données récupère l'ID de l'image Debian existante sur OpenStack, nommée ici debian-10.

- Resource :
    openstack_compute_instance_v2 : Ce bloc crée l'instance Debian. Il utilise l’ID de l'image Debian, la flavor choisie, et connecte l'instance au réseau spécifié.

- Outputs :
    instance_public_ip : Cette sortie affiche l'IP publique de l'instance, facilitant l'accès et la gestion.

## Modules Terraform

Les modules permettent de diviser et d'organiser les configurations en petits blocs réutilisables. Voici un exemple de structure pour un module :

### Strucure d'un module

```css
modules/
└── instance/
    ├── main.tf        # Configuration principale du module
    ├── variables.tf   # Variables du module
    ├── outputs.tf     # Outputs du module
```
En appelant le module dans le fichier main.tf principal du projet, vous pouvez facilement réutiliser sa configuration :

```css
module "web_server" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  ami           = "ami-0c55b159cbfafe1f0"
}
```

### Exemple de module

- main.tf

```css
```

- variables.tf

```css
```

- outputs.tf

```css
```


### Emplacement d'un module par rapport à un projet

##### 1. Modules locaux dans le projet :

Les modules peuvent être placés dans un sous-répertoire appelé modules (ou un autre nom significatif) dans le répertoire racine du projet.

- La structure ressemble généralement à ceci :
```css
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── module1/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── module2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```
- Pour utiliser un module situé dans le répertoire modules/module1, la syntaxe dans le fichier main.tf serait :
```css
    module "example" {
      source = "./modules/module1"
      # autres arguments
    }
```
##### 2. Modules distants (référencés depuis un VCS ou un registre de modules) :

Les modules peuvent être téléchargés depuis un registre public ou privé, comme le Terraform Registry (registry.terraform.io), ou depuis un dépôt Git.

- Pour un module sur le Terraform Registry :
```css
module "example" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  # autres arguments
}
```
- Pour un module hébergé sur GitHub (ou un autre VCS), vous pouvez spécifier l’URL du dépôt et éventuellement une branche ou un tag :
```css
module "example" {
    source = "git::https://github.com/username/repo_name.git//module_path?ref=branch_or_tag"
    # autres arguments
}
```
##### 3. Modules publiés localement ou via un système de fichiers :

Si vous souhaitez utiliser un module stocké localement ailleurs que dans le projet (par exemple dans un répertoire partagé), spécifiez le chemin du système de fichiers :
```css
module "example" {
    source = "/path/to/local/module_directory"
    # autres arguments
}
```
##### 4. Bonnes pratiques

- Utilisez des modules locaux pour des composants spécifiques au projet, surtout s'ils sont réutilisés plusieurs fois dans la configuration.
- Utilisez le Terraform Registry ou un dépôt Git pour des modules communs, maintenus indépendamment du projet.


## Principales commandes de Terraform

Voici une liste des commandes essentielles de Terraform :

| Commande             | Description                                                                                   |
|----------------------|-----------------------------------------------------------------------------------------------|
| `terraform init`     | Initialise le projet, télécharge les plugins de provider nécessaires.                         |
| `terraform plan`     | Affiche un aperçu des modifications qui seront appliquées sur l'infrastructure.               |
| `terraform apply`    | Applique les modifications d'infrastructure selon la configuration.                           |
| `terraform destroy`  | Supprime toutes les ressources gérées par Terraform dans l'état actuel.                       |
| `terraform validate` | Valide la syntaxe et la logique des fichiers de configuration.                                |
| `terraform fmt`      | Reformate les fichiers .tf selon le style de Terraform.                                       |



## Bonnes pratiques et gestion des erreurs

- Versionner l’état : Utilisez un backend distant comme AWS S3 ou GCP pour stocker et versionner l’état.
- Éviter les modifications manuelles : Évitez de changer les ressources gérées par Terraform directement dans le cloud, cela pourrait désynchroniser l’état.
- Sécuriser les variables sensibles : Utilisez des fichiers de variables pour les secrets ou chiffrez les valeurs sensibles.
- Valider avant d’appliquer : Exécutez terraform plan avant terraform apply pour éviter les erreurs de configuration.

Terraform est un outil puissant et flexible pour l'infrastructure as code. En combinant des configurations modulaires et en automatisant le provisionnement, il permet une gestion efficace des environnements cloud complexes.

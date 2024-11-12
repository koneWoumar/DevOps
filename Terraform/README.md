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

Terraform est excelle dans le provisionning et la gestion du cycle de vie des infrastructure sur les differentes provider de Cloud (AWS, GGP, OpenStack, ...), capable de deployer la meme infrastructure sur differentes provider de cloud tout en gerant la consistance de ces infrastructure.
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

## Structure d'un projet Terraform

Un projet Terraform est souvent structuré de manière à organiser les différents fichiers de configuration, les variables, et les outputs :

```css
/~/my-terraform-project/
├── main.tf               # Fichier principal contenant les configurations des ressources
├── variables.tf          # Fichier de définition des variables
├── outputs.tf            # Fichier de sortie pour exporter les informations des ressources créées
└── terraform.tfstate     # Fichier d'état généré par Terraform pour suivre les ressources gérées
```
Par défaut, le répertoire de travail est le dossier contenant les fichiers .tf, mais il est possible de configurer Terraform pour utiliser des backends distants comme S3 pour stocker l’état.

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
##### Bonnes pratiques

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


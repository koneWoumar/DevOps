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

## Concepts de base de Terraform

- Provider : Terraform utilise des "providers" pour interagir avec différents services cloud (par exemple, AWS, Azure, GCP). Chaque provider expose des types de ressources spécifiques.
- Resource : Une ressource représente une entité d'infrastructure gérée par Terraform, comme une instance de machine - virtuelle, une base de données ou un service réseau.
- Module : Un module est un ensemble de configurations réutilisables. Il permet de regrouper des ressources et de les appeler dans d'autres configurations.
- State : Terraform conserve un état (fichier de state) pour savoir quelles ressources sont déjà créées, mises à jour ou supprimées. Cet état est essentiel pour garantir la cohérence des déploiements.

## Installation sur Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y wget unzip
wget https://releases.hashicorp.com/terraform/{version}/terraform_{version}_linux_amd64.zip
unzip terraform_{version}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

## Structure d'un projet Terraform

Un projet Terraform est souvent structuré de manière à organiser les différents fichiers de configuration, les variables, et les outputs :

/~/my-terraform-project/
├── main.tf               # Fichier principal contenant les configurations des ressources
├── variables.tf          # Fichier de définition des variables
├── outputs.tf            # Fichier de sortie pour exporter les informations des ressources créées
└── terraform.tfstate     # Fichier d'état généré par Terraform pour suivre les ressources gérées

    Par défaut, le répertoire de travail est le dossier contenant les fichiers .tf, mais il est possible de configurer Terraform pour utiliser des backends distants comme S3 pour stocker l’état.

Principales commandes de Terraform

Voici une liste des commandes essentielles de Terraform :
Commande	Description
terraform init	Initialise le projet, télécharge les plugins de provider nécessaires.
terraform plan	Affiche un aperçu des modifications qui seront appliquées sur l'infrastructure.
terraform apply	Applique les modifications d'infrastructure selon la configuration.
terraform destroy	Supprime toutes les ressources gérées par Terraform dans l'état actuel.
terraform validate	Valide la syntaxe et la logique des fichiers de configuration.
terraform fmt	Reformate les fichiers .tf selon le style de Terraform.
Exemple de fichier de configuration de base

Voici un exemple d'un fichier main.tf pour provisionner une instance EC2 sur AWS :

# Configuration du provider AWS
provider "aws" {
  region = "us-east-1"
}

# Déclaration de la ressource pour une instance EC2
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraformExampleInstance"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}

Terraform - Structure et organisation

Terraform recommande d'organiser les configurations en séparant les variables (fichier variables.tf), les outputs (fichier outputs.tf), et les configurations de base (fichier main.tf). De plus, pour des infrastructures plus grandes et complexes, il est recommandé d'utiliser des modules pour réutiliser des blocs de code, comme la configuration réseau, la gestion des rôles IAM, ou les bases de données.
Modules Terraform

Les modules permettent de diviser et d'organiser les configurations en petits blocs réutilisables. Voici un exemple de structure pour un module :

modules/
└── instance/
    ├── main.tf        # Configuration principale du module
    ├── variables.tf   # Variables du module
    ├── outputs.tf     # Outputs du module

En appelant le module dans le fichier main.tf principal du projet, vous pouvez facilement réutiliser sa configuration :

module "web_server" {
  source = "./modules/instance"
  instance_type = "t2.micro"
  ami           = "ami-0c55b159cbfafe1f0"
}

Bonnes pratiques et gestion des erreurs

    Versionner l’état : Utilisez un backend distant comme AWS S3 ou GCP pour stocker et versionner l’état.
    Éviter les modifications manuelles : Évitez de changer les ressources gérées par Terraform directement dans le cloud, cela pourrait désynchroniser l’état.
    Sécuriser les variables sensibles : Utilisez des fichiers de variables pour les secrets ou chiffrez les valeurs sensibles.
    Valider avant d’appliquer : Exécutez terraform plan avant terraform apply pour éviter les erreurs de configuration.

Terraform est un outil puissant et flexible pour l'infrastructure as code. En combinant des configurations modulaires et en automatisant le provisionnement, il permet une gestion efficace des environnements cloud complexes.


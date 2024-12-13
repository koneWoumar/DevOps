#-----------------------------Providers------------------------------#

# Chemin vers la clé de service GCP
variable "service_account_key_path" {
  description = "Chemin vers la clé de compte de service JSON"
  type        = string
}

# ID du projet GCP
variable "gcp_project_id" {
  description = "ID du projet GCP"
  type        = string
}

# Région
variable "region" {
  description = "La région pour la configuration"
  type        = string
}

#-----------------------------Ressources------------------------------#

# Nom de la ressource
variable "machine_name" {
    description = "le nom que portera la vm qui sera créé"
    type = string
}

# Type de la ressource
variable "machine_type" {
    description = "le type de la ressource definissant ces config : cpu, ram, stockage"
    type = string
}

# Zone utilisée
variable "machine_zone" {
  description = "Zone où la VM sera créée"
  type        = string
}

# Image de base de la machine
variable "machine_image" {
    description = "l'image de base utilisé pour la machine"
    type        = string
}

# La taille du disque de stockage
variable "machine_storage_size" {
    description = "machine storage size"
    type        = string
}

# La clé ssh publique d'acces
variable "ssh_public_key" {
    description = "ma cley publique"
    type        = string
}

# Le chemin vers la  clé privée pour l'auth ssh ansible
variable "ssh_private_key" {
    description = "ma cley publique"
    type        = string
}

# Le mot de pass de l'utilisateur par defaut
variable "default_user_password" {
    description = "mot de pass du user par defaut"
    type        = string
}

# Le nom de l'utilisateur par defuat
variable "default_user" {
    description = "le nom de l'utilisateur par defaut"
    type        = string
}
#-----------------------------Domaine Network Name------------------------------#

# Nom de la zone DNS existante dans Cloud DNS
variable "managed_zone" {
  description = "Nom de la zone Cloud DNS existante"
  type        = string
}

# Sous-domaine pour l'entrée DNS
variable "dns_name" {
  description = "Le sous-domaine que vous souhaitez utiliser"
  type        = string
}

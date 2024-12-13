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

#-----------------------------Domaine Network Name------------------------------#

# Nom de la zone DNS existante dans Cloud DNS
variable "managed_zone" {
  description = "Nom de la zone Cloud DNS existante"
  type        = string
}
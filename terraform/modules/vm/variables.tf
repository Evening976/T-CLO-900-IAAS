variable "resource_group_name" {
  description = "Nom du resource group"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "name_prefix" {
  description = "Préfixe du nom de la VM"
  type        = string
}

variable "size" {
  description = "Taille de la VM"
  type        = string
  default     = "Standard_B2ms"
}

variable "subnet_id" {
  description = "ID du sous-réseau"
  type        = string
}

variable "ssh_key" {
  description = "Contenu de la clé publique SSH"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "Liste des IPs CIDR autorisées à se connecter en SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vm_count" {
  description = "Nombre de VMs à créer"
  type        = number
  default     = 1
}

variable "enable_public_ip" {
  description = "Activer une IP publique (true pour le bastion)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags pour les ressources Azure"
  type        = map(string)
  default     = {}
}

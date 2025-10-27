variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-mar_3"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "ssh_pubkey_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_ips" {
  description = "List of CIDR IPs allowed to SSH to bastion"
  type        = list(string)
  default     = ["YOUR_PUBLIC_IP/32"] # remplace par ton IP ou par ["0.0.0.0/0"] temporairement
}

variable "master_count" {
  type    = number
  default = 1
}

variable "worker_count" {
  type    = number
  default = 2
}

variable "master_size" {
  type    = string
  default = "Standard_B2ms"
}

variable "worker_size" {
  type    = string
  default = "Standard_B2ms"
}

variable "gitlab_size" {
  type    = string
  default = "Standard_B2s"
}

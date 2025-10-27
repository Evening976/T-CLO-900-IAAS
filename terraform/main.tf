provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
  location = var.location
}

locals {
  common_tags = {
    project = "iaas-kube"
    owner   = "devops"
  }
}

module "network" {
  source              = "./modules/network"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  vnet_name           = "vnet-iaas"
  address_space       = ["10.10.0.0/16"]
}

module "bastion" {
  source              = "./modules/vm"
  name_prefix         = "bastion"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  subnet_id           = module.network.subnet_ids[0]
  ssh_key             = file(var.ssh_pubkey_path)
  enable_public_ip    = true
  allowed_ssh_ips     = var.allowed_ssh_ips
  tags                = local.common_tags
}

# Masters / Workers -> pas d’IP publique
module "vm_master" {
  source              = "./modules/vm"
  count               = var.master_count
  name_prefix         = "k8s-master"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  subnet_id           = module.network.subnet_ids[1]
  ssh_key             = file(var.ssh_pubkey_path)
  tags                = local.common_tags
}

module "vm_worker" {
  source              = "./modules/vm"
  name_prefix         = "k8s-worker"
  count               = var.worker_count

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  subnet_id           = module.network.subnet_ids[2]
  ssh_key             = file(var.ssh_pubkey_path)
  tags                = local.common_tags
}

# VM pour GitLab
module "vm_gitlab" {
  source              = "./modules/vm"
  name_prefix         = "gitlab"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  size                = var.gitlab_size
  subnet_id           = module.network.subnet_ids[2]
  ssh_key             = file(var.ssh_pubkey_path)
  tags                = local.common_tags
}

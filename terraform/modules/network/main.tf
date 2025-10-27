data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnets" {
  count                = 3
  name                 = "subnet-${count.index}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.${count.index}.0/24"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastion-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

output "subnet_ids" {
  value = [for s in azurerm_subnet.subnets : s.id]
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion.ip_address
}

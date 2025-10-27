locals {
  admin_user = "azureuser"
}

resource "azurerm_network_security_group" "nsg" {
  count               = var.count
  name                = "${var.name_prefix}-${count.index}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, { role = var.name_prefix })

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = length(var.allowed_ssh_ips}) > 0 ? var.allowed_ssh_ips : ["*"]
    destination_address_prefix = "*"
  }

  dynamic "security_rule" {
    for_each = var.enable_public_ip ? [1] : []
    content {
      name                       = "AllowInternal"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.10.0.0/16"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  count               = var.enable_public_ip ? var.count : 0
  name                = "${var.name_prefix}-${count.index}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge(var.tags, { role = var.name_prefix })
}


resource "azurerm_network_interface" "nic" {
  count               = var.count
  name                = "${var.name_prefix}-${count.index}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, { role = var.name_prefix })

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? element(azurerm_public_ip.vm_public_ip[*].id, count.index) : null
  }
}

# Association NSG/NIC
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count                     = var.count
  network_interface_id      = element(azurerm_network_interface.nic[*].id, count.index)
  network_security_group_id = element(azurerm_network_security_group.nsg[*].id, count.index)
}


resource "azurerm_linux_virtual_machine" "vm" {
  count                  = var.count
  name                   = "${var.name_prefix}-${count.index}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  network_interface_ids  = [element(azurerm_network_interface.nic[*].id, count.index)]
  size                   = var.size
  admin_username         = local.admin_user
  tags = merge(var.tags, {role = var.name_prefix})


  depends_on = [
    azurerm_network_interface_security_group_association.nsg_assoc
  ]

  admin_ssh_key {
    username   = local.admin_user
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Outputs
output "private_ips" {
  value = azurerm_network_interface.nic[*].private_ip_address
}

output "public_ips" {
  value = var.enable_public_ip ? azurerm_public_ip.vm_public_ip[*].ip_address : []
}

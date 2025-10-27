terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mar_3"
    storage_account_name = "tfstoragemar3"
    container_name       = "tfstate"
    key                  = "iaas-kube.tfstate"
  }
}
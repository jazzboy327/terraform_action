provider "azurerm" {
  features {}
}

module "rg" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source              = "../../modules/network"
  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = module.rg.name
  address_space       = var.address_space
}

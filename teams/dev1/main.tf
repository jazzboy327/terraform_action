provider "azurerm" {
  features {}
}

locals {
  common_tags = {
    Environment = var.environment
    Team        = var.team_name
    Service     = var.service_name
    Owner       = "kt"
    Created     = timestamp()
  }
}

module "rg" {
  source   = "../../modules/resource_group"
  name     = "rg-dev1"
  location = var.location
}

module "vnet" {
  source                  = "../../modules/network"
  vnet_name               = "vnet_dev1"
  location                = var.location
  resource_group_name     = module.rg.name
  address_space           = var.address_space
  subnet_address_prefixes = ["10.0.1.0/24"]
}

module "vm" {
  source              = "../../modules/vm"
  vm_name             = "vm_dev1"
  location            = var.location
  resource_group_name = module.rg.name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  subnet_id           = module.vnet.subnet_id
  tags                = local.common_tags
}

#!/bin/bash

TEAM=$1
LOCATION=$2

mkdir -p "./teams/${TEAM}"

cat > "./teams/${TEAM}/backend.tf" <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg"
    storage_account_name = "axdtfstatestorageac" # only lowcase!!  
    container_name       = "tfstate"
    key                  = "teams/${TEAM}/terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}
EOF

cat > "./teams/${TEAM}/main.tf" <<EOF
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
  name     = "rg-${TEAM}"
  location = var.location
}

module "vnet" {
  source                  = "../../modules/network"
  vnet_name               = "vnet-${TEAM}"
  location                = var.location
  resource_group_name     = module.rg.name
  address_space           = var.address_space
  subnet_address_prefixes = ["10.0.1.0/24"]
}

module "vm" {
  source              = "../../modules/vm"
  vm_name             = "vm-${TEAM}"
  location            = var.location
  resource_group_name = module.rg.name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  subnet_id           = module.vnet.subnet_id
  tags                = local.common_tags
}
EOF

cat > "./teams/${TEAM}/variables.tf" <<EOF
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "environment" {
  type = string
}

variable "team_name" {
  type = string
}

variable "service_name" {
  type = string
}

EOF

echo "✅ 팀 디렉토리 ${TEAM} 생성 완료!"

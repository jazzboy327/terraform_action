terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group for Terraform Backend
resource "azurerm_resource_group" "backend" {
  name     = "tf-backend-rg"
  location = "koreacentral"
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "backend" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.backend.name
  location                 = azurerm_resource_group.backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable versioning for state files
  blob_properties {
    versioning_enabled = true
  }
}

# Container for Terraform State
resource "azurerm_storage_container" "backend" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.backend.name
  container_access_type = "private"
}

# Output the access key
output "storage_account_key" {
  value     = azurerm_storage_account.backend.primary_access_key
  sensitive = true
}

output "storage_account_name" {
  value = azurerm_storage_account.backend.name
}

output "resource_group_name" {
  value = azurerm_resource_group.backend.name
}

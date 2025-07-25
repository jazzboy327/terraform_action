terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg"
    storage_account_name = "axdtfstatestorageac1" # only lowcase!! 계정별로 다르게 설정해야함
    container_name       = "tfstate"
    key                  = "teams/dev11/terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

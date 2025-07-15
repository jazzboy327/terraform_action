terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg"
    storage_account_name = "tfstatestorage123"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}

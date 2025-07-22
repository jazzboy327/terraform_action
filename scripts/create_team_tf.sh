#!/bin/bash

TEAM=$1

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


echo "✅ 팀 디렉토리 ${TEAM} 생성 완료!"

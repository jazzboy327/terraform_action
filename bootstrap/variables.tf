variable "resource_group_name" {
  default = "tf-backend-rg"
}

variable "location" {
  default = "koreacentral"
}

variable "storage_account_name" {
  default = "tfstatestorage123"  # 고유해야 함
}

variable "container_name" {
  default = "tfstate"
}

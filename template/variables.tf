variable "vm_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "environment" {
  description = "환경(dev, stage, prod 등)"
  type        = string
}

variable "team_name" {
  description = "팀 이름"
  type        = string
}

variable "service_name" {
  description = "서비스 이름"
  type        = string
}

variable "vnet_name" {
  description = "VNet 이름"
  type        = string
}

variable "address_space" {
  description = "VNet CIDR"
  type        = list(string)
}

variable subnet_address_prefixes{
  description = "subnet "
  type        = list(string)
}


variable "tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
} 
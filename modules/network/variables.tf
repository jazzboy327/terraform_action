variable "vnet_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnet_address_prefixes" {
  type = list(string)
  default = ["10.0.1.0/24"]
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
} 
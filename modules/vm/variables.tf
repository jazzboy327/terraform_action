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

variable "subnet_id" {
  description = "VM이 연결될 Subnet의 ID"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
} 
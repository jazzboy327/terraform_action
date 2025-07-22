output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.rg.name
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.vnet.vnet_name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = module.vnet.subnet_name
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = module.vm.vm_name
}

output "vm_private_ip" {
  description = "The private IP address of the virtual machine"
  value       = module.vm.vm_private_ip
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine"
  value       = module.vm.vm_public_ip
} 
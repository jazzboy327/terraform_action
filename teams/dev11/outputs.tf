output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "The name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "The private IP address of the Virtual Machine"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_public_ip" {
  description = "The public IP address of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
} 
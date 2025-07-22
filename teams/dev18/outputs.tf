output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = module.vm.vm_id
}

output "vm_name" {
  description = "The name of the Virtual Machine"
  value       = module.vm.vm_name
}

output "vm_private_ip" {
  description = "The private IP address of the Virtual Machine"
  value       = module.vm.vm_private_ip
}

output "vm_public_ip" {
  description = "The public IP address of the Virtual Machine"
  value       = module.vm.vm_public_ip
} 
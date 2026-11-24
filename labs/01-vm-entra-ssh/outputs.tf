output "resource_group_name" {
  description = "Name of the created Resource Group"
  value       = azurerm_resource_group.groupe.name
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.name
}
output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}
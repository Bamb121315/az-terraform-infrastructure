output "resorce_group_name" {
    description = "Name wygenerowanej Grupy Zasobów"
    value = azurerm_resource_group.rg_stud.name
}

output "vm_name" {
    description = "Nazwa VM'ki"
    value = azurerm_linux_virtual_machine.maszyna.name
}
output "vm_private_ip" {
    description = "Prywatny adres IP VM"
    value = azurerm_linux_virtual_machine.maszyna.private_ip_address
}
output "resource_group_name" {
  description = "Name of the Hub-Spoke Resource Group"
  value       = azurerm_resource_group.groupe.name
}

output "hub_vnet_id" {
  description = "Resource ID of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  description = "Resource ID of the Spoke Virtual Network"
  value       = azurerm_virtual_network.spoke.id
}
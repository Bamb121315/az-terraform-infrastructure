resource "azurerm_resource_group" "network_lab" {
    name = "rg-hub-spoke-lab"
    location = "westeurope"
}

resource "azurerm_virtual_network" "vnet-hub" {
    name = "vnet-hub"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.network_lab.location
    resource_group_name = azurerm_resource_group.network_lab.name
}

resource "azurerm_virtual_network" "vnet-spoke" {
    name = "vnet-spoke"
    address_space = ["10.1.0.0/16"]
    location = azurerm_resource_group.network_lab.location
    resource_group_name = azurerm_resource_group.network_lab.name
}

resource "azurerm_virtual_network_peering" "peering_hub_to_spoke" {
    name = "peering-hub-to-spoke"
    resource_group_name = azurerm_resource_group.network_lab.name
    virtual_network_name = azurerm_virtual_network.vnet-hub.name
    remote_virtual_network_id = azurerm_virtual_network.vnet-spoke.id
}

resource "azurerm_virtual_network_peering" "peering_spoke_to_hub" {
    name = "peering-spoke-to-hub"
    resource_group_name = azurerm_resource_group.network_lab.name
    virtual_network_name = azurerm_virtual_network.vnet-spoke.name
    remote_virtual_network_id = azurerm_virtual_network.vnet-hub.id     
}

resource "azurerm_subnet" "gateway_subnet" {
    name = "GatewaySubnet"
    resource_group_name = azurerm_resource_group.network_lab.name
    virtual_network_name = azurerm_virtual_network.vnet-hub.name
    address_prefixes = ["10.0.1.0/24"]
}
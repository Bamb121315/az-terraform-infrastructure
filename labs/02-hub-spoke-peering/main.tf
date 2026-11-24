resource "azurerm_resource_group" "groupe" {
  name     = "${var.env_prefix}-rg-hub-spoke"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "${var.env_prefix}-vnet-hub"
  address_space       = var.hub_address_space
  location            = azurerm_resource_group.groupe.location
  resource_group_name = azurerm_resource_group.groupe.name
  tags                = var.tags
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.groupe.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "spoke" {
  name                = "${var.env_prefix}-vnet-spoke"
  address_space       = var.spoke_address_space
  location            = azurerm_resource_group.groupe.location
  resource_group_name = azurerm_resource_group.groupe.name
  tags                = var.tags
}

resource "azurerm_subnet" "spoke_workload" {
  name                 = "${var.env_prefix}-snet-spoke-workload"
  resource_group_name  = azurerm_resource_group.groupe.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "spoke_workload" {
  name                = "${var.env_prefix}-nsg-spoke-workload"
  location            = azurerm_resource_group.groupe.location
  resource_group_name = azurerm_resource_group.groupe.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "spoke_workload" {
  subnet_id                 = azurerm_subnet.spoke_workload.id
  network_security_group_id = azurerm_network_security_group.spoke_workload.id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-spoke"
  resource_group_name          = azurerm_resource_group.groupe.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-spoke-to-hub"
  resource_group_name          = azurerm_resource_group.groupe.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
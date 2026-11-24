data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "groupe" {
  name     = "${var.env_prefix}-rg-vm-entra"
  location = var.location
  tags     = var.tags
}


resource "azurerm_virtual_network" "network" {
  name                = "${var.env_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.groupe.location
  resource_group_name = azurerm_resource_group.groupe.name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.env_prefix}-subnet-linux"
  resource_group_name  = azurerm_resource_group.groupe.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.env_prefix}-nsg"
  location            = azurerm_resource_group.groupe.location
  resource_group_name = azurerm_resource_group.groupe.name
  tags                = var.tags


  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.env_prefix}-pip-vm"
  location            = azurerm_resource_group.groupe.location
  resource_group_name = azurerm_resource_group.groupe.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.env_prefix}-nic-vm"
  location            = azurerm_resource_group.groupe.location
  resource_group_name = azurerm_resource_group.groupe.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.env_prefix}-vm-ubuntu"
  location                        = azurerm_resource_group.groupe.location
  resource_group_name             = azurerm_resource_group.groupe.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic.id]
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_virtual_machine_extension" "aad_ssh_login" {
  name                       = "AADSSHLoginForLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.tags
}

resource "azurerm_role_assignment" "vm_admin_login" {
  scope                = azurerm_linux_virtual_machine.vm.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = data.azurerm_client_config.current.object_id
}
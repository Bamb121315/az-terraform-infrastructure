provider "azurerm" {
    backend "azurerm" {
    resource_group_name  = "tfstate-RG"          
    storage_account_name = "tfaccount524343422"
    container_name       = "tfstate"             
    key                  = "prod.terraform.tfstate" 
  }

    features {}
    }
    resource "azurerm_resource_group" "rg_stud" {
        name ="${var.env_prefix}-RG"
        location = var.location
        tags = var.tags
    }
    resource "azurerm_virtual_network" "siec" {
        name ="${var.env_prefix}-VNET"
        address_space = ["10.0.0.0/16"]
        location = var.location
        resource_group_name = azurerm_resource_group.rg_stud.name
        tags = var.tags
    }
    resource "azurerm_subnet" "podsiec" {
        name = "${var.env_prefix}-Subnet_linux"
        resource_group_name = azurerm_resource_group.rg_stud.name
        virtual_network_name = azurerm_virtual_network.siec.name
        address_prefixes = ["10.0.1.0/24"]
        tags = var.tags
    }
    resource "azurerm_network_interface" "karta" {
        name = "${var.env_prefix}-linux-NIC"
        location = var.location
        resource_group_name = azurerm_resource_group.rg_stud.name
        tags = var.tags

        ip_configuration {
            name = "${var.env_prefix}-internal"
            subnet_id = azurerm_subnet.podsiec.id
            private_ip_address_allocation = "Dynamic"
            public_ip_address_id = azurerm_public_ip.public_ip.id
        }
    }
    resource "azurerm_linux_virtual_machine" "maszyna" {
        name = "${var.env_prefix}-Ubuntu-VM"
        location = var.location
        resource_group_name = azurerm_resource_group.rg_stud.name
        size = var.vm_size
        admin_username = "student"
        disable_password_authentication = true
        network_interface_ids = [azurerm_network_interface.karta.id]
        tags = var.tags
        admin_ssh_key {
            username = "student"
            public_key = file("~/.ssh/id_rsa.pub")
        }
        os_disk {
            caching = "ReadWrite"
            storage_account_type = "Standard_LRS"
        }

        source_image_reference {
            publisher = "Canonical"
            offer = "0001-com-ubuntu-server-jammy"
            sku = "22_04-lts"
            version = "latest"
        }
    }

    resource "azurerm_public_ip" "public_ip" {
        name = "${var.env_prefix}-PublicIP"
        location = var.location
        resource_group_name = azurerm_resource_group.rg_stud.name
        tags = var.tags
        allocation_method = "Static"
        sku = "Standard"
    }

    resource "azurerm_network_security_group" "NSG" {
        name = "${var.env_prefix}-NSG"
        location = var.location
        resource_group_name = azurerm_resource_group.rg_stud.name
        tags = var.tags

        security_rule {
            name = "Allow-SSH"
        
        priority = 1000
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
        }
    }
    resource "azurerm_network_interface_security_group_association" "NSG_CARD" { 
        network_interface_id = azurerm_network_interface.karta.id
        network_security_group_id = azurerm_network_security_group.NSG.id
        tags = var.tags
    }
    
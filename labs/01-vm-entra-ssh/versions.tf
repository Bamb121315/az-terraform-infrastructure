terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-RG"
    storage_account_name = "tfaccount524343422"
    container_name       = "tfstate"
    key                  = "dev-vm-entra.terraform.tfstate"
  }
}
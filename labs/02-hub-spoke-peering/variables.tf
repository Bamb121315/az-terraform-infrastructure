variable "env_prefix" {
  description = "Environemnt prefix for naming Azure resources"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for the Hub-Spoke netwwork topology"
  type        = string
  default     = "westeurope"
}

variable "hub_address_space" {
  description = "CIDR block for the Hub Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "spoke_address_space" {
  description = "CIDR block for the Spoke Virtual Network"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "tags" {
  description = "Default tags applied to all taggable resources"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "Azure-Hub-Spoke"
    Managedby   = "Terraform"
  }
}
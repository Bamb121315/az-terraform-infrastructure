variable "env_prefix" {
  description = "Environment prefix"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "francecentral"
}

variable "vm_size" {
  description = "SKU size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Local fallback admin username"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key used for VM authentication"
  type        = string
}

variable "allowed_ssh" {
  description = "Trusted public IP allowed to connect over SSH"
  type        = string
}

variable "tags" {
  description = "Default tags applied to all taggable resources"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "Azure-Entra-VM"
    ManagedBy   = "Terraform"
  }
}
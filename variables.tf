variable "env_prefix" {
  description = "Prefiks dla nazw zasobów"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Lokalizacja Azure"
  type        = string
  default     = "francecentral"
}

variable "vm_size" {
  description = "Rozmiar VM"
  type        = string
  default     = "Standard_B1s"
}

variable "tags" {
  description = "Tagowanie infrastruktury"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "Project-AZ"
    ManagedBy   = "Terraform"

  }
}
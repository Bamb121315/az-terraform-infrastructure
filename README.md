# Azure Terraform Labs

Hands-on Infrastructure as Code (IaC) labs for Microsoft Azure using **Terraform (`>= 1.6.0`, `azurerm ~> 4.0`)**, remote state in Azure Storage, and **GitHub Actions** CI.

## Labs

- **`labs/01-vm-entra-ssh`** — Ubuntu 22.04 VM with password auth disabled, subnet-level NSG restricting SSH (`TCP/22`) to a single IP/CIDR, System-Assigned Managed Identity, `AADSSHLoginForLinux` extension, and automatic RBAC (`Virtual Machine Administrator Login`) assignment.
- **`labs/02-hub-spoke-peering`** — Hub-and-Spoke VNet topology (`10.0.0.0/16` + `10.1.0.0/16`) with a `GatewaySubnet`, spoke workload subnet + NSG, and bi-directional VNet peering (`allow_forwarded_traffic` enabled).

## CI/CD

Every push and PR to `main` runs `.github/workflows/terraform.yaml`:
- `terraform fmt -check`, `init -backend=false`, and `validate` across all labs (matrix job)
- **Trivy** IaC misconfiguration scan (`HIGH` / `CRITICAL`)

## Quick Start

```bash
# Lab 01 (requires local terraform.tfvars)
cd labs/01-vm-entra-ssh
cp terraform.tfvars.example terraform.tfvars
# fill in your IP (/32) and SSH public key

terraform init
terraform plan
terraform apply
```

```bash
# Connect via Entra ID SSH
az ssh vm --ip <vm_public_ip>
```

*Note: Lab 01 uses a Public IP locked down to `/32` instead of Azure Bastion to keep Azure for Students costs low.*
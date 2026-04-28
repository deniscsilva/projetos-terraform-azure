# Terraform Dynamic Block Linux - Advanced Infrastructure Automation

Advanced Terraform project for provisioning multiple Azure Linux Virtual Machines with dynamic configuration blocks. This project demonstrates sophisticated Terraform patterns including dynamic blocks, for_each loops, and complex variable structures.

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Key Features](#key-features)
- [Project Structure](#project-structure)
- [Module Details](#module-details)
- [Variables Reference](#variables-reference)
- [Getting Started](#getting-started)
- [Usage Examples](#usage-examples)
- [Dynamic Blocks Explained](#dynamic-blocks-explained)
- [Outputs](#outputs)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)
- [Advanced Patterns](#advanced-patterns)
- [Cleanup](#cleanup)

## 🎯 Project Overview

This Terraform project demonstrates advanced infrastructure automation for Azure Linux Virtual Machines using:
- **Dynamic Blocks** - Flexible NSG security rules configuration
- **for_each Loops** - Multi-VM provisioning with unique configurations
- **Map Objects** - Complex variable structures for VM configurations
- **Data Sources** - Integration with Azure Key Vault for secrets
- **Remote State** - Azure Storage Account backend for collaboration
- **Modular Architecture** - Reusable vm-linux module

**Target Use Case:** Multi-environment deployments, scalable Linux infrastructure, complex networking scenarios.

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│              Azure Resource Group                        │
│         (rg-dcs-linux-02 - eastus/westus)              │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  ┌────────────────────────────────────────────────────┐ │
│  │    Virtual Network (dcs-lnx2-vnet)                │ │
│  │    Address Space: 10.0.0.0/16                     │ │
│  ├────────────────────────────────────────────────────┤ │
│  │                                                    │ │
│  │  For Each VM in vms_config:                       │ │
│  │  ├─ Subnet (dcs-lnx2-subnet-vm1, vm2, etc)      │ │
│  │  ├─ NSG (dcs-lnx2-nsg-vm1, vm2, etc)            │ │
│  │  │  └─ Dynamic Security Rules (SSH/HTTP/HTTPS)  │ │
│  │  ├─ Public IP (dcs-lnx2-pip-vm1, vm2, etc)      │ │
│  │  ├─ Network Interface (dcs-lnx2-nic-vm1, etc)   │ │
│  │  └─ Linux VM (dcs-lnx2-vm-vm1, vm2, etc)        │ │
│  │     ├─ OS: Ubuntu 22.04 LTS                       │ │
│  │     ├─ Admin User: adminuser                      │ │
│  │     └─ Password: From Azure Key Vault             │ │
│  │                                                    │ │
│  └────────────────────────────────────────────────────┘ │
│                                                           │
│  ┌─────────────────────────────────────────────────────┐ │
│  │   Azure Key Vault (kv-dcs-01)                      │ │
│  │   Secret: dcs-secret (VM admin password)          │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

## 📦 Prerequisites

### Required Tools
- **Terraform** >= 1.0.0
- **Azure CLI** >= 2.40.0
- **jq** (for JSON processing, optional)

### Azure Setup
- Active Azure subscription
- Azure Key Vault with secret (kv-dcs-01/dcs-secret)
- Contributor or Owner role at subscription level

### Authentication
```bash
az login
az account set --subscription <SUBSCRIPTION_ID>
```

## ✨ Key Features

### 1. **Dynamic Security Rules**
Terraform dynamic blocks create NSG rules from a list:
```hcl
dynamic "security_rule" {
  for_each = var.security_rules
  content {
    name = security_rule.value.name
    priority = security_rule.value.priority
    # ... other properties
  }
}
```

### 2. **Multi-VM Deployment**
Deploy multiple VMs with unique configurations using for_each:
```hcl
for_each = var.vms_config
name = "${var.virtual_machine_name_prefix}-${each.key}"
```

### 3. **Subnet Isolation**
Each VM gets its own subnet with isolated CIDR blocks:
```hcl
vms_config = {
  vm1 = { subnet_cidr = "10.0.1.0/24" }
  vm2 = { subnet_cidr = "10.0.2.0/24" }
}
```

### 4. **Azure Key Vault Integration**
Passwords retrieved from Key Vault for secure management:
```hcl
data "azurerm_key_vault_secret" "vm_password" {
  name = "dcs-secret"
  key_vault_id = data.azurerm_key_vault.dcs_keyvault.id
}
```

### 5. **Flexible Network Configuration**
Easily modify security rules and network settings:
```hcl
security_rules = [
  { name = "SSH", destination_port_range = "22", ... },
  { name = "HTTP", destination_port_range = "80", ... },
  { name = "HTTPS", destination_port_range = "443", ... }
]
```

## 📁 Project Structure

```
terraform-dynamic-block-linux/
├── README.md                          # This file
├── main.tf                            # Root module orchestration
├── variables.tf                       # Root module input variables
├── output.tf                          # Root module outputs
├── provider.tf                        # Azure provider configuration
│
└── vm-linux/                          # VM Module
    ├── main.tf                        # VM resources (for_each, dynamic)
    ├── variables.tf                   # Module variables
    ├── output.tf                      # Module outputs
    └── .gitignore                     # Terraform ignore patterns
```

## 📚 Module Details

### vm-linux Module

**Purpose:** Provisions multiple Linux VMs with dynamic networking and security configurations.

**Key Resources:**
- `azurerm_resource_group` - Container for all resources
- `azurerm_virtual_network` - Network infrastructure
- `azurerm_subnet` - Subnet (for_each - one per VM)
- `azurerm_network_security_group` - NSG (for_each - one per VM)
- `azurerm_public_ip` - Public IP (for_each - one per VM)
- `azurerm_network_interface` - NIC (for_each - one per VM)
- `azurerm_linux_virtual_machine` - Linux VMs (for_each)
- Data source: `azurerm_key_vault` - Retrieve secrets
- Data source: `azurerm_key_vault_secret` - Get VM password

**Module Variables:**

| Variable | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| `location` | string | - | ✅ Yes | Azure region (eastus, westus, etc.) |
| `vms_config` | map(object) | - | ✅ Yes | VM configurations with subnet CIDR |
| `resource_group_name` | string | rg-dcs-linux-02 | No | RG name |
| `virtual_network_name` | string | dcs-lnx2-vnet | No | VNet name |
| `subnet_name_prefix` | string | dcs-lnx2-subnet | No | Subnet prefix |
| `network_security_group_name_prefix` | string | dcs-lnx2-nsg | No | NSG prefix |
| `public_ip_name_prefix` | string | dcs-lnx2-pip | No | Public IP prefix |
| `network_interface_name_prefix` | string | dcs-lnx2-nic | No | NIC prefix |
| `virtual_machine_name_prefix` | string | dcs-lnx2-vm | No | VM prefix |
| `vnet_address_space` | list(string) | ["10.0.0.0/16"] | No | VNet CIDR |
| `security_rules` | list(object) | SSH/HTTP/HTTPS | No | NSG rules |

**Module Outputs:**

| Output | Description |
|--------|-------------|
| `public_ips` | Map of VM names to public IP addresses |

## 🎛️ Variables Reference

### Root Module Variables (terraform-dynamic-block-linux/variables.tf)

#### Required Variables

**`location`**
```hcl
variable "location" {
  type        = string
  description = "Azure region where resources are created"
  # Example: "eastus", "westus", "northeurope"
}
```

**`vms_config`**
```hcl
variable "vms_config" {
  type = map(object({
    subnet_cidr = string
  }))
  description = "Map of VM names to configurations"
  # Example:
  # {
  #   vm1 = { subnet_cidr = "10.0.1.0/24" }
  #   vm2 = { subnet_cidr = "10.0.2.0/24" }
  # }
}
```

#### Optional Variables with Defaults

**`security_rules`** - NSG rules applied to all VMs
```hcl
variable "security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string      # "Inbound" or "Outbound"
    access                     = string      # "Allow" or "Deny"
    protocol                   = string      # "Tcp", "Udp", "*"
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  
  default = [
    {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTPS"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
```

## 🚀 Getting Started

### Step 1: Clone Repository
```bash
git clone https://github.com/deniscsilva/projetos-terraform-azure.git
cd projetos-terraform-azure/terraform-dynamic-block-linux
```

### Step 2: Create terraform.tfvars
```hcl
cat > terraform.tfvars << 'EOF'
location = "eastus"

vms_config = {
  app = {
    subnet_cidr = "10.0.1.0/24"
  }
  database = {
    subnet_cidr = "10.0.2.0/24"
  }
  cache = {
    subnet_cidr = "10.0.3.0/24"
  }
}

# Optional: Override defaults
resource_group_name = "rg-dcs-linux-prod"
virtual_network_name = "dcs-lnx-prod-vnet"

# Optional: Add additional security rules
security_rules = [
  {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "203.0.113.0/24"  # Restrict to your IP
    destination_address_prefix = "*"
  },
  {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "HTTPS"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]
EOF
```

### Step 3: Initialize Terraform
```bash
tf init
```

### Step 4: Validate Configuration
```bash
tf validate
```

### Step 5: Plan Deployment
```bash
tf plan -out=tfplan
```

### Step 6: Apply Configuration
```bash
tf apply tfplan
```

### Step 7: Retrieve Outputs
```bash
tf output public_ips
```

## 📝 Usage Examples

### Example 1: Deploy 3 VMs in Different Subnets
```bash
cat > terraform.tfvars << EOF
location = "eastus"

vms_config = {
  web = {
    subnet_cidr = "10.0.10.0/24"
  }
  app = {
    subnet_cidr = "10.0.20.0/24"
  }
  db = {
    subnet_cidr = "10.0.30.0/24"
  }
}
EOF

tf apply
```

### Example 2: Deploy with Custom Security Rules
```bash
cat > terraform.tfvars << EOF
location = "westus"

vms_config = {
  prod-web-1 = { subnet_cidr = "10.0.1.0/24" }
  prod-web-2 = { subnet_cidr = "10.0.2.0/24" }
}

# Custom security rules
security_rules = [
  {
    name                       = "SSH-RESTRICTED"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/8"      # Internal only
    destination_address_prefix = "*"
  },
  {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "HTTPS"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]
EOF

tf apply
```

### Example 3: Add New VM After Initial Deployment
```bash
# Update terraform.tfvars
vms_config = {
  app = { subnet_cidr = "10.0.1.0/24" }
  database = { subnet_cidr = "10.0.2.0/24" }
  cache = { subnet_cidr = "10.0.3.0/24" }  # New!
  monitoring = { subnet_cidr = "10.0.4.0/24" }  # New!
}

# Plan changes
tf plan

# Apply only new resources
tf apply
```

### Example 4: Access VM via SSH
```bash
# Get public IPs
PUBLIC_IPS=$(tf output -json public_ips)

# SSH to app VM
ssh -i ~/.ssh/id_rsa adminuser@$(echo $PUBLIC_IPS | jq -r '.app')

# Or use password (stored in Key Vault)
ssh adminuser@<PUBLIC_IP>
```

## 🔄 Dynamic Blocks Explained

### Understanding Dynamic Blocks

Dynamic blocks generate Terraform blocks based on variable values:

```hcl
# Input variable
security_rules = [
  { name = "SSH", destination_port_range = "22", ... },
  { name = "HTTP", destination_port_range = "80", ... }
]

# Dynamic block generates security_rule blocks
dynamic "security_rule" {
  for_each = var.security_rules
  content {
    name = security_rule.value.name
    destination_port_range = security_rule.value.destination_port_range
    # ... other properties
  }
}
```

**Result:** 2 security_rule blocks created automatically without hardcoding!

### Advantages
- **Flexibility:** Add/remove rules by updating variables
- **DRY:** Don't repeat yourself - single rule definition
- **Maintainability:** Changes in one place
- **Scalability:** Handle hundreds of rules easily

## 📊 Outputs

### Retrieve Outputs

```bash
# All outputs
tf output

# Specific output (JSON)
tf output -json public_ips

# Specific output (raw)
tf output -raw public_ips
```

### Output Structure

```json
{
  "public_ips": {
    "app": "20.85.123.45",
    "database": "20.85.123.46",
    "cache": "20.85.123.47"
  }
}
```

### Using Outputs in Scripts

```bash
# Save to file
tf output -raw public_ips > ips.json

# Parse with jq
APP_IP=$(tf output -json public_ips | jq -r '.app')
echo "App VM IP: $APP_IP"

# Loop through all IPs
tf output -json public_ips | jq '.[] | .[]' | while read ip; do
  echo "Pinging $ip..."
  ping -c 1 $ip
done
```

## 🔒 Security Considerations

### 1. **Password Management**
```hcl
# ✅ Good: Use Key Vault
admin_password = data.azurerm_key_vault_secret.vm_password.value

# ❌ Bad: Hardcoded password
admin_password = "MyPassword123!"
```

### 2. **SSH Key Authentication**
```hcl
# ✅ Recommended: Use SSH keys instead of passwords
admin_ssh_key {
  username   = "adminuser"
  public_key = file("~/.ssh/id_rsa.pub")
}
disable_password_authentication = true

# ❌ Avoid: Password-only authentication
disable_password_authentication = false
```

### 3. **Network Security**
```hcl
# ✅ Good: Restrict SSH to known IPs
{
  name                       = "SSH"
  destination_port_range     = "22"
  source_address_prefix      = "203.0.113.0/24"  # Your office IP
  access                     = "Allow"
}

# ❌ Bad: Allow SSH from anywhere
source_address_prefix = "*"
```

### 4. **Resource Tagging**
```hcl
tags = {
  environment = "production"
  managed_by  = "terraform"
  cost_center = "engineering"
}
```

### 5. **State File Security**
- Use remote state (Azure Storage Account)
- Enable encryption at rest
- Restrict access via IAM roles
- Enable versioning for recovery

## 🔧 Troubleshooting

### Issue 1: Key Vault Secret Not Found
**Error:** `Error: retrieving secret "dcs-secret" from Azure Key Vault`

**Solution:**
```bash
# Verify key vault exists
az keyvault show --name kv-dcs-01

# Verify secret exists
az keyvault secret show --vault-name kv-dcs-01 --name dcs-secret

# Update main.tf with correct names
```

---

### Issue 2: Subnet CIDR Overlap
**Error:** `Error: the provided CIDR does not match the configured address prefix`

**Solution:** Ensure subnet CIDRs don't overlap:
```hcl
# ✅ Good: Non-overlapping
vms_config = {
  vm1 = { subnet_cidr = "10.0.1.0/24" }    # 10.0.1.0 - 10.0.1.255
  vm2 = { subnet_cidr = "10.0.2.0/24" }    # 10.0.2.0 - 10.0.2.255
}

# ❌ Bad: Overlapping
vms_config = {
  vm1 = { subnet_cidr = "10.0.1.0/24" }
  vm2 = { subnet_cidr = "10.0.1.128/25" }  # Overlaps!
}
```

---

### Issue 3: Permission Denied When Creating VMs
**Error:** `Error: Code="AuthorizationFailed" `

**Solution:**
```bash
# Check current user permissions
az role assignment list --assignee $(az account show --query user.name -o tsv)

# Ensure Contributor role
az role assignment create --assignee <USER_EMAIL> \
  --role "Contributor" \
  --scope /subscriptions/<SUBSCRIPTION_ID>
```

---

### Issue 4: for_each Index Out of Range
**Error:** `Error: Resource instance index out of range`

**Solution:** Ensure vms_config is properly defined:
```bash
# Validate variables
tf validate

# Check vms_config format
tf plan | grep -A5 vms_config
```

---

### Issue 5: Dynamic Block Not Creating Rules
**Error:** No security rules applied to NSG

**Solution:** Verify dynamic block syntax:
```hcl
# ✅ Correct syntax
dynamic "security_rule" {
  for_each = var.security_rules
  content {
    name = security_rule.value.name
    # ...
  }
}

# Check that var.security_rules is not empty
tf console
> var.security_rules
```

## 🎓 Advanced Patterns

### Pattern 1: Conditional Resource Creation
```hcl
# Only create if tier is "prod"
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = {
    for k, v in var.vms_config : k => v
    if v.tier == "prod"
  }
  # ...
}
```

### Pattern 2: Cross-VM Networking
```hcl
# Reference another VM's NIC
resource "azurerm_network_interface_backend_address_pool_association" "nics" {
  for_each = azurerm_network_interface.nic
  # ...
}
```

### Pattern 3: Bulk Output Generation
```hcl
output "vm_details" {
  value = {
    for vm_name, vm in azurerm_linux_virtual_machine.vm : vm_name => {
      id         = vm.id
      private_ip = vm.private_ip_address
      public_ip  = azurerm_public_ip.pip[vm_name].ip_address
    }
  }
}
```

## 🧹 Cleanup

### Destroy All Resources
```bash
tf destroy
```

### Destroy Specific Resources
```bash
# Destroy specific VM
tf destroy -target='module.vm_linux.azurerm_linux_virtual_machine.vm["app"]'

# Destroy multiple resources
tf destroy -target='azurerm_resource_group.rg'
```

### Backup Before Cleanup
```bash
cp terraform.tfstate terraform.tfstate.backup
tf destroy
```

## 📚 Additional Resources

- [Terraform Dynamic Blocks](https://www.terraform.io/docs/language/expressions/dynamic)
- [Terraform for_each](https://www.terraform.io/docs/language/meta-arguments/for_each)
- [Azure Terraform Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure Linux VMs](https://docs.microsoft.com/azure/virtual-machines/linux/)
- [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/)

## 🤝 Contributing

Contributions welcome! Please:
1. Fork repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📄 License

Open source project for learning and development.

## ⚠️ Important Notes

- **Cost:** Monitor Azure resource costs regularly
- **Security:** Never commit sensitive data to version control
- **State:** Use remote state for team collaboration
- **Validation:** Always run `tf plan` before `apply`

---

**Last Updated:** 2026-04-28 19:49:50  
**Terraform Version:** >= 1.0.0  
**Azure Provider Version:** 4.37.0  
**Author:** @deniscsilva

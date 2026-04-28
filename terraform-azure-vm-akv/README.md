# Terraform Azure VM AKV

## Project Description
This project provides Terraform configurations to deploy Azure Virtual Machines with Azure Key Vault integration. It aims to simplify the provisioning and management of Azure resources while enhancing security practices through the use of Azure Key Vault.

## Architecture Overview
The architecture consists of Azure Virtual Machines (VMs) provisioned within a specified resource group, leveraging Azure Key Vault for secure storage of secrets, keys, and certificates. The following components are included:
- Azure Subscription
- Resource Group
- Virtual Network
- Subnet
- Network Interface
- Azure VM
- Azure Key Vault

## Prerequisites
- An Azure account with an active subscription.
- Terraform installed (version 1.0 or higher).
- Basic understanding of Azure and Terraform.

## Module Structure
The project is structured into modules for better code organization and reusability. Key modules include:
- `network` - Manages networking components like VNet and Subnet.
- `vm` - Manages the provisioning of Azure Virtual Machines.
- `keyvault` - Configures Azure Key Vault and its access policies.

## Variables
The following variables are configurable:
- `location` - Azure region where resources will be deployed.
- `vm_name` - Name of the Azure Virtual Machine.
- `admin_username` - Username for the VM administrator.
- `admin_password` - Password for the VM administrator. (Consider using Key Vault for sensitive data)

## Usage Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/deniscsilva/projetos-terraform-azure.git
   cd projetos-terraform-azure/terraform-azure-vm-akv
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Plan the deployment:
   ```bash
   terraform plan
   ```
4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Outputs
After a successful deployment, the following outputs will be available:
- `vm_public_ip` - Public IP address of the deployed VM.
- `keyvault_uri` - URI of the created Azure Key Vault.

## Troubleshooting
- Ensure that your Azure subscription has enough quota for the resources you are deploying.
- Check Azure portal for resource group and resource status if the deployment fails.
- Validate inputs in variables.tf for incorrect configurations.

For further assistance, refer to the [Terraform documentation](https://www.terraform.io/docs/index.html) and Azure documentation.
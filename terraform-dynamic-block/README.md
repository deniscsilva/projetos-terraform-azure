# Terraform Dynamic Block

## Overview
The `terraform-dynamic-block` project demonstrates how to effectively use dynamic blocks in Terraform. Dynamic blocks allow you to construct multiple instances of a single block within configuration, enabling greater flexibility and reusability of code.

## Prerequisites
- Terraform 1.x or later.
- An Azure account with appropriate permissions to create resources.

## Usage
This project contains several examples of using dynamic blocks in Terraform configurations. To get started:

1. Clone the repository:
   ```bash
   git clone https://github.com/deniscsilva/projetos-terraform-azure.git
   cd projetos-terraform-azure/terraform-dynamic-block
   ```

2. Review the example Terraform configuration files to understand how dynamic blocks have been implemented.

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan your deployment:
   ```bash
   terraform plan
   ```

5. Apply your deployment:
   ```bash
   terraform apply
   ```

## Dynamic Block Example
Here is a basic example of a dynamic block in use:
```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
  
  dynamic "network_rules" {
    for_each = var.network_rules
    content {
      ip_rule {
        value = network_rules.value
      }
    }
  }
}
```

## Variables
The following variables are defined in the project:
- `network_rules`: A list of network rules to apply to the storage account.

## Contributing
Contributions are welcome! Please fork the repository and create a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
# Data Block
data "azurerm_resource_group" "rg-portal" {
  name = "rg-teste3"
}

# Local Variables
locals {
  storage_account_sku = "Standard"
}

# Resource Block
resource "azurerm_storage_account" "primeiro_sa" {
  name                     = "saopaulo${random_string.random.result}"
  resource_group_name      = data.azurerm_resource_group.rg-portal.name
  location                 = data.azurerm_resource_group.rg-portal.location
  account_tier             = local.storage_account_sku
  account_replication_type = var.account_replication_type

  tags = {
    environment = "staging"
  }
}

# Variable Block
variable "account_replication_type" {
  description = "Tipo de replica da storage account"
  type        = string
  default     = "GRS"
}

# Output Block
output "storage_account_id" {
  value = azurerm_storage_account.primeiro_sa.id
}

# Random Block
resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}
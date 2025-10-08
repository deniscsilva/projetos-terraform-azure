
# Import do resource group
resource "azurerm_resource_group" "rg_import" {
  name     = "rg_teste"
  location = "eastus"
  tags = {
    import = "OK"
    teste  = "YES"
  }
}

output "name" {
  value = azurerm_resource_group.rg_import.name
}

output "location" {
  value = azurerm_resource_group.rg_import.location
}

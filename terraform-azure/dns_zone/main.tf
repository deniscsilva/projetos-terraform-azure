# Criar o bloco de resouce (DNS Zone)
resource "azurerm_dns_zone" "dns-zone" {
  name                = var.dns_name
  resource_group_name = var.rg_name
  tags = {
    state  = "lock"
    remote = "true"
  }
}


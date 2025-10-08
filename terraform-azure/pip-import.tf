# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "/subscriptions/28983f48-30eb-4931-acde-6a65b5b3fbe6/resourceGroups/rg-teste/providers/Microsoft.Network/publicIPAddresses/PIPimport"
resource "azurerm_public_ip" "pip-import" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  ddos_protection_plan_id = null
  domain_name_label       = null
  domain_name_label_scope = null
  edge_zone               = null
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = module.rg_import.location
  name                    = "PIPimport"
  public_ip_prefix_id     = null
  resource_group_name     = module.rg_import.name
  reverse_fqdn            = null
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags = {
    ENV      = "HML"
    MANAGER  = "DCS"
    FUNCIONA = "Y"
  }
  zones = ["1", "2", "3"]
}

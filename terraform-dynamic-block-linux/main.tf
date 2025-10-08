terraform {
  backend "azurerm" {
    resource_group_name  = "rg-state-remote"
    storage_account_name = "dcsterraformbackend"
    container_name       = "state-backend"
    key                  = "terraform4.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
}

module "vm_linux" {
  source                             = "./vm-linux"
  location                           = var.location
  vms_config                         = var.vms_config
  resource_group_name                = var.resource_group_name
  virtual_network_name               = var.virtual_network_name
  subnet_name_prefix                 = var.subnet_name_prefix
  network_security_group_name_prefix = var.network_security_group_name_prefix
  public_ip_name_prefix              = var.public_ip_name_prefix
  network_interface_name_prefix      = var.network_interface_name_prefix
  virtual_machine_name_prefix        = var.virtual_machine_name_prefix
  vnet_address_space                 = var.vnet_address_space
  security_rules                     = var.security_rules
}

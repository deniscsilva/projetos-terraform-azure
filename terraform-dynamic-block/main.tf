# Setting Block
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-state-remote"
    storage_account_name = "dcsterraformbackend"
    container_name       = "state-backend"
    key                  = "terraform3.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
}

module "vm_win" {
  source = "./vm-win"

  rg_name      = var.rg_name
  rg_location  = var.rg_location
  nsg_name     = var.nsg_name
  nsg_rules    = var.nsg_rules
  vnet_name    = var.vnet_name
  cidr_win     = var.cidr_win
  snet_name    = var.snet_name
  snet_cidr    = var.snet_cidr
  nic_name     = var.nic_name
  pip_win      = var.pip_win
  vm_win_name  = var.vm_win_name
  sku_size     = var.sku_size
  hostname_win = var.hostname_win
}
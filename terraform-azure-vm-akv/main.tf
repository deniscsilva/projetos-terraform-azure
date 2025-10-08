# Setting Block
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-state-remote"
    storage_account_name = "dcsterraformbackend"
    container_name       = "state-backend"
    key                  = "terraform2.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
}

module "vm-linux" {
  source = "./vm-linux"

  keyvault_name        = var.keyvault_name
  rg_kv                = var.rg_kv
  keyvault_value_name  = var.keyvault_value_name
  rg_name              = var.rg_name
  location             = var.location
  vnet_name            = var.vnet_name
  cidr_block           = var.cidr_block
  snet_name            = var.snet_name
  subnet               = var.subnet
  nic_name             = var.nic_name
  ip_configuration     = var.ip_configuration
  type_allocation      = var.type_allocation
  publicip_name        = var.publicip_name
  allocation_method    = var.allocation_method
  vm_name              = var.vm_name
  size_vm              = var.size_vm
  admin_user           = var.admin_user
  caching_rw           = var.caching_rw
  storage_account_type = var.storage_account_type
  publisher            = var.publisher
  offer                = var.offer
  sku                  = var.sku
  image_version        = var.image_version
  nsg_name             = var.nsg_name
}
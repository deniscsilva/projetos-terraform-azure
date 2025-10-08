# Setting Block
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-state-remote"
    storage_account_name = "dcsterraformbackend"
    container_name       = "state-backend"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

# Modulo Block - Chamando módulo
module "sa_modulo" {
  source = "./storage_account"
}

# Output Block
output "storage_account_id" {
  value = module.sa_modulo.storage_account_id
}

#Modelo Resource Group
module "rg_import" {
  source = "./resource_group"
}

#Module DNS Zone
module "dns_zone_module" {
  source   = "./dns_zone"
  dns_name = "tfteclab.com.br"
  rg_name  = module.rg_import.rg_name_import
}

#Terraform Output Values Block DNS
output "dns_id" {
  value = module.dns_zone_module.dns_id
}

module "rg_sqlserver" {
  source = "./rg_sqlserver"
}

module "sqlserver_module" {
  source      = "./sqlserver"
  sql_name    = var.sql_name
  rg_name     = module.rg_sqlserver.rg_name_sqlserver
  rg_location = module.rg_sqlserver.rg_location_sqlserver
  sql_version = var.sql_version
  sql_admin   = var.sql_admin
  sql_pass    = var.sql_pass
}

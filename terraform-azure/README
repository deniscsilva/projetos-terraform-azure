# Terraform Azure Project

This repository contains Terraform scripts to manage Azure resources. This documentation covers comprehensive details about the various modules included in the project.

## Table of Contents
1. [Resource Group Module](#resource-group-module)
2. [Storage Account Module](#storage-account-module)
3. [DNS Zone Module](#dns-zone-module)
4. [SQL Server Module](#sql-server-module)

## Resource Group Module

### Overview
The Resource Group module creates and manages a resource group in Azure.

### Usage
```hcl
module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location           = var.location
}
```

### Inputs
| Name                  | Description                     | Type     | Default    | Required |
|-----------------------|---------------------------------|----------|------------|----------|
| `resource_group_name` | The name of the resource group | `string` | n/a        | yes      |
| `location`           | The Azure region for the group | `string` | `eastus`   | no       |

### Outputs
| Name                   | Description                      |
|------------------------|----------------------------------|
| `resource_group_id`   | The ID of the created resource group |

## Storage Account Module

### Overview
The Storage Account module provisions a storage account in Azure.

### Usage
```hcl
module "storage_account" {
  source                 = "./modules/storage_account"
  storage_account_name    = var.storage_account_name
  resource_group_name    = var.resource_group_name
  location              = var.location
}
```

### Inputs
| Name                       | Description                         | Type     | Default    | Required |
|----------------------------|-------------------------------------|----------|------------|----------|
| `storage_account_name`     | The name of the storage account    | `string` | n/a        | yes      |
| `resource_group_name`      | The name of the resource group     | `string` | n/a        | yes      |
| `location`                | The Azure region for the account   | `string` | `eastus`   | no       |

### Outputs
| Name                     | Description                        |
|--------------------------|------------------------------------|
| `storage_account_id`     | The ID of the created storage account |

## DNS Zone Module

### Overview
The DNS Zone module manages DNS zones in Azure.

### Usage
```hcl
module "dns_zone" {
  source           = "./modules/dns_zone"
  dns_zone_name    = var.dns_zone_name
  resource_group_name = var.resource_group_name
}
```

### Inputs
| Name                   | Description                            | Type     | Default      | Required |
|------------------------|----------------------------------------|----------|--------------|----------|
| `dns_zone_name`       | The name of the DNS zone              | `string` | n/a          | yes      |
| `resource_group_name`  | The name of the resource group        | `string` | n/a          | yes      |

### Outputs
| Name                   | Description                           |
|------------------------|---------------------------------------|
| `dns_zone_id`         | The ID of the created DNS zone       |

## SQL Server Module

### Overview
The SQL Server module provisions a SQL server in Azure.

### Usage
```hcl
module "sql_server" {
  source               = "./modules/sql_server"
  sql_server_name       = var.sql_server_name
  resource_group_name   = var.resource_group_name
  location            = var.location
  administrator_login  = var.administrator_login
  administrator_login_password = var.administrator_login_password
}
```

### Inputs
| Name                       | Description                           | Type     | Default      | Required |
|----------------------------|---------------------------------------|----------|--------------|----------|
| `sql_server_name`         | The name of the SQL server            | `string` | n/a          | yes      |
| `resource_group_name`     | The name of the resource group        | `string` | n/a          | yes      |
| `location`                | The Azure region for the server       | `string` | `eastus`     | no       |
| `administrator_login`      | The administrator login for the server| `string` | n/a          | yes      |
| `administrator_login_password` | Password for the administrator login | `string` | n/a          | yes      |

### Outputs
| Name                       | Description                              |
|----------------------------|------------------------------------------|
| `sql_server_id`           | The ID of the created SQL server        |

variable "sql_name" {
  description = "Nome do banco de dados sql-server"
  type        = string
}

variable "rg_name" {
  description = "Nome do resource group"
  type        = string
}

variable "rg_location" {
  description = "Região do recurso"
  type        = string
}

variable "sql_version" {
  description = "Versão do banco de dados sql-server"
  type        = string
}

variable "sql_admin" {
  description = "Admin do banco de dados"
  type        = string
  sensitive   = true
}

variable "sql_pass" {
  description = "Password do banco de dados"
  type        = string
  sensitive   = true
}
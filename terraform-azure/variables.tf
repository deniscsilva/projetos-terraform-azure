variable "sql_name" {
  description = "Nome do banco sql-server"
  type        = string
}

variable "sql_version" {
  description = "NVersão do banco de dados"
  type        = string
}

variable "sql_admin" {
  description = " User admin do banco de dados"
  type        = string
  sensitive   = true
}

variable "sql_pass" {
  description = " Password do banco de dados"
  type        = string
  sensitive   = true
}
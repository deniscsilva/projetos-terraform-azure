output "sql_admin_user" {
  value     = azurerm_mssql_server.sql-server.administrator_login
  sensitive = true
}

output "sql_admin_pass" {
  value     = azurerm_mssql_server.sql-server.administrator_login_password
  sensitive = true
}
output "sql_admin_user" {
  value     = module.sqlserver_module.sql_admin_user
  sensitive = true
}

output "sql_admin_pass" {
  value     = module.sqlserver_module.sql_admin_pass
  sensitive = true
}
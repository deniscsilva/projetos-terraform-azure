
output "public_ips" {
  description = "The public IP addresses of the virtual machines"
  value       = { for vm_name, pip in azurerm_public_ip.pip : vm_name => pip.ip_address }
}


output "public_ips" {
  description = "The public IP addresses of the virtual machines"
  value       = module.vm_linux.public_ips
}

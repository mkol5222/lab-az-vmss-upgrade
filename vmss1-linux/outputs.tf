output "linux_vm_name" {
  description = "Name of the Ubuntu diagnostics VM"
  value       = azurerm_linux_virtual_machine.linux.name
}

output "linux_public_ip" {
  description = "Public IP for SSH access to the diagnostics VM"
  value       = azurerm_public_ip.linux.ip_address
}

output "linux_private_ip" {
  description = "Private IP of the diagnostics VM in linux-subnet"
  value       = azurerm_network_interface.linux.private_ip_address
}

output "linux_admin_username" {
  description = "Admin username for SSH"
  value       = local.admin_username
}

output "workstation_ip" {
  description = "Sensed public IP of the DevOps workstation (added as /32 Internet route)"
  value       = local.workstation_ip
}

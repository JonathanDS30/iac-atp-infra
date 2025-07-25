# ==============================================================================
# OUTPUT VALUES
# ==============================================================================
# This file defines the output values that will be returned
# after the VM is successfully created.

output "vm_id" {
  description = "The ID of the created container"
  value       = proxmox_virtual_environment_container.debian_container.id
}

output "ip" {
  description = "The IP address of the container"
  value       = var.ip_address
}

output "name" {
  description = "The name of the container"
  value       = var.hostname
}

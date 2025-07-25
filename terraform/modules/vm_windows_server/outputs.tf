# ==============================================================================
# OUTPUT VALUES
# ==============================================================================
# This file defines the output values that will be returned
# after the VM is successfully created.

output "vm_id" {
  description = "The ID of the created virtual machine"
  value       = proxmox_virtual_environment_vm.vm_windows_server.id
}

output "ip" {
  description = "The IP address of the virtual machine"
  value       = var.ip_address
}

output "name" {
  description = "The name of the virtual machine"
  value       = var.vm_name
}

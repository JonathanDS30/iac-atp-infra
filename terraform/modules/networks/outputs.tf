# ==============================================================================
# OUTPUT VALUES
# ==============================================================================
# This file defines the output values that will be returned
# after the VM is successfully created.

output "network_interface_name" {
  description = "The name of the network interface"
  value       = var.network_interface_name
}

output "address" {
  description = "The IPv4/CIDR address assigned to the network interface"
  value       = var.address
}

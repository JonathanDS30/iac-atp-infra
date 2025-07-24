# ==============================================================================
# NETWORK CONFIGURATION VARIABLES
# ==============================================================================

# ------------------------------------------------------------------------------
# General Settings
# ------------------------------------------------------------------------------

variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "network_interface_name" {
  description = "Name of the network interface"
  type        = string

  validation {
    condition     = length(var.network_interface_name) <= 10
    error_message = "The network interface name must be 10 characters or fewer."
  }
}

variable "autostart_network_interfaces" {
  description = "Start network interfaces automatically on boot"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Network Configuration
# ------------------------------------------------------------------------------

variable "address" {
  description = "IPv4/CIDR address for the network interface"
  type        = string
}

variable "comment" {
  description = "Comment for the network interface"
  type        = string
  default     = ""
}
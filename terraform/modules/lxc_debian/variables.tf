# ==============================================================================
# LXC CONTAINER CONFIGURATION VARIABLES
# ==============================================================================

# ------------------------------------------------------------------------------
# General Container Settings
# ------------------------------------------------------------------------------

variable "vm_id" {
  description = "Container identifier (VMID)"
  type        = number
  default     = null
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "description" {
  description = "Description of the container"
  type        = string
  default     = "Debian LXC container provisioned with Terraform"
}

variable "tags" {
  description = "Tags for the container"
  type        = list(string)
  default     = [" "]
}

variable "start_on_boot" {
  description = "Start container automatically on boot"
  type        = bool
  default     = true
}

variable "template" {
  description = "Whether to create a template"
  type        = bool
  default     = false
}

variable "unprivileged" {
  description = "Whether the container runs as unprivileged"
  type        = bool
  default     = true
}

variable "protection" {
  description = "Prevent container removal/update operations"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Operating System Configuration
# ------------------------------------------------------------------------------

variable "template_file_id" {
  description = "Template file ID for the container OS"
  type        = string
}

# ------------------------------------------------------------------------------
# Hardware Resources
# ------------------------------------------------------------------------------

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "cpu_units" {
  description = "CPU units (weight)"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "RAM allocation in MB"
  type        = number
  default     = 512
}

# ------------------------------------------------------------------------------
# Storage Configuration
# ------------------------------------------------------------------------------

variable "datastore_id" {
  description = "Storage pool name (e.g., local-lvm)"
  type        = string
}

variable "disk_size" {
  description = "Root filesystem size in GB"
  type        = number
  default     = 8
}

# ------------------------------------------------------------------------------
# Network Configuration
# ------------------------------------------------------------------------------

variable "network_interface_name" {
  description = "Network interface name"
  type        = string
  default     = "eth0"
}

variable "bridge" {
  description = "Network bridge name"
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN ID (0 for no VLAN)"
  type        = number
  default     = 0
}

variable "firewall" {
  description = "Enable firewall for the network interface"
  type        = bool
  default     = false
}

variable "network_enabled" {
  description = "Enable the network interface"
  type        = bool
  default     = true
}

variable "ip_address" {
  description = "Static IP address in CIDR notation (e.g., 192.168.1.100/24) or 'dhcp' for automatic assignment"
  type        = string
  default     = "dhcp"

  validation {
    condition = (
      var.ip_address == "dhcp" ||
      can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.ip_address))
    )
    error_message = "IP address must be 'dhcp' or in valid CIDR notation (e.g., 192.168.1.100/24)."
  }

  validation {
    condition = (
      var.ip_address == "dhcp" ||
      alltrue([
        for octet in split(".", split("/", var.ip_address)[0]) :
        can(tonumber(octet)) && tonumber(octet) >= 0 && tonumber(octet) <= 255
      ])
    )
    error_message = "Each IP address octet must be between 0 and 255."
  }

  validation {
    condition = (
      var.ip_address == "dhcp" ||
      (
        can(tonumber(split("/", var.ip_address)[1])) &&
        tonumber(split("/", var.ip_address)[1]) >= 1 &&
        tonumber(split("/", var.ip_address)[1]) <= 32
      )
    )
    error_message = "CIDR prefix must be between 1 and 32."
  }

  validation {
    condition = (
      var.ip_address == "dhcp" ||
      !startswith(var.ip_address, "0.")
    )
    error_message = "IP address cannot start with 0 (reserved network)."
  }

  validation {
    condition = (
      var.ip_address == "dhcp" ||
      !startswith(var.ip_address, "127.")
    )
    error_message = "IP address cannot be in the loopback range (127.0.0.0/8)."
  }
}

variable "gateway" {
  description = "Default gateway IP address"
  type        = string
  default     = null

  validation {
    condition = (
      var.gateway == null ||
      can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.gateway))
    )
    error_message = "Gateway must be null or a valid IPv4 address (e.g., 192.168.1.1)."
  }

  validation {
    condition = (
      var.gateway == null ||
      alltrue([
        for octet in split(".", var.gateway) :
        can(tonumber(octet)) && tonumber(octet) >= 0 && tonumber(octet) <= 255
      ])
    )
    error_message = "Each gateway IP octet must be between 0 and 255."
  }

  validation {
    condition = (
      var.gateway == null ||
      !startswith(var.gateway, "0.")
    )
    error_message = "Gateway IP cannot start with 0 (reserved network)."
  }
}

# ------------------------------------------------------------------------------
# Initialization Configuration
# ------------------------------------------------------------------------------

variable "hostname" {
  description = "Container hostname"
  type        = string
}

variable "password" {
  description = "Default password for the container user"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.password) >= 5
    error_message = "The password must be at least 5 characters long."
  }
}

variable "ssh_keys" {
  description = "List of SSH public keys for user authentication"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------------------------
# DNS Configuration
# ------------------------------------------------------------------------------

variable "dns_domain" {
  description = "DNS search domain"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

# ------------------------------------------------------------------------------
# Additional Features
# ------------------------------------------------------------------------------
variable "nesting" {
  description = "Enable nesting for the container"
  type        = bool
  default     = false
}
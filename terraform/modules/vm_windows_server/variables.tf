# ==============================================================================
# VM CONFIGURATION VARIABLES
# ==============================================================================

# ------------------------------------------------------------------------------
# General VM Settings
# ------------------------------------------------------------------------------

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string

  validation {
    condition     = length(var.vm_name) <= 15
    error_message = "The VM name must be less than or equal to 15 characters long."
  }
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "template_id" {
  description = "Template ID to clone from"
  type        = number
}

variable "on_boot" {
  description = "Start VM automatically on boot"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description of the virtual machine"
  type        = string
  default     = "Windows Server VM provisioned with Terraform"
}

variable "tags" {
  description = "Tags for the virtual machine"
  type        = list(string)
  default     = [" "]
}

# ------------------------------------------------------------------------------
# Hardware Resources
# ------------------------------------------------------------------------------

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "type" {
  description = "VM type (e.g., qemu)"
  type        = string
  default     = "host"

}

variable "memory" {
  description = "RAM allocation in MB"
  type        = number
  default     = 2048
}

# ------------------------------------------------------------------------------
# Storage Configuration
# ------------------------------------------------------------------------------

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 40
}

variable "disk_interface" {
  description = "Disk interface type"
  type        = string
  default     = "scsi0"
}

variable "datastore_id" {
  description = "Storage pool name (e.g., local-lvm)"
  type        = string
}

variable "disk_file_format" {
  description = "Disk file format (e.g., raw, qcow2)"
  type        = string
  default     = "qcow2"
}
# ------------------------------------------------------------------------------
# Network Configuration
# ------------------------------------------------------------------------------

variable "bridge" {
  description = "Network bridge name"
  type        = string
  default     = "vmbr0"
}

variable "model" {
  description = "Network card model"
  type        = string
  default     = "virtio"
}

variable "vlan_id" {
  description = "VLAN ID (0 for no VLAN)"
  type        = number
  default     = 0
}

variable "ip_address" {
  description = "Static IP address in CIDR notation (e.g., 192.168.1.100/24)"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.ip_address))
    error_message = "IP address must be in valid CIDR notation (e.g., 192.168.1.100/24)."
  }

  validation {
    condition = alltrue([
      for octet in split(".", split("/", var.ip_address)[0]) :
      can(tonumber(octet)) && tonumber(octet) >= 0 && tonumber(octet) <= 255
    ])
    error_message = "Each IP address octet must be between 0 and 255."
  }

  validation {
    condition = (
      can(tonumber(split("/", var.ip_address)[1])) &&
      tonumber(split("/", var.ip_address)[1]) >= 1 &&
      tonumber(split("/", var.ip_address)[1]) <= 32
    )
    error_message = "CIDR prefix must be between 1 and 32."
  }

  validation {
    condition     = !startswith(var.ip_address, "0.")
    error_message = "IP address cannot start with 0 (reserved network)."
  }

  validation {
    condition     = !startswith(var.ip_address, "127.")
    error_message = "IP address cannot be in the loopback range (127.0.0.0/8)."
  }
}

variable "gateway" {
  description = "Default gateway IP address"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.gateway))
    error_message = "Gateway must be a valid IPv4 address (e.g., 192.168.1.1)."
  }

  validation {
    condition = alltrue([
      for octet in split(".", var.gateway) :
      can(tonumber(octet)) && tonumber(octet) >= 0 && tonumber(octet) <= 255
    ])
    error_message = "Each gateway IP octet must be between 0 and 255."
  }

  validation {
    condition     = !startswith(var.gateway, "0.")
    error_message = "Gateway IP cannot start with 0 (reserved network)."
  }
}

# ------------------------------------------------------------------------------
# User Credentials
# ------------------------------------------------------------------------------

variable "password" {
  description = "Default password for the VM"
  type        = string
  default     = "Password123"

  validation {
    condition     = length(var.password) >= 7
    error_message = "The password must be at least 7 characters long."
  }

  validation {
    condition = (
      (can(regex("[0-9]", var.password)) ? 1 : 0) +
      (can(regex("[a-z]", var.password)) ? 1 : 0) +
      (can(regex("[A-Z]", var.password)) ? 1 : 0) +
      (can(regex("[^a-zA-Z0-9]", var.password)) ? 1 : 0)
    ) >= 3
    error_message = "The password must contain at least 3 of the following 4 character types: digits (0-9), lowercase letters (a-z), uppercase letters (A-Z), special characters (!@#$%^&*()_+-=[]{}|;:,.<>?)."
  }
}
# ==============================================================================
# VM CONFIGURATION VARIABLES
# ==============================================================================

# ------------------------------------------------------------------------------
# General VM Settings
# ------------------------------------------------------------------------------

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
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
  description = "Static IP address"
  type        = string
}

variable "netmask" {
  description = "Network mask (CIDR notation)"
  type        = number
  default     = 24
}

variable "gateway" {
  description = "Default gateway IP address"
  type        = string
}

# ------------------------------------------------------------------------------
# User Credentials
# ------------------------------------------------------------------------------

variable "username" {
  description = "Default username for the VM"
  type        = string
  default     = "Administrateur"
}

variable "password" {
  description = "Default password for the VM"
  type        = string
  default     = "password"

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
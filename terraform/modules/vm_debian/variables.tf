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
  default     = 20
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
  default     = 16
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
  default     = "user"
}

variable "password" {
  description = "Default password for the VM"
  type        = string
  default     = "user"
}

variable "keys" {
  description = "List of SSH public keys for user authentication"
  type        = list(string)
  default     = []
}
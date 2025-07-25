# ==============================================================================
# PROXMOX DEBIAN VM MODULE
# ==============================================================================
# This module creates a Debian virtual machine on Proxmox VE
# using template cloning and cloud-init initialization.

resource "proxmox_virtual_environment_vm" "vm_debian" {
  # ------------------------------------------------------------------------------
  # Basic VM Configuration
  # ------------------------------------------------------------------------------
  name        = var.vm_name
  node_name   = var.node_name
  description = var.description
  tags        = var.tags

  # ------------------------------------------------------------------------------
  # Template Cloning
  # ------------------------------------------------------------------------------
  clone {
    vm_id = var.template_id
    full  = true
  }

  # ------------------------------------------------------------------------------
  # Hardware Resources
  # ------------------------------------------------------------------------------
  cpu {
    cores = var.cores
    type  = var.type
  }

  memory {
    dedicated = var.memory
  }

  # ------------------------------------------------------------------------------
  # Storage Configuration
  # ------------------------------------------------------------------------------
  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
    interface    = var.disk_interface
    discard      = "on"
    file_format  = var.disk_file_format
  }

  # ------------------------------------------------------------------------------
  # Network Configuration
  # ------------------------------------------------------------------------------
  network_device {
    bridge  = var.bridge
    model   = var.model
    vlan_id = var.vlan_id
  }

  # ------------------------------------------------------------------------------
  # Cloud-init Initialization
  # ------------------------------------------------------------------------------
  initialization {
    # User account setup
    user_account {
      username = var.username
      password = var.password
      keys = var.keys
    }

    # Network configuration
    ip_config {
      ipv4 {
        address = "${var.ip_address}/${var.netmask}"
        gateway = var.gateway
      }
    }
  }

  # ------------------------------------------------------------------------------
  # VM Features and Boot Configuration
  # ------------------------------------------------------------------------------
  # Enable QEMU guest agent for better integration
  agent {
    enabled = true
  }

  # Set operating system type for optimal performance
  operating_system {
    type = "l26"
  }

  # Boot configuration
  boot_order = ["scsi0"]
  on_boot    = var.on_boot
}

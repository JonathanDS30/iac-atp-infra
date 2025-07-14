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
  description = "Debian VM provisioned with Terraform"

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
    file_format  = "raw"
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

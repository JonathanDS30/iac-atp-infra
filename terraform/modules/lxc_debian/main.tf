# ==============================================================================
# PROXMOX CONTAINER MODULE
# ==============================================================================
# This module creates a Debian container on Proxmox VE
# using a template file (.tar.zst) and initialization configuration.

resource "proxmox_virtual_environment_container" "debian_container" {
  # ------------------------------------------------------------------------------
  # Basic Container Configuration
  # ------------------------------------------------------------------------------
  vm_id         = var.vm_id
  node_name     = var.node_name
  description   = var.description
  tags          = var.tags
  start_on_boot = var.start_on_boot
  template      = var.template

  # Container-specific settings
  unprivileged = var.unprivileged
  protection   = var.protection

  # ------------------------------------------------------------------------------
  # Operating System Template
  # ------------------------------------------------------------------------------
  operating_system {
    template_file_id = var.template_file_id
    type             = "debian"
  }

  # ------------------------------------------------------------------------------
  # CPU Configuration
  # ------------------------------------------------------------------------------
  cpu {
    cores = var.cores
    units = var.cpu_units
  }

  # ------------------------------------------------------------------------------
  # Memory Configuration
  # ------------------------------------------------------------------------------
  memory {
    dedicated = var.memory
  }

  # ------------------------------------------------------------------------------
  # Disk Configuration
  # ------------------------------------------------------------------------------
  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }

  # ------------------------------------------------------------------------------
  # Network Interface Configuration
  # ------------------------------------------------------------------------------
  network_interface {
    name     = var.network_interface_name
    bridge   = var.bridge
    vlan_id  = var.vlan_id
    firewall = var.firewall
    enabled  = var.network_enabled
  }


  # ------------------------------------------------------------------------------
  # Initialization Configuration
  # ------------------------------------------------------------------------------
  initialization {
    hostname = var.hostname

    user_account {
      password = var.password
      keys     = var.ssh_keys
    }

    ip_config {
      ipv4 {
        address = var.ip_address == "dhcp" ? "dhcp" : "${var.ip_address}"
        gateway = var.ip_address == "dhcp" ? null : var.gateway
      }
    }

    dns {
      domain  = var.dns_domain
      servers = var.dns_servers
    }
  }
  # ------------------------------------------------------------------------------
  # Additional Features
  # ------------------------------------------------------------------------------

  features {
    nesting = var.nesting
  }
}


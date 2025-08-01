# define the Packer version for building template on Proxmox.
packer {
  required_plugins {
    proxmox = {
      version = "1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
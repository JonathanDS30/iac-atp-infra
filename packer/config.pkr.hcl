# config.pkr.hcl
# This file is used to define the Packer version for building a Debian 12 template on Proxmox.
packer {
  required_plugins {
    proxmox = {
      version = "v1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.42.0"
    }
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token" {
  type = string
}


provider "proxmox" {
  endpoint = var.proxmox_api_url       # ex : "https://192.168.1.253:8006/"

  api_token = var.proxmox_api_token  # ex : "root@pam"

  insecure = true                      # si certif autosigné

  ssh {
    agent = true
  }
}

# === LXC CONFIGURATION ===

variable "lxc_template_file_id" {
  description = "Template file ID for LXC containers"
  type        = string
  default     = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
}

variable "lxc_default_password" {
  description = "Default password for LXC containers"
  type        = string
  default     = "Password300!"
  sensitive   = true
}

# === DEBIAN CONFIGURATION ===

variable "debian_template_id" {
  description = "Template VM ID for Debian VMs"
  type        = number
  default     = 9200
}

variable "debian_username" {
  description = "Default username for Debian VMs"
  type        = string
  default     = "debian"
}

variable "debian_password" {
  description = "Default password for Debian VMs"
  type        = string
  default     = "Password300!"
  sensitive   = true
}

# === WINDOWS CONFIGURATION ===

variable "windows_template_id" {
  description = "Template VM ID for Windows VMs"
  type        = number
  default     = 9300
}

variable "windows_password" {
  description = "Default password for Windows VMs"
  type        = string
  default     = "Password300!"
  sensitive   = true
}


# === NETWORK CONFIGURATIONS ===

variable "networks" {
  description = "Network configurations per site"
  type = map(object({
    name      = string
    lan_cidr  = string
    gateway   = string
    comment   = string
    autostart = bool
  }))
  default = {
    datacenter = {
      name      = "dc"
      lan_cidr  = "10.1.0.0/16"
      gateway   = "10.1.255.254"
      comment   = "VLAN DATACENTER"
      autostart = true
    }
    london_servers = {
      name      = "lonsrv"
      lan_cidr  = "172.22.0.0/16"
      gateway   = "172.22.255.254"
      comment   = "VLAN LONDON SERVERS"
      autostart = true
    }
    london_clients = {
      name      = "lonclt"
      lan_cidr  = "172.23.0.0/16"
      gateway   = "172.23.255.254"
      comment   = "VLAN LONDON CLIENTS"
      autostart = true
    }
    monaco_clients = {
      name      = "monclt"
      lan_cidr  = "172.24.0.0/16"
      gateway   = "172.24.255.254"
      comment   = "VLAN MONACO CLIENTS"
      autostart = true
    }
    monaco_pra = {
      name      = "monpra"
      lan_cidr  = "172.22.0.0/16"
      gateway   = "172.22.255.254"
      comment   = "VLAN MONACO PRA"
      autostart = true
    }
    ponte_vedra = {
      name      = "ponte"
      lan_cidr  = "172.26.0.0/16"
      gateway   = "172.26.255.254"
      comment   = "VLAN PONTE VEDRA"
      autostart = true
    }
    sydney = {
      name      = "sydney"
      lan_cidr  = "172.29.0.0/16"
      gateway   = "172.29.255.254"
      comment   = "VLAN SYDNEY"
      autostart = true
    }
  }
}
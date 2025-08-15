# ==============================================================================
# ATP MULTI-SITE INFRASTRUCTURE CONFIGURATION
# ==============================================================================
# This configuration defines the complete infrastructure deployment across
# multiple geographic sites using Proxmox VE as the hypervisor platform.

locals {
  # ------------------------------------------------------------------------------
  # GLOBAL INFRASTRUCTURE SETTINGS
  # ------------------------------------------------------------------------------
  # Central Proxmox node configuration for all deployments
  proxmox_node = "SRV-PMX"

  # ------------------------------------------------------------------------------
  # MULTI-SITE SERVER TOPOLOGY
  # ------------------------------------------------------------------------------
  # Define all servers across geographic locations with their specific configurations
  # Each site contains servers grouped by network segment and function
  sites = {
    # Production datacenter - Primary site for core services
    datacenter = {
      network = "datacenter"
      servers = {
        "datacenter-gitlab" = {
          type        = "debian_vm"
          ip_internal = "10.1.0.2/16"
          cpu         = 2
          memory      = 4096
          disk        = 100
          tags        = []
          description = "Gitlab server"
        }
        "datacenter-srv-nextcloud" = {
          type        = "lxc"
          ip_internal = "10.1.0.1/16"
          cpu         = 2
          memory      = 2048
          disk        = 100
          tags        = ["file-server"]
          description = "File server"
        }
        "datacenter-iac-controlleur" = {
          type        = "lxc"
          ip_internal = "10.1.0.100/16"
          cpu         = 1
          memory      = 1024
          disk        = 25
          tags        = ["iac"]
          description = "IaC Controller"
        }
        "datacenter-proxy-zabbix" = {
          type        = "debian_vm"
          ip_internal = "10.1.1.150/16"
          cpu         = 1
          memory      = 2048
          disk        = 25
          tags        = ["proxy", "monitoring"]
          description = "Proxy Zabbix"
        }
      }
    }

    # London office - European operations hub
    london = {
      network = "london_servers"
      servers = {
        "londre-srv-sync" = {
          type        = "lxc"
          ip_internal = "172.22.0.1/16"
          cpu         = 2
          memory      = 2048
          disk        = 50
          tags        = ["file-server"]
          description = "File synchronization server"
        }
        "londre-srv-ad" = {
          type        = "windows_vm"
          ip_internal = "172.22.0.2/16"
          cpu         = 2
          memory      = 2048
          disk        = 50
          tags        = ["ad"]
          description = "AD / DNS"
        }
        "londre-srv-rds" = {
          type        = "windows_vm"
          ip_internal = "172.22.0.3/16"
          cpu         = 2
          memory      = 2048
          disk        = 50
          tags        = ["rds", "virtual-desktop"]
          description = "Virtual Desktop"
        }
        "londre-srv-supervision" = {
          type        = "lxc"
          ip_internal = "172.22.0.4/16"
          cpu         = 2
          memory      = 2048
          disk        = 50
          tags        = ["supervision", "monitoring"]
          description = "Supervision server"
        }
        "londre-srv-grafana" = {
          type        = "lxc"
          ip_internal = "172.22.0.5/16"
          cpu         = 1
          memory      = 1024
          disk        = 15
          tags        = ["monitoring"]
          description = "Grafana server"
        }
        "londre-srv-elk" = {
          type        = "debian_vm"
          ip_internal = "172.22.0.6/16"
          cpu         = 4
          memory      = 16384
          disk        = 100
          tags        = ["monitoring"]
          description = "ELK server"
        }
      }
    }

    # Monaco site - Disaster recovery infrastructure
    monaco = {
      network = "monaco_pra"
      servers = {
        "monaco-srv-nextcloud" = {
          type        = "lxc"
          ip_internal = "172.22.0.51/16"
          cpu         = 2
          memory      = 2048
          disk        = 100
          tags        = ["nextcloud", "pra", "backup"]
          description = "File transfer server"
        }
        # "monaco-srv-ad" = {
        #   type        = "windows_vm"
        #   ip_internal = "172.22.0.2/16"
        #   cpu         = 2
        #   memory      = 2048
        #   disk        = 50
        #   tags        = ["ad"]
        #   description = "AD / DNS"
        # }
        # "monaco-srv-rds" = {
        #   type        = "windows_vm"
        #   ip_internal = "172.22.0.3/16"
        #   cpu         = 2
        #   memory      = 2048
        #   disk        = 50
        #   tags        = ["virtual-desktop"]
        #   description = "Bureau Virtuel"
        # }
        # "monaco-proxy-zabbix" = {
        #   type        = "debian_vm"
        #   ip_internal = "172.24.0.100/16"
        #   cpu         = 1
        #   memory      = 512
        #   disk        = 30
        #   tags        = ["proxy", "monitoring"]
        #   description = "Proxy Zabbix"
        # }
      }
    }

    # Ponte Vedra site - Regional office infrastructure
    ponte_vedra = {
      network = "ponte_vedra"
      servers = {
        "ponte-srv-ad" = {
          type        = "windows_vm"
          ip_internal = "172.26.0.2/16"
          cpu         = 2
          memory      = 2048
          disk        = 50
          tags        = ["ad"]
          description = "AD / DNS"
        }
        "ponte-proxy-zabbix" = {
          type        = "debian_vm"
          ip_internal = "172.26.0.100/16"
          cpu         = 1
          memory      = 512
          disk        = 25
          tags        = ["proxy", "monitoring"]
          description = "Proxy Zabbix"
        }
      }
    }

    # Sydney site - Asia-Pacific regional operations
    sydney = {
      network = "sydney"
      servers = {
        "sydney-proxy-zabbix" = {
          type        = "debian_vm"
          ip_internal = "172.29.0.100/16"
          cpu         = 1
          memory      = 512
          disk        = 25
          tags        = ["proxy", "monitoring"]
          description = "Proxy Zabbix"
        }
      }
    }
  }

  # ------------------------------------------------------------------------------
  # SERVER CONFIGURATION PROCESSING
  # ------------------------------------------------------------------------------
  # Transform nested site configuration into flat server list with enriched metadata
  # Automatically inject network configuration and standardized tagging
  all_servers = flatten([
    for site_name, site_config in local.sites : [
      for server_name, server_config in site_config.servers : {
        # Unique identifier for Terraform resource management
        key = server_name

        # Site and infrastructure metadata
        site           = site_name
        type           = server_config.type
        hostname       = server_name
        ip_internal    = server_config.ip_internal
        gateway        = var.networks[site_config.network].gateway
        network_bridge = var.networks[site_config.network].name
        datastore_id   = "local-lvm"

        # Hardware resource specifications
        cpu    = server_config.cpu
        memory = server_config.memory
        disk   = server_config.disk

        # Standardized tagging strategy for resource classification
        tags = distinct(concat(
          [site_name],       # Geographic location tag
          ["atp-infra"],     # Organization identifier
          server_config.tags # Service-specific functional tags
        ))

        # Service description for documentation and monitoring
        description = server_config.description
      }
    ]
  ])

  # Convert to map for use with for_each
  servers_map = {
    for server in local.all_servers : server.key => server
  }

  servers_lxc = {
    for name, config in local.servers_map : name => config
    if config.type == "lxc"
  }

  servers_windows = {
    for name, config in local.servers_map : name => config
    if config.type == "windows_vm" # VMs Windows
  }

  servers_debian_vm = {
    for name, config in local.servers_map : name => config
    if config.type == "debian_vm" # VMs Debian
  }
}


# ==============================================================================
# INFRASTRUCTURE DEPLOYMENT MODULES
# ==============================================================================
# This section deploys all infrastructure components across multiple sites
# using dedicated modules for each service type (LXC, Windows VMs, Debian VMs)

# ------------------------------------------------------------------------------
# LXC CONTAINER DEPLOYMENT
# ------------------------------------------------------------------------------
# Deploy all Debian-based LXC containers across all sites
# Includes: Nextcloud, IaC controllers, monitoring services, sync services
module "lxc_containers" {
  source = "./modules/lxc_debian"

  # Deploy one container per filtered server
  for_each = local.servers_lxc

  # Ensure networks are created before containers
  depends_on = [module.network]

  # Infrastructure configuration
  node_name = local.proxmox_node

  # Container identification and template
  hostname         = each.key
  template_file_id = var.lxc_template_file_id
  datastore_id     = each.value.datastore_id
  password         = var.lxc_default_password

  # Resource allocation
  cores     = each.value.cpu
  memory    = each.value.memory
  disk_size = each.value.disk

  # Network configuration with site-specific settings
  ip_address = each.value.ip_internal
  gateway    = each.value.gateway
  bridge     = each.value.network_bridge

  # Metadata and classification
  description = each.value.description
  tags        = each.value.tags
}

# ------------------------------------------------------------------------------
# WINDOWS VM DEPLOYMENT
# ------------------------------------------------------------------------------
# Deploy Windows Server VMs for Active Directory, RDS, and Windows services
# Includes: Domain controllers, RDS servers, Windows-specific workloads
module "windows_vms" {
  source = "./modules/vm_windows_server"

  # Deploy one VM per filtered Windows server
  for_each = local.servers_windows

  # Ensure networks are created before VMs
  depends_on = [module.network]

  # Infrastructure configuration
  node_name   = local.proxmox_node
  vm_name     = each.key
  template_id = var.windows_template_id

  # Resource allocation
  cores        = each.value.cpu
  memory       = each.value.memory
  disk_size    = each.value.disk
  datastore_id = each.value.datastore_id

  # Network configuration with site-specific settings
  ip_address = each.value.ip_internal
  gateway    = each.value.gateway
  bridge     = each.value.network_bridge

  # Windows-specific configuration
  password    = var.windows_password
  description = each.value.description
  tags        = each.value.tags
  on_boot     = true
}

# ------------------------------------------------------------------------------
# DEBIAN VM DEPLOYMENT
# ------------------------------------------------------------------------------
# Deploy Debian-based virtual machines for services requiring full VM capabilities
# Includes: GitLab, ELK stack, Zabbix proxies, high-performance workloads
module "debian_vms" {
  source = "./modules/vm_debian"

  # Deploy one VM per filtered Debian server
  for_each = local.servers_debian_vm

  # Ensure networks are created before VMs
  depends_on = [module.network]

  # Infrastructure configuration
  node_name   = local.proxmox_node
  vm_name     = each.key
  template_id = var.debian_template_id

  # Resource allocation
  cores        = each.value.cpu
  memory       = each.value.memory
  disk_size    = each.value.disk
  datastore_id = each.value.datastore_id

  # Network configuration with site-specific settings
  ip_address = each.value.ip_internal
  gateway    = each.value.gateway
  bridge     = each.value.network_bridge

  # Debian-specific configuration with cloud-init
  username    = var.debian_username
  password    = var.debian_password
  description = each.value.description
  tags        = each.value.tags
  on_boot     = true
}

# ------------------------------------------------------------------------------
# NETWORK INFRASTRUCTURE
# ------------------------------------------------------------------------------
# Create all network bridges and VLANs for multi-site infrastructure
# Establishes network isolation and connectivity between sites
module "network" {
  source = "./modules/networks"

  # Create one bridge per defined network
  for_each = var.networks

  # Network bridge configuration
  node_name              = local.proxmox_node
  network_interface_name = each.value.name
  address                = each.value.lan_cidr
}

# Debian VM Module for Proxmox VE

This Terraform module creates and configures a Debian virtual machine on Proxmox VE using template cloning and cloud-init initialization.

## Features

- **Template-based deployment** - Clone from existing Debian templates
- **Cloud-init support** - Automated VM initialization and configuration
- **Flexible hardware configuration** - Customizable CPU, memory, and storage
- **Network configuration** - Static IP assignment with VLAN support
- **QEMU guest agent** - Enhanced VM management and monitoring
- **Boot configuration** - Automatic startup options

## Usage

```hcl
module "debian_vm" {
  source = "./modules/vm_debian"

  # Basic VM configuration
  vm_name     = "my-debian-vm"
  node_name   = "proxmox-node-01"
  template_id = 9000

  # Hardware resources
  cores  = 4
  memory = 4096

  # Storage configuration
  disk_size    = 50
  datastore_id = "local-lvm"

  # Network configuration
  bridge     = "vmbr0"
  ip_address = "192.168.1.100"
  netmask    = 24
  gateway    = "192.168.1.1"
  vlan_id    = 100

  # User credentials
  username = "admin"
  password = "secure-password"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| proxmox | >= 0.50.0 |

## Providers

| Name | Version |
|------|---------|
| proxmox | >= 0.50.0 |

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_vm.vm_debian](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vm_name | Name of the virtual machine | `string` | n/a | yes |
| node_name | Proxmox node name | `string` | n/a | yes |
| template_id | Template ID to clone from | `number` | n/a | yes |
| datastore_id | Storage pool name (e.g., local-lvm) | `string` | n/a | yes |
| ip_address | Static IP address | `string` | n/a | yes |
| gateway | Default gateway IP address | `string` | n/a | yes |
| cores | Number of CPU cores | `number` | `2` | no |
| memory | RAM allocation in MB | `number` | `2048` | no |
| disk_size | Disk size in GB | `number` | `20` | no |
| disk_interface | Disk interface type | `string` | `"scsi0"` | no |
| bridge | Network bridge name | `string` | `"vmbr0"` | no |
| model | Network card model | `string` | `"virtio"` | no |
| vlan_id | VLAN ID (0 for no VLAN) | `number` | `0` | no |
| netmask | Network mask (CIDR notation) | `number` | `16` | no |
| on_boot | Start VM automatically on boot | `bool` | `true` | no |
| username | Default username for the VM | `string` | `"user"` | no |
| password | Default password for the VM | `string` | `"user"` | no |

## Outputs

| Name | Description |
|------|-------------|
| vm_id | The ID of the created virtual machine |
| ip | The IP address of the virtual machine |
| name | The name of the virtual machine |

## Prerequisites

1. **Proxmox VE cluster** with API access configured
2. **Debian template** prepared with cloud-init support
3. **Network bridge** configured on the target Proxmox node
4. **Storage pool** available for VM disk allocation

## Template Preparation

Your Debian template should include:
- Cloud-init package installed
- QEMU guest agent installed
- Network configuration prepared for cloud-init
- SSH server configured (optional but recommended)

## Examples

### Basic Debian VM

```hcl
module "web_server" {
  source = "./modules/vm_debian"

  vm_name     = "web-server-01"
  node_name   = "pve-node-01"
  template_id = 9000
  
  datastore_id = "local-lvm"
  ip_address   = "192.168.1.10"
  gateway      = "192.168.1.1"
}
```

### High-Performance VM with Custom Configuration

```hcl
module "database_server" {
  source = "./modules/vm_debian"

  vm_name     = "db-server-01"
  node_name   = "pve-node-02"
  template_id = 9001

  # High-performance configuration
  cores  = 8
  memory = 16384
  
  # Large storage allocation
  disk_size    = 200
  datastore_id = "fast-ssd"

  # Network with VLAN
  bridge     = "vmbr1"
  vlan_id    = 200
  ip_address = "10.0.200.50"
  netmask    = 24
  gateway    = "10.0.200.1"

  # Custom credentials
  username = "dbadmin"
  password = "strong-database-password"
}
```

## Notes

- The module uses cloud-init for VM initialization, ensuring consistent and automated setup
- QEMU guest agent is enabled by default for better VM management
- Boot order is set to prioritize the main disk (scsi0)
- Operating system type is configured as Linux 2.6+ kernel for optimal performance

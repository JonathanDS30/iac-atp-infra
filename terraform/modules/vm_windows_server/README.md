# Windows Server VM Module for Proxmox VE

This Terraform module creates and configures a Windows Server virtual machine on Proxmox VE using template cloning and cloud-init initialization.

## Features

- **Template-based deployment** - Clone from existing Windows Server templates
- **Cloud-init support** - Automated VM initialization and configuration
- **Flexible hardware configuration** - Customizable CPU, memory, and storage
- **Network configuration** - Static IP assignment with VLAN support
- **QEMU guest agent** - Enhanced VM management and monitoring
- **Boot configuration** - Automatic startup options
- **Windows optimization** - OS-specific settings for optimal performance

## Usage

```hcl
module "windows_server_vm" {
  source = "./modules/vm_windows_server"

  # Basic VM configuration
  vm_name     = "win-server-01"
  node_name   = "proxmox-node-01"
  template_id = 9001

  # Hardware resources
  cores  = 4
  memory = 8192

  # Storage configuration
  disk_size    = 100
  datastore_id = "local-lvm"

  # Network configuration
  bridge     = "vmbr0"
  ip_address = "192.168.1.150"
  netmask    = 24
  gateway    = "192.168.1.1"
  vlan_id    = 100

  # User credentials
  username = "administrator"
  password = "secure-password"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| proxmox | >= 0.42.0 |

## Providers

| Name | Version |
|------|---------|
| proxmox | >= 0.42.0 |

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
| type | CPU type | `string` | `"host"` | no |
| memory | RAM allocation in MB | `number` | `2048` | no |
| disk_size | Disk size in GB | `number` | `40` | no |
| disk_interface | Disk interface type | `string` | `"scsi0"` | no |
| disk_file_format | Disk file format | `string` | `"qcow2"` | no |
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
2. **Windows Server template** prepared with cloud-init support
3. **Network bridge** configured on the target Proxmox node
4. **Storage pool** available for VM disk allocation
5. **VirtIO drivers** installed in the template for optimal performance

## Template Preparation

Your Windows Server template should include:
- Cloud-init support configured
- QEMU guest agent installed
- VirtIO drivers for network and storage
- Network configuration prepared for cloud-init
- Remote Desktop or SSH access configured (optional but recommended)

## Examples

### Basic Windows Server VM

```hcl
module "web_server" {
  source = "./modules/vm_windows_server"

  vm_name     = "iis-server-01"
  node_name   = "pve-node-01"
  template_id = 9001
  
  datastore_id = "local-lvm"
  ip_address   = "192.168.1.20"
  gateway      = "192.168.1.1"

  # Windows Server typically needs more resources
  cores  = 4
  memory = 4096
  disk_size = 80
}
```

### High-Performance Domain Controller

```hcl
module "domain_controller" {
  source = "./modules/vm_windows_server"

  vm_name     = "dc-server-01"
  node_name   = "pve-node-02"
  template_id = 9002

  # Domain controller configuration
  cores  = 4
  memory = 8192
  
  # Adequate storage for AD database
  disk_size    = 120
  datastore_id = "fast-ssd"

  # Network with dedicated VLAN
  bridge     = "vmbr1"
  vlan_id    = 10
  ip_address = "10.0.10.10"
  netmask    = 24
  gateway    = "10.0.10.1"

  # Administrator credentials
  username = "administrator"
  password = "ComplexDomainPassword123!"
}
```

### SQL Server Database VM

```hcl
module "sql_server" {
  source = "./modules/vm_windows_server"

  vm_name     = "sql-server-01"
  node_name   = "pve-node-03"
  template_id = 9003

  # High-performance SQL Server configuration
  cores  = 8
  memory = 16384
  
  # Large storage for databases
  disk_size         = 500
  disk_file_format  = "raw"  # Better performance for databases
  datastore_id      = "nvme-storage"

  # Dedicated database network
  bridge     = "vmbr2"
  vlan_id    = 20
  ip_address = "10.0.20.50"
  netmask    = 24
  gateway    = "10.0.20.1"

  # SQL Server service account
  username = "sqlservice"
  password = "SqlServerPassword123!"
}
```

## Windows-Specific Considerations

### Resource Requirements
- **Minimum RAM**: 2GB (4GB+ recommended for production workloads)
- **Minimum Storage**: 40GB (80GB+ recommended for Windows Server with roles)
- **CPU**: Use `host` type for best performance

### Network Configuration
- VirtIO network drivers provide better performance than e1000
- Consider dedicated VLANs for different server roles (DC, SQL, Web, etc.)
- Ensure Windows Firewall rules allow necessary traffic

### Security Best Practices
- Use strong passwords that meet Windows complexity requirements
- Consider using Windows domain authentication instead of local accounts
- Enable Windows Update and configure appropriate maintenance windows
- Install and configure Windows Defender or enterprise antivirus

## Best Practices

- **Resource allocation**: Windows Server typically requires more resources than Linux
- **Storage format**: Use `raw` format for better I/O performance on database servers
- **CPU type**: Use `host` CPU type for optimal performance
- **Memory**: Allocate sufficient RAM to avoid excessive paging
- **Updates**: Keep Windows Server templates updated with latest patches

## Notes

- The module is optimized for Windows Server operating systems
- Cloud-init configuration may vary depending on the Windows version
- VirtIO drivers are recommended for optimal network and storage performance
- Consider licensing requirements for Windows Server in your environment
- QEMU guest agent enhances VM management capabilities and should be installed in templates
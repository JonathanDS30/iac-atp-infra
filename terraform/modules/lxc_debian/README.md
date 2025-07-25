# Debian LXC Container Module for Proxmox VE

This Terraform module creates and configures a Debian LXC container on Proxmox VE using template files and initialization configuration for lightweight virtualization.

## Features

- **Template-based deployment** - Deploy from existing Debian LXC templates
- **Lightweight virtualization** - OS-level virtualization with minimal overhead
- **Flexible hardware configuration** - Customizable CPU, memory, and storage
- **Network configuration** - Static IP assignment with VLAN support
- **Container features** - Support for nesting, FUSE, and other advanced features
- **SSH key authentication** - Secure key-based authentication support
- **Boot configuration** - Automatic startup options
- **Unprivileged containers** - Enhanced security with unprivileged execution

## Usage

```hcl
module "debian_container" {
  source = "./modules/lxc_debian"

  # Basic container configuration
  vm_id           = 100
  node_name       = "proxmox-node-01"
  hostname        = "debian-container-01"
  template_file_id = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"

  # Hardware resources
  cores  = 2
  memory = 1024

  # Storage configuration
  disk_size    = 16
  datastore_id = "local-lvm"

  # Network configuration
  bridge     = "vmbr0"
  ip_address = "192.168.1.200"
  netmask    = 24
  gateway    = "192.168.1.1"
  vlan_id    = 100

  # User credentials
  username = "admin"
  password = "secure-password"
  ssh_keys = ["ssh-rsa AAAAB3NzaC1yc2E..."]
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
| [proxmox_virtual_environment_container.debian_container](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vm_id | Container identifier (VMID) | `number` | n/a | yes |
| node_name | Proxmox node name | `string` | n/a | yes |
| template_file_id | Template file ID for the container OS | `string` | n/a | yes |
| hostname | Container hostname | `string` | n/a | yes |
| datastore_id | Storage pool name (e.g., local-lvm) | `string` | n/a | yes |
| password | Default password for the container user | `string` | n/a | yes |
| description | Description of the container | `string` | `"Debian LXC container provisioned with Terraform"` | no |
| tags | Tags for the container | `list(string)` | `null` | no |
| start_on_boot | Start container automatically on boot | `bool` | `true` | no |
| template | Whether to create a template | `bool` | `false` | no |
| unprivileged | Whether the container runs as unprivileged | `bool` | `true` | no |
| protection | Prevent container removal/update operations | `bool` | `false` | no |
| cores | Number of CPU cores | `number` | `1` | no |
| cpu_units | CPU units (weight) | `number` | `1024` | no |
| cpu_architecture | CPU architecture | `string` | `"amd64"` | no |
| memory | RAM allocation in MB | `number` | `512` | no |
| disk_size | Root filesystem size in GB | `number` | `8` | no |
| network_interface_name | Network interface name | `string` | `"veth0"` | no |
| bridge | Network bridge name | `string` | `"vmbr0"` | no |
| vlan_id | VLAN ID (0 for no VLAN) | `number` | `0` | no |
| firewall | Enable firewall for the network interface | `bool` | `false` | no |
| network_enabled | Enable the network interface | `bool` | `true` | no |
| ip_address | Static IP address or 'dhcp' for automatic assignment | `string` | `"dhcp"` | no |
| netmask | Network mask (CIDR notation) | `number` | `24` | no |
| gateway | Default gateway IP address | `string` | `null` | no |
| username | Default username for the container | `string` | `"root"` | no |
| ssh_keys | List of SSH public keys for user authentication | `list(string)` | `[]` | no |
| dns_domain | DNS search domain | `string` | `null` | no |
| dns_servers | List of DNS servers | `list(string)` | `["8.8.8.8", "8.8.4.4"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| container_id | The ID of the created container |
| ip | The IP address of the container |
| hostname | The hostname of the container |

## Prerequisites

1. **Proxmox VE cluster** with API access configured
2. **Debian LXC template** available in the specified datastore
3. **Network bridge** configured on the target Proxmox node
4. **Storage pool** available for container disk allocation
5. **Container support** enabled on the Proxmox node

## Template Preparation

Your Debian LXC template should:
- Be a standard Debian LXC template (.tar.zst format)
- Support cloud-init or similar initialization methods
- Have SSH server configured (if using SSH key authentication)
- Include necessary packages for your use case

## Examples

### Basic Web Server Container

```hcl
module "web_container" {
  source = "./modules/lxc_debian"

  vm_id           = 101
  node_name       = "pve-node-01"
  hostname        = "web-server"
  template_file_id = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"
  
  datastore_id = "local-lvm"
  ip_address   = "192.168.1.100"
  gateway      = "192.168.1.1"
  
  # Web server resources
  cores  = 2
  memory = 1024
  disk_size = 20
  
  password = "WebServer123!"
}
```

### Development Environment Container

```hcl
module "dev_container" {
  source = "./modules/lxc_debian"

  vm_id           = 102
  node_name       = "pve-node-02"
  hostname        = "dev-environment"
  template_file_id = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"

  # Development configuration
  cores  = 4
  memory = 2048
  disk_size = 50
  
  datastore_id = "fast-ssd"

  # Network with VLAN
  bridge     = "vmbr1"
  vlan_id    = 200
  ip_address = "10.0.200.100"
  netmask    = 24
  gateway    = "10.0.200.1"

  # SSH key authentication
  username = "developer"
  password = "DevPassword123!"
  ssh_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... developer@workstation"
  ]
}
```

### Database Container with High Performance

```hcl
module "database_container" {
  source = "./modules/lxc_debian"

  vm_id           = 103
  node_name       = "pve-node-03"
  hostname        = "database-server"
  template_file_id = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"

  # High-performance database configuration
  cores     = 4
  cpu_units = 2048  # Higher CPU priority
  memory    = 4096
  
  # Large storage for database
  disk_size    = 100
  datastore_id = "nvme-storage"

  # Dedicated database network
  bridge     = "vmbr2"
  vlan_id    = 30
  ip_address = "10.0.30.50"
  netmask    = 24
  gateway    = "10.0.30.1"

  # Security settings
  unprivileged = true
  protection   = true  # Prevent accidental deletion
  
  # Database service account
  username = "dbadmin"
  password = "DatabasePassword123!"
  
  # Custom DNS for database queries
  dns_servers = ["10.0.30.1", "8.8.8.8"]
}
```

## LXC-Specific Considerations

### Resource Efficiency
- **Memory**: Containers typically use 50-80% less RAM than VMs
- **Storage**: Minimal overhead, shared kernel with host
- **CPU**: Near-native performance with container virtualization

### Security Features
- **Unprivileged containers**: Enhanced security isolation (recommended)
- **User namespace mapping**: Automatic UID/GID mapping
- **AppArmor/SELinux**: Container-specific security profiles

### Networking
- **veth interfaces**: Virtual Ethernet pairs for container networking
- **Bridge networking**: Connect containers to existing network infrastructure
- **VLAN support**: Network segmentation at container level

### Storage Considerations
- **Overlay filesystems**: Efficient copy-on-write storage
- **Bind mounts**: Direct host filesystem access (use with caution)
- **Volume mounts**: Dedicated storage volumes for persistent data

## Best Practices

- **Resource allocation**: Start with minimal resources and scale as needed
- **Security**: Use unprivileged containers unless privileged access is required
- **Networking**: Implement proper network segmentation with VLANs
- **Storage**: Separate application data from container filesystem
- **Updates**: Keep container templates updated with security patches
- **Monitoring**: Implement container-specific monitoring solutions

## Limitations

- **Kernel sharing**: All containers share the host kernel
- **Hardware access**: Limited direct hardware access compared to VMs
- **Nested virtualization**: Limited support for running VMs inside containers
- **OS compatibility**: Only Linux distributions supported

## Notes

- LXC containers provide excellent performance for Linux workloads
- Container startup times are significantly faster than VMs
- Resource overhead is minimal compared to full virtualization
- Ideal for microservices, development environments, and stateless applications
- Consider using privileged containers only when absolutely necessary for security
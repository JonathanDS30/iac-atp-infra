# Network Bridge Module for Proxmox VE

This Terraform module creates and configures Linux bridge network interfaces on Proxmox VE to establish network connectivity for virtual machines and containers.

## Features

- **Network bridge creation** - Configure Linux bridge interfaces on Proxmox nodes
- **IP address configuration** - Assign IPv4/CIDR addresses to interfaces
- **Automatic startup** - Configure automatic interface startup on boot
- **Input validation** - Validate network interface name length constraints
- **Built-in documentation** - Support for comments and documentation

## Usage

```hcl
module "network_bridge" {
  source = "./modules/networks"

  # Basic configuration
  node_name               = "proxmox-node-01"
  network_interface_name  = "vmbr1"
  address                 = "192.168.1.1/24"

  # Optional configuration
  comment                      = "Network bridge for VLAN 100"
  autostart_network_interfaces = true
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
| [proxmox_virtual_environment_network_linux_bridge.network_interface](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_network_linux_bridge) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| node_name | Proxmox node name | `string` | n/a | yes |
| network_interface_name | Network interface name (max 10 characters) | `string` | n/a | yes |
| address | IPv4/CIDR address for the network interface | `string` | n/a | yes |
| autostart_network_interfaces | Start network interfaces automatically on boot | `bool` | `true` | no |
| comment | Comment for the network interface | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| network_interface_name | The name of the created network interface |
| address | The IPv4/CIDR address assigned to the interface |

## Prerequisites

1. **Proxmox VE cluster** with API access configured
2. **Proxmox node** accessible and functional
3. **Network permissions** sufficient on the target node
4. **Physical interface** available for bridging (if required)

## Examples

### Simple Network Bridge

```hcl
module "main_bridge" {
  source = "./modules/networks"

  node_name              = "pve-node-01"
  network_interface_name = "vmbr0"
  address                = "192.168.1.1/24"
  comment                = "Main bridge for internal network"
}
```

### VLAN Dedicated Bridge

```hcl
module "vlan_bridge" {
  source = "./modules/networks"

  node_name              = "pve-node-02"
  network_interface_name = "vmbr100"
  address                = "10.0.100.1/24"
  comment                = "Bridge for VLAN 100 - Production servers"
  
  # Automatic startup disabled for maintenance
  autostart_network_interfaces = false
}
```

### Test Environment Bridge

```hcl
module "test_bridge" {
  source = "./modules/networks"

  node_name              = "pve-test"
  network_interface_name = "vmbr999"
  address                = "172.16.0.1/16"
  comment                = "Isolated bridge for test environment"
}
```

## Best Practices

- **Interface naming** - Use descriptive and short names (max 10 characters)
- **IP addressing plan** - Define a consistent IP addressing plan before deployment
- **Documentation** - Use the `comment` field to document each bridge's purpose
- **Automatic startup** - Enable `autostart_network_interfaces` for critical bridges

## Validation

The module includes automatic validation for:
- **Interface name length** - Maximum 10 characters (Proxmox limitation)
- **Address format** - Standard Terraform validation for IPv4 CIDR

## Notes

- Bridge interfaces are created at the specified Proxmox node level
- Modifying an existing interface may require a network restart
- Ensure the chosen IP address does not create network conflicts
- The bridge will be automatically available for assignment to VMs and containers
# Packer Templates for Proxmox VE

This repository contains Packer templates for building virtual machine images on Proxmox VE infrastructure. The templates support both Linux (Debian 12) and Windows Server 2022 operating systems with automated provisioning and configuration.

## Features

- **Multi-OS Support** - Build templates for Linux (Debian 12) and Windows Server 2022
- **Proxmox VE Integration** - Native support for Proxmox Virtual Environment
- **Automated Provisioning** - Unattended installation and configuration
- **Cloud-init Ready** - Templates prepared for cloud-init initialization
- **Customizable Configuration** - Variable-based configuration for flexible deployments
- **Production Ready** - Optimized templates for enterprise environments

## Requirements

### General Prerequisites

| Component | Version | Notes |
|-----------|---------|-------|
| Packer | >= 1.8.0 | HashiCorp Packer for image building |
| Proxmox VE | >= 7.0 | Target virtualization platform |
| xorriso | latest | Required for ISO manipulation (Linux: `sudo apt install xorriso`) |

### Proxmox VE User Configuration

Before using these templates, you need to configure a dedicated user account with appropriate permissions.

#### 1. Create Packer Role

Create a role with the necessary privileges for Packer operations:

```bash
sudo -i
pveum role add Packer -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
```

#### 2. Create Packer User

Create a dedicated user account for Packer operations:

```bash
pveum user add packer@pve --password <your-secure-password>
```

#### 3. Assign Role to User

Grant the Packer role to the user at datacenter level:

```bash
pveum aclmod / -user packer@pve -role Packer
```

#### 4. Additional Requirements for Windows Templates

For Windows Server templates, additional permissions are required:

```bash
# Add PVEDatastoreAdmin role for local storage access
pveum aclmod /storage/local -user packer@pve -role PVEDatastoreAdmin
```

## Project Structure

```
packer/
├── config.pkr.hcl              # Global Packer configuration
├── linux/
│   └── debian12/
│       ├── build.pkr.hcl       # Debian 12 build configuration
│       ├── debian-12.pkrvars.hcl # Debian 12 variables
│       └── http/
│           └── debian/
│               └── preseed.cfg  # Automated installation config
└── windows/
    └── win2022-x64-fr/
        ├── build.pkr.hcl       # Windows Server 2022 build configuration
        ├── windows-server22.pkrvars.hcl # Windows Server variables
        └── provision/
            ├── answer_files/
            │   └── autounattend.xml # Automated installation config
            ├── scripts/
            │   ├── setup.ps1    # Main provisioning script
            │   ├── sysprep.ps1  # System preparation script
            │   └── postdeployment-enable-winrm.ps1
            └── tools/
                └── cloudbase-init/ # Cloud-init configuration
```

## Usage

### Building Debian 12 Template

Build a Debian 12 template with automated provisioning:

```bash
# Navigate to packer directory
cd packer/

# Build Debian 12 template
packer build -var-file=linux/debian12/debian-12.pkrvars.hcl linux/debian12/build.pkr.hcl
```

### Building Windows Server 2022 Template

Build a Windows Server 2022 template with automated provisioning:

```bash
# Navigate to packer directory
cd packer/

# Build Windows Server 2022 template
packer build -var-file=windows/win2022-x64-fr/windows-server22.pkrvars.hcl windows/win2022-x64-fr/build.pkr.hcl
```

### Validating Templates

Before building, validate your template configuration:

```bash
# Validate Debian template
packer validate -var-file=linux/debian12/debian-12.pkrvars.hcl linux/debian12/build.pkr.hcl

# Validate Windows template
packer validate -var-file=windows/win2022-x64-fr/windows-server22.pkrvars.hcl windows/win2022-x64-fr/build.pkr.hcl
```

## Template Configuration

### Debian 12 Template

The Debian 12 template includes:
- **Automated Installation** - Preseed configuration for unattended setup
- **Cloud-init Support** - Ready for cloud-init initialization
- **Essential Packages** - Base system with necessary tools
- **Security Hardening** - Basic security configurations
- **QEMU Guest Agent** - Enhanced VM management capabilities

### Windows Server 2022 Template

The Windows Server 2022 template includes:
- **Automated Installation** - Autounattend.xml for unattended setup
- **Cloudbase-Init Support** - Windows equivalent of cloud-init
- **Essential Software** - Notepad++, Windows updates, and tools
- **Remote Management** - WinRM and Remote Desktop configuration
- **System Optimization** - Performance and security optimizations
- **Sysprep Preparation** - Proper generalization for template use

## Customization

### Variable Files

Both templates use variable files for easy customization:

#### Debian Variables (debian-12.pkrvars.hcl)
```hcl
# Proxmox settings
proxmox_url      = "https://your-proxmox:8006/api2/json"
proxmox_username = "packer@pve"
proxmox_password = "your-password"
proxmox_node     = "your-node"

# VM settings
vm_name     = "debian-12-template"
vm_id       = 9000
cores       = 2
memory      = 2048
disk_size   = "20G"
```

#### Windows Variables (windows-server22.pkrvars.hcl)
```hcl
# Proxmox settings
proxmox_url      = "https://your-proxmox:8006/api2/json"
proxmox_username = "packer@pve"
proxmox_password = "your-password"
proxmox_node     = "your-node"

# VM settings
vm_name     = "win2022-template"
vm_id       = 9001
cores       = 4
memory      = 4096
disk_size   = "60G"
```

## Best Practices

### Template Management
- **Version Control** - Track template versions and changes
- **Testing** - Always test templates before production use
- **Documentation** - Document any customizations made
- **Security** - Use secure passwords and update regularly

### Resource Allocation
- **Debian Templates** - Minimum 2GB RAM, 20GB storage
- **Windows Templates** - Minimum 4GB RAM, 60GB storage
- **Network** - Ensure adequate bandwidth for ISO downloads

### Storage Considerations
- **Local Storage** - Use for template building
- **Shared Storage** - Consider for production template storage
- **Backup** - Regular backup of completed templates

## Troubleshooting

### Common Issues

#### Permission Errors
```
Error: authentication failure
```
**Solution**: Verify Packer user has correct roles and permissions

#### Storage Issues
```
Error: unable to create VM disk
```
**Solution**: Check storage permissions and available space

#### Network Timeouts
```
Error: timeout waiting for SSH/WinRM
```
**Solution**: Verify network configuration and firewall rules

### Debug Mode

Enable debug mode for detailed logging:

```bash
# Enable debug logging
export PACKER_LOG=1
export PACKER_LOG_PATH=./packer.log

# Run build with debug output
packer build -debug -var-file=... build.pkr.hcl
```

## Integration with Terraform

These templates are designed to work seamlessly with the Terraform modules in this repository:

- Use template IDs generated by Packer in Terraform configurations
- Templates include cloud-init support for Terraform automation
- Compatible with the `vm_debian` and `vm_windows_server` Terraform modules

## Contributing

When contributing new templates or modifications:

1. Test templates in development environment
2. Update variable files with sensible defaults
3. Document any new requirements or features
4. Follow the existing project structure and naming conventions

## Security Considerations

- **Credentials** - Never commit passwords or sensitive data
- **Network Security** - Use secure connections (HTTPS) for Proxmox API
- **Template Security** - Regularly update base images and dependencies
- **Access Control** - Limit Packer user permissions to minimum required

## Notes

- Templates are optimized for Proxmox VE environments
- Windows templates require additional storage permissions
- Build times vary based on system resources and network speed
- Consider using local ISO caching for improved build performance
- Templates include QEMU Guest Agent for enhanced VM management
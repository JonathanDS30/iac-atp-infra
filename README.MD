# ATP Infrastructure as Code Project

<div align="center">
  <img src="docs/Logo ATP.png" alt="ATP Logo" width="800"/>
  
  **Association of Tennis Professionals - Global Infrastructure Automation**
  
  *Advanced Infrastructure as Code solution for ATP's worldwide operations*

[![Proxmox VE](https://img.shields.io/badge/Proxmox%20VE-8.3.0-orange.svg)](https://www.proxmox.com/)
[![Packer](https://img.shields.io/badge/Packer-1.13+-blue.svg)](https://www.packer.io/)
[![Terraform](https://img.shields.io/badge/Terraform-1.1+-purple.svg)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.1+-red.svg)](https://www.ansible.com/)
[![License](https://img.shields.io/badge/MIT-green.svg)](LICENSE)
[![Contributors](https://img.shields.io/badge/Contributors-4-brightgreen.svg)]()
[![Documentation](https://img.shields.io/badge/docs-available-brightgreen.svg)]()
[![Status](https://img.shields.io/badge/Status-Development-blue.svg)]()
</div>

---
## 🌍 Project Overview

This repository contains the complete Infrastructure as Code (IaC) solution for the **Association of Tennis Professionals (ATP)**, designed to modernize and centralize their global IT infrastructure simulation across four major sites: London (Headquarters), Florida (ATP Americas), Monaco (ATP Europe), and Sydney (ATP International).

> **🎓 Academic Project**: This project is developed as part of the **EPSI MSPR TPRE815** course within the **Mastère Expert Informatique et Système d'Information** program, demonstrating advanced skills in Infrastructure Architecture, Virtualization Technologies, Infrastructure as Code, Network Security, and Cloud Technologies.

> **🔗 Project Constraint**: This infrastructure is implemented using a **single Proxmox VE hypervisor** that hosts all virtual machines to simulate the multi-site ATP environment. Everything is virtualized to demonstrate enterprise-level infrastructure capabilities within a controlled lab environment.

### 🎯 Project Objectives

- **Simulate** and centralize heterogeneous IT systems across ATP's global locations
- **Virtualize** complete infrastructure using a single Proxmox VE hypervisor
- **Automate** virtual machine provisioning with Packer templates
- **Orchestrate** infrastructure deployment with Terraform modules
- **Demonstrate** enterprise-level networking and security concepts
- **Prepare** foundation for future cloud migration scenarios
- **Implement** Business Continuity (BCP) and Disaster Recovery (DRP) simulation

## 🏗️ Infrastructure Architecture

<div align="center">
  <img src="docs/Schema Infrastructure ATP.png" alt="ATP Infrastructure Schema" width="800"/>
</div>

### 🌐 Network Topology

The infrastructure emulates a globally distributed enterprise (ATP) by simulating multiple geographic sites interconnected through **IPsec VPN tunnels**, all hosted on a **single Proxmox VE hypervisor**.  
Each site is logically isolated via **VLANs and dedicated bridges**, offering realistic Layer 2/3 segmentation.

The VPN architecture follows a **Hub-and-Spoke model**:

- **London** acts as the **primary hub**, centralizing all traffic and services.
    
- **Monaco** serves as the **backup hub**, capable of assuming full operational responsibility in case of failure at London.
    
- Remote sites (Sydney, Ponte Vedra, Cloud Datacenter) operate as **spokes**, routing all inter-site communication through London or, if unavailable, through Monaco.

#### 📍 Sites & Network Segments

- 🏢 **London Headquarters**
    
    - **Server Network** (`172.22.0.0/16`)  
        Hosts core services including:
        
        - Active Directory (AD) & DNS
            
        - Remote Desktop Services (RDS)
            
        - File Synchronization Server
            
        - Zabbix Server for global monitoring
            
    - **User LAN** (`172.23.0.0/16`)  
        Local network for test clients, administrators, and internal users within the London site.
        

- 🇲🇨 **Monaco (Disaster Recovery Site)**
    
    - **Server Network** (`172.22.0.0/16` via VPN L2)  
        Monaco replicates London’s **server subnet** via a **Level 2 (L2) VPN tunnel**, allowing:
        
        - Seamless IP continuity
            
        - Automatic failover without reconfiguring addressing
            
        - Standby instances of AD, DNS, and RDS for PRA testing
            
    - **User LAN** (`172.24.0.0/16`)  
        Simulated local user environment within the Monaco site, with test clients and a monitoring proxy (Zabbix Proxy).
    
- 🌴 **Ponte Vedra Beach** (`172.26.0.0/16`)  
    Represents **ATP Americas operations**. Contains test clients and a replica domain controller, interconnected to London via IPsec site-to-site VPN.
    
- 🌏 **Sydney** (`172.29.0.0/16`)  
    Emulates the **ATP International Pacific** region. Includes clients and a monitoring proxy agent, connected to the global mesh via VPN.
    
- ☁️ **Cloud Datacenter** (`10.1.0.0/16`)  
    Simulated external cloud provider hosting a file-sharing platform (NextCloud).

## 🛠️ Technology Stack

### Core Infrastructure
- **Hypervisor**: Single Proxmox VE 8.3.0 instance hosting all virtual machines
- **Image Building**: HashiCorp Packer for automated VM template creation
- **Infrastructure Orchestration**: Terraform for infrastructure provisioning
- **Configuration Management**: Ansible for post-deployment configuration
- **Operating Systems**: Debian 12, Windows Server 2022
- **Network Simulation**: VLANs and virtual networks to simulate multi-site topology

### Automation Tools
- **Packer**: Automated VM template creation
- **Terraform**: Infrastructure provisioning and lifecycle management
- **Ansible**: Post-deployment configuration and maintenance
- **Cloud-Init/Cloudbase-Init**: VM initialization and cloud readiness

## 📁 Project Structure

```
iac-atp-infra/
├── 📄 README.MD                    # Project documentation
├── 📄 LICENSE                      # Project license
├── 📂 docs/                        # Project documentation
│   ├── 🖼️ Logo ATP.png             # ATP official logo
│   ├── 🖼️ Schema Infrastructure ATP.png # Network topology diagram
│   └── 📄 EISI - Sujet MSPR TPRE815.pdf # Project specifications
├── 📂 packer/                      # VM template automation
│   ├── 📄 config.pkr.hcl           # Global Packer configuration
│   ├── 📄 README.MD                # Packer documentation
│   ├── 📂 linux/                   # Linux template configurations
│   │   └── 📂 debian12/            # Debian 12 template
│   │       ├── 📄 build.pkr.hcl    # Debian build configuration
│   │       ├── 📄 debian-12.pkrvars.hcl # Debian variables
│   │       └── 📂 http/            # Automated installation configs
│   └── 📂 windows/                 # Windows template configurations
│       └── 📂 win2022-x64-fr/      # Windows Server 2022 template
│           ├── 📄 build.pkr.hcl    # Windows build configuration
│           ├── 📄 windows-server22.pkrvars.hcl # Windows variables
│           └── 📂 provision/       # Provisioning scripts and configs
│               ├── 📂 answer_files/ # Automated installation answers
│               ├── 📂 scripts/     # PowerShell provisioning scripts
│               │   ├── 📄 Setup.ps1 # Main orchestration script
│               │   └── 📂 modules/ # Modular provisioning components
│               │       ├── 📄 Install-Notepad.ps1
│               │       ├── 📄 Install-CloudbaseInit.ps1
│               │       ├── 📄 Configure-Network.ps1
│               │       ├── 📄 Configure-RemoteDesktop.ps1
│               │       ├── 📄 Reset-AutoLogon.ps1
│               │       ├── 📄 Cleanup-Apps.ps1
│               │       └── 📄 Run-Sysprep.ps1
│               └── 📂 tools/       # Configuration files
├── 📂 terraform/                   # Infrastructure orchestration
│   ├── 📄 main.tf                  # Main Terraform configuration
│   ├── 📄 providers.tf             # Provider configurations
│   ├── 📄 outputs.tf               # Infrastructure outputs
│   ├── 📄 credential.auto.tfvars   # Credentials (not in VCS)
│   └── 📂 modules/                 # Reusable Terraform modules
│       ├── 📂 networks/            # Network infrastructure module
│       ├── 📂 vm_debian/           # Debian VM deployment module
│       ├── 📂 vm_windows_server/   # Windows Server deployment module
│       └── 📂 lxc_debian/          # Debian LXC container module
└── 📂 ansible/                     # Configuration management
    ├── 📄 inventory.ini             # Ansible inventory
    └── 📄 README.MD                 # Ansible documentation
```

## 🚀 Getting Started

### Prerequisites

| Component | Version | Purpose |
|-----------|---------|---------|
| **Proxmox VE** | ≥ 8.0 | Single hypervisor hosting all virtual infrastructure |
| **Packer** | ≥ 1.4.0 | VM template automation |
| **Terraform** | ≥ 1.0.0 | Infrastructure orchestration |
| **Ansible** | ≥ 2.9 | Configuration management |
| **xorriso** | latest | ISO manipulation (Linux) |

### Proxmox VE Setup

1. **Create Packer Role**
```bash
sudo -i
pveum role add Packer -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
```

2. **Create Packer User**
```bash
pveum user add packer@pve --password <secure-password>
pveum aclmod / -user packer@pve -role Packer
```

3. **Additional Windows Permissions**
```bash
pveum aclmod /storage/local -user packer@pve -role PVEDatastoreAdmin
```

## 🏭 Building VM Templates

### Debian 12 Template
```bash
cd packer/
packer build -var-file=linux/debian12/debian-12.pkrvars.hcl linux/debian12/build.pkr.hcl
```

### Windows Server 2022 Template
```bash
cd packer/
packer build -var-file=windows/win2022-x64-fr/windows-server22.pkrvars.hcl windows/win2022-x64-fr/build.pkr.hcl
```

## 🌐 Infrastructure Deployment

### Initialize Terraform
```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

## 🔧 Technical Features

### 🖥️ VM Template Automation
- **Unattended Installation**: Automated OS installation with preseed/autounattend
- **Cloud-Init Ready**: Templates prepared for cloud-native deployments
- **Modular Architecture**: Organized provisioning scripts for maintainability
- **Automated Downloads**: Dynamic software installation from official sources
- **Multi-OS Support**: Both Linux (Debian 12) and Windows Server 2022

### 🏗️ Infrastructure Components

#### Network Infrastructure
- **Simulated Multi-site VPN**: IPsec tunnels between ATP virtual locations
- **VLAN Segmentation**: Isolated network zones for security and site separation
- **Virtual Firewall Integration**: Software-based firewalls for each simulated site
- **Centralized DNS/DHCP Services**: Network services management
- **SDN (Software-Defined Networking)**: Advanced Proxmox networking features

#### Compute Resources
- **Standardized VM Templates**: Cloud-ready virtual machines for consistent deployment
- **LXC Containers**: Lightweight containerized workloads for specific services
- **Resource Optimization**: Efficient allocation within single hypervisor constraints
- **Simulated High Availability**: Redundant services across virtual sites
- **Performance Monitoring**: Resource utilization tracking and optimization

#### Storage Solutions
- **Shared Storage**: Centralized file services
- **Data Replication**: Regular backups to London headquarters
- **Cloud Integration**: Hybrid cloud storage preparation

### 🔒 Security Implementation
- **Network Segmentation**: Isolated VLANs and subnets
- **VPN Encryption**: Secure site-to-site communications
- **Access Control**: Role-based access management
- **Audit Logging**: Comprehensive security monitoring

## 👥 Team and Contacts

- [Thomas GARCIA](https://github.com/Keods30)
- [Thibaut MAURRAS](https://github.com/Foufou-exe)
- [Jonathan DELLA SANTINA](https://github.com/JonathanDS30)
- [Joyce Leaticia LAETITIA](https://github.com/JoyceLeaticia)

## 📚 Documentation

For detailed technical documentation, please refer to:
- **[Packer Documentation](packer/README.MD)** - VM template automation
- **[Terraform Modules](terraform/modules/)** - Infrastructure orchestration


## 🤝 Contributing

This project follows professional development practices:

1. **Code Review**: All changes reviewed before integration
2. **Documentation**: Comprehensive documentation for all components
3. **Testing**: Validation in development environments
4. **Standards**: Adherence to industry best practices

## 📄 License

This project is developed for educational purposes as part of the EPSI.

---

<div align="center">
  <strong>ATP Infrastructure as Code Project</strong><br>
  <em>Professional Infrastructure Automation for Global Tennis Operations</em><br><br>

  <img src="docs/Logo EPSI.png" alt="ATP Logo" width="200"/>
  
  **EPSI - École Privée des Sciences Informatiques**<br>
  MSPR TPRE815
</div>

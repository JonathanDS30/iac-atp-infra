

############################################################################
################### Proxmox Node Configuration variables ###################
############################################################################

variable "proxmox_host" {
  description = "IP and Port of the Proxmox host."
  type        = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_insecure_tls" {
  description = "Skip validating the certificate."
  type        = bool
  default     = true
}

variable "vmid" {
  description = "The ID used to reference the virtual machine. If not given, the next free ID on the node will be used."
  type        = number
  default     = 0
}

variable "name" {
  description = "The name of the VM within Proxmox."
  type        = string
}

variable "description" {
  description = "The description of the VM. Shows as the 'Notes' field in the Proxmox GUI."
  type        = string
  default     = ""
}

variable "node" {
  description = "The name of the Proxmox Node on which to place the VM."
  type        = string
}

variable "pool" {
  description = "The resource pool to which the VM will be added."
  type        = string
  default     = ""
}

################################################
########## VM configuration variables ##########
################################################

variable "cpu_type" {
  description = "The type of CPU to emulate in the Guest."
  type        = string
  default     = "host"
}

variable "cpu_sockets" {
  description = "The number of CPU sockets to allocate to the VM."
  type        = number
  default     = 1
}

variable "cpu_cores" {
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  type        = number
  default     = 2
}

variable "memory" {
  description = "The amount of memory to allocate to the VM in Megabytes."
  type        = number
  default     = 2048
}

variable "disk_storage_pool" {
  description = "The name of the storage pool on which to store the disks."
  type        = string
  default     = "local"
}

variable "disk_size" {
  description = "The size of the created disk."
  type        = string
  default     = "5G"
}

variable "disk_format" {
  description = "The drive's backing file's data format."
  type        = string
  default     = "raw"
}

variable "disk_type" {
  description = "The type of disk device to add."
  type        = string
  default     = "scsi"
}

variable "disk_cache" {
  description = "The drive's cache mode."
  type        = string
  default     = "none"
}

variable "network_adapter" {
  description = "Bridge to which the network device should be attached."
  type        = string
  default     = "vmbr0"
}

variable "network_adapter_model" {
  description = "Network Card Model."
  type        = string
  default     = "virtio"
}

variable "network_adapter_mac" {
  description = "Override the randomly generated MAC Address for the VM."
  type        = string
  default     = null
}

variable "network_adapter_vlan" {
  description = "The VLAN tag to apply to packets on this device."
  type        = number
  default     = -1
}

variable "network_adapter_firewall" {
  description = "Whether to enable the Proxmox firewall on this network device."
  type        = bool
  default     = false
}

variable "vga_type" {
  description = "The type of display to virtualize."
  type        = string
  default     = "std"
}

variable "vga_memory" {
  description = "Sets the VGA memory (in MiB)."
  type        = number
  default     = 32
}

variable "os" {
  description = "The operating system."
  type        = string
  default     = "l26"
}

variable "scsi_controller" {
  description = "The SCSI controller model to emulate."
  type        = string
  default     = "virtio-scsi-pci"
}

variable "start_at_boot" {
  description = "Whether to have the VM startup after the PVE node starts."
  type        = bool
  default     = true
}

variable "qemu_agent" {
  description = "Whether to enable the QEMU Guest Agent. qemu-guest-agent daemon must run the in the quest."
  type        = bool
  default     = true
}

variable "bios" {
  description = "Set the machine bios."
  type        = string
  default     = "ovmf"
}

variable "iso_download" {
  description = "Wether to download from iso_url or use the existing iso_file in the iso_storage_pool."
  type        = bool
  default     = false
}

variable "iso_download_pve" {
  description = "Download the specified `iso_url` directly from the PVE node."
  type        = bool
  default     = false
}

variable "iso_url" {
  description = "URL to the iso file."
  type        = string
}

variable "iso_checksum" {
  description = "Checksum of the iso file"
  type        = string
}

variable "iso_file" {
  description = "Name of the iso file"
  type        = string
}

variable "iso_storage_pool" {
  description = "Storage pool of the iso file"
  type        = string
  default     = "local"
}

variable "iso_unmount" {
  description = "Wether to remove the mounted ISO from the template after finishing."
  type        = bool
  default     = true
}

variable "cloud_init" {
  description = "Wether to add a Cloud-Init CDROM drive after the virtual machine has been converted to a template."
  type        = bool
  default     = true
}

variable "cloud_init_storage_pool" {
  description = "Name of the Proxmox storage pool to store the Cloud-Init CDROM on."
  type        = string
  default     = "local"
}

variable "additional_iso_files" {
  description = "Additional ISO files attached to the virtual machine."
  type = list(object({
    device       = string
    iso_file     = string
    iso_url      = string
    iso_checksum = string
  }))
  default = []
}

variable "additional_cd_files" {
  description = "Additional files attached to the virtual machine as iso."
  type = list(object({
    device = string
    files  = list(string)
  }))
  default = []
}

variable "boot_command" {
  description = "The keys to type when the virtual machine is first booted in order to start the OS installer."
  type        = list(string)
}

variable "boot_wait" {
  description = "The time to wait before typing boot_command."
  type        = string
  default     = "10s"
}

variable "task_timeout" {
  description = "The timeout for Promox API operations, e.g. clones"
  type        = string
  default     = "2m"
}

variable "http_directory" {
  description = "Path to a directory to serve using an HTTP server."
  type        = string
  default     = "./http"
}

variable "communicator" {
  description = "The packer communicator to use"
  type        = string
  default     = "ssh"
}

variable "ssh_username" {
  description = "The ssh username to connect to the guest"
  type        = string
  default     = "packer"
}

variable "ssh_password" {
  description = "The ssh password to connect to the guest"
  type        = string
  default     = "packer"
}

variable "ssh_timeout" {
  description = "The timeout waiting for ssh connection"
  type        = string
  default     = "30m"
}

variable "winrm_username" {
  description = "The winrm username to connect to the guest"
  type        = string
  default     = "Administrator"
}

variable "winrm_password" {
  description = "The winrm password to connect to the guest"
  type        = string
  default     = "packer"
}

variable "winrm_insecure" {
  description = "Skip validating the winrm ssl certificate."
  type        = bool
  default     = true
}

variable "winrm_use_ssl" {
  description = "Use winrm ssl connection."
  type        = bool
  default     = false
}

variable "winrm_port" {
  description = "The port to connect to the winrm service."
  type        = number
  default     = 5986
}

variable "winrm_timeout" {
  description = "The timeout for winrm operations."
  type        = string
  default     = "60m"
}

variable "winrm_use_ntlm" {
  description = "Use NTLM authentication for winrm."
  type        = bool
  default     = false
}


#######################################################################################

source "proxmox-iso" "vm" {
  proxmox_url              = "https://${var.proxmox_host}:8006/api2/json"
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = var.proxmox_insecure_tls

  vm_id                = var.vmid
  vm_name              = var.name
  template_name        = var.name
  template_description = var.description == "" ? "${var.name}, generated by packer at ${formatdate("YYYY-MM-DD hh:mm:ss", timestamp())}" : var.description
  node                 = var.node
  pool                 = var.pool

  cpu_type = var.cpu_type
  sockets  = var.cpu_sockets
  cores    = var.cpu_cores
  memory   = var.memory

  disks {
    storage_pool      = var.disk_storage_pool
    disk_size         = var.disk_size
    format            = var.disk_format
    type              = var.disk_type
    cache_mode        = var.disk_cache
  }

  efi_config {
    efi_storage_pool  = "local-lvm"
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  network_adapters {
    bridge      = var.network_adapter
    model       = var.network_adapter_model
    mac_address = var.network_adapter_mac
    vlan_tag    = var.network_adapter_vlan == -1 ? "" : "${var.network_adapter_vlan}"
    firewall    = var.network_adapter_firewall
  }

  vga {
    type   = var.vga_type
    memory = var.vga_memory
  }

  os              = var.os
  scsi_controller = var.scsi_controller
  onboot          = var.start_at_boot
  qemu_agent      = var.qemu_agent
  bios            = var.bios

  iso_file         = var.iso_download ? "" : "${var.iso_storage_pool}:iso/${var.iso_file}"
  iso_storage_pool = var.iso_storage_pool
  iso_url          = var.iso_download ? var.iso_url : ""
  iso_checksum     = var.iso_checksum
  iso_download_pve = var.iso_download_pve
  unmount_iso      = var.iso_unmount


  machine = "pc-q35-9.2"

  dynamic "additional_iso_files" {
    for_each = var.additional_iso_files
    content {
      device           = additional_iso_files.value.device
      iso_file         = var.iso_download ? "" : "${var.iso_storage_pool}:iso/${additional_iso_files.value.iso_file}"
      iso_storage_pool = var.iso_storage_pool
      iso_url          = var.iso_download ? additional_iso_files.value.iso_url : ""
      iso_checksum     = additional_iso_files.value.iso_checksum
      iso_download_pve = var.iso_download_pve
      unmount          = var.iso_unmount
    }
  }

  dynamic "additional_iso_files" {
    for_each = var.additional_cd_files
    content {
      device           = additional_iso_files.value.device
      iso_storage_pool = var.iso_storage_pool
      cd_files         = additional_iso_files.value.files
      unmount          = var.iso_unmount
    }
  }

  cloud_init              = var.cloud_init
  cloud_init_storage_pool = var.cloud_init_storage_pool

  boot           = "order=${var.disk_type}0;ide2;net0"
  boot_command   = var.boot_command
  boot_wait      = var.boot_wait
  task_timeout   = var.task_timeout
  http_directory = var.http_directory
  communicator   = var.communicator
  ssh_username   = var.ssh_username
  ssh_password   = var.ssh_password
  ssh_timeout    = var.ssh_timeout
  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
  winrm_insecure = var.winrm_insecure
  winrm_use_ssl  = var.winrm_use_ssl
  winrm_port     = var.winrm_port
  winrm_timeout  = var.winrm_timeout
  winrm_use_ntlm = var.winrm_use_ntlm
}

build {
  name    = "windows"
  sources = ["source.proxmox-iso.vm"]

  provisioner "powershell" {
    script = "windows-server22/setup.ps1"
  }
}

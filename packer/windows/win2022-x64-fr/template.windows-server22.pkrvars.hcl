#windows-server22.pkrvars.hcl

# Proxmox Node Configuration
node = "Your Proxmox Node Name" # Hostname must be written exactly as it appears in Proxmox 
proxmox_host = "Your Proxmox Host IP or FQDN"
proxmox_api_token_id     = "packer@pve!packer"
proxmox_api_token_secret = "Your Secret Token Here"

# VM General Configuration
vmid = 9300
name = "win22-template"
description = "Template with packer for Windows Server 2022 x64 French"


# VM Hardware Configuration
cpu_cores = 4
cpu_sockets = 1
cpu_type = "host"
memory = 4096

# VM OS Configuration
os = "win11"
bios = "ovmf"
qemu_agent = true
scsi_controller = "virtio-scsi-single"
start_at_boot = false



# Boot and Communication Configuration
communicator = "winrm"
winrm_username = "Administrateur"
winrm_password = "Packer30!"
winrm_timeout = "60m"
winrm_insecure = true
winrm_use_ssl = true
winrm_port = 5986
  # Boot
  boot_wait = "3s"
  boot_command = [
    "<enter>"
  ]
task_timeout = "60m"

# ISO Configuration
iso_file = "Windows_Server_2022.iso"
iso_storage_pool = "local"
iso_url = ""
iso_checksum = ""
iso_download = false
iso_download_pve = false
iso_unmount = true

additional_iso_files = [
  {
    device = "ide3"
    iso_file = "virtio-win-0.1.271.iso"
    iso_storage_pool = "local"
    iso_url = ""
    iso_checksum = ""
    iso_download_pve = false
    iso_unmount = false
  }
]

# Additional CD files
additional_cd_files = [
  {
    device = "sata3"
    files = [
      "windows/win2022-x64-fr/provision/answer_files/autounattend.xml", 
      "windows/win2022-x64-fr/provision/scripts/Enable-WinRM.ps1",
      "windows/win2022-x64-fr/provision/scripts/modules/",
      "windows/win2022-x64-fr/provision/tools/"
    ]
  }
]

# HTTP Directory for Autounattend and Scripts
http_directory = ""

# VM Storage Configuration
disk_size = "50G"
disk_storage_pool = "local-lvm"
disk_format = "raw"
disk_type = "scsi"
disk_cache = "none"

# VM Network Configuration
network_adapter = "vmbr0"
network_adapter_model = "virtio"
network_adapter_mac = ""
network_adapter_vlan = -1
network_adapter_firewall = false

# VM VGA Configuration
vga_type = "std"
vga_memory = 32

# Cloud-init Configuration
cloud_init = true
cloud_init_storage_pool = "local-lvm"


# Post-installation Scripts
provisioner = []
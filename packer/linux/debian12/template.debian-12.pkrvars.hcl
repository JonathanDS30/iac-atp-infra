#debian-12.pkrvars.hcl

# Proxmox Node Configuration
node = "Your Proxmox Node Name" # Hostname must be written exactly as it appears in Proxmox 
proxmox_host = "Your Proxmox Host IP or FQDN"
proxmox_api_token_id     = "packer@pve!packer"
proxmox_api_token_secret = "Your Secret Token Here"


# VM General Configuration
vmid                = 9200
name           = "debian-12-template"

# VM OS Configuration
iso_file       = "debian-12.9.0-amd64-netinst.iso"
iso_url       = ""
iso_checksum   = "sha512:9ebe405c3404a005ce926e483bc6c6841b405c4d85e0c8a7b1707a7fe4957c617ae44bd807a57ec3e5c2d3e99f2101dfb26ef36b3720896906bdc3aaeec4cd80"

# VM Configuration
disk_size         = "20G"
disk_storage_pool  = "local-lvm"
http_directory = "./debian12/http/debian"
boot_command = [
  "<esc><wait>",
  "install ",
  " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
  "auto ", "locale=en_US.UTF-8 ",
  "kbd-chooser/method=us ",
  "keyboard-configuration/xkb-keymap=us ",
  "netcfg/get_hostname=debian ",
  "netcfg/get_domain=local ",
  "fb=false ",
  "debconf/frontend=noninteractive ",
  "console-setup/ask_detect=false ",
  "console-keymaps-at/keymap=us ",
  "grub-installer/bootdev=/dev/sda ",
  "passwd/username=packer ",
  "passwd/user-fullname=packer ",
  "passwd/user-password=packer ",
  "passwd/user-password-again=packer ",
  "<enter>"
]
provisioner = [
  "userdel --remove --force packer"
]
# This file demonstrates how to use the Terraform modules for creating VMs and networks.

# Executing using the Terraform module for creating a Debian VM
# module "vm_debian1" {
#   source = "./modules/vm_debian"
#   node_name = "SRV-PMX"
#   template_id = 9101
#   vm_name = "TestVM"
#   tags = [ "test","another" ]
#   description = "Test VM for Terraform"
#   disk_size = 50
#   datastore_id = "local-lvm"
#   bridge = "vmbr1"
#   ip_address = "172.16.0.12"
#   netmask = 24
#   gateway = "172.16.0.254"
#   username = "user-jd"
#   password = "test"
#   keys = [file("~/.ssh/id_rsa.pub")]
# }

# Executing using the Terraform module for creating a network interface
# module "test_network" {
#   source = "./modules/networks"
#   node_name = "SRV-PMX"
#   network_interface_name = "testModule"
#   address = "172.25.0.0/24"
#   comment = "Test Network Interface"
#   autostart_network_interfaces = true
# }

# Executing using the Terraform module for creating a Windows Server VM
module "vm_windows_server1" {
  source = "./modules/vm_windows_server"
  node_name = "SRV-PMX"
  template_id = 9300
  vm_name = "Test-13"
  memory = 4096
  disk_size = 80
  datastore_id = "local-lvm"
  bridge = "vmbr1"
  ip_address = "172.16.0.13"
  netmask = 24
  gateway = "172.16.0.254"
  password = "Password123!"
}


# Executing using the Terraform module for creating a Windows Server VM
# module "vm_windows_server2" {
#   source = "./modules/vm_windows_server"
#   node_name = "SRV-PMX"
#   template_id = 9251
#   vm_name = "Test-14"
#   memory = 4096
#   disk_size = 80
#   datastore_id = "local-lvm"
#   bridge = "vmbr1"
#   ip_address = "172.16.0.14"
#   netmask = 24
#   gateway = "172.16.0.254"
#   password = "Password123!"
# }

# Executing using the Terraform module for creating a Debian LXC container
# module "debian_container" {
#   source = "./modules/lxc_debian"
#   node_name = "SRV-PMX"
#   template_file_id = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
#   hostname = "debian-container"
#   tags = ["container"]
#   description = "Debian LXC Container for testing"
#   cores = 2
#   cpu_units = 1024
#   memory = 512
#   datastore_id = "local-lvm"
#   disk_size = 8
#   network_interface_name = "eth0"
#   bridge = "vmbr1"
#   vlan_id = 0
#   firewall = false
#   network_enabled = true
#   ip_address = "172.16.0.42/24"
#   gateway = "172.16.0.254"
#   password = "test123"
#   ssh_keys = [file("~/.ssh/id_rsa.pub")]
  
# }
# Executing using the Terraform module for creating a Debian VM
module "vm_debian1" {
  source = "./modules/vm_debian"
  node_name = "SRV-PMX"
  template_id = 9101
  vm_name = "TestVM"
  disk_size = 50
  datastore_id = "local-lvm"
  bridge = "vmbr1"
  ip_address = "172.16.0.12"
  netmask = 24
  gateway = "172.16.0.254"
  username = "user-jd"
  password = "test"
  keys = [file("~/.ssh/id_rsa.pub")]
}

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
module "vm_windows_server" {
  source = "./modules/vm_windows_server"
  node_name = "SRV-PMX"
  template_id = 9007
  vm_name = "WinServer-Test"
  memory = 4096
  disk_size = 60
  datastore_id = "local-lvm"
  bridge = "vmbr1"
  ip_address = "172.16.0.13"
  netmask = 24
  gateway = "172.16.0.254"
  username = "Administrateur"
  password = "test"
}
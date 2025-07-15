module "vm_debian1" {
  source = "./modules/vm_debian"
  node_name = "SRV-PMX"
  template_id = 9101
  vm_name = "TestVM"
  disk_size = 50
  datastore_id = "local-lvm"
  ip_address = "192.168.1.50"
  netmask = 24
  gateway = "192.168.1.254"

  username = "user-jd"
  password = "test"
  keys = [file("~/.ssh/id_rsa.pub")]
}
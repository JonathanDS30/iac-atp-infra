output "vm_id" {
  value = module.vm_debian1.vm_id
}

output "vm_ip" {
  value = module.vm_debian1.ip
}

output "vm_name" {
  value = module.vm_debian1.name
}

output "network_interface_name" {
  value = module.test_network.network_interface_name
}

output "network_address" {
  value = module.test_network.address
}
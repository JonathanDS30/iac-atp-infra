resource "proxmox_virtual_environment_network_linux_bridge" "network_interface" {

  node_name = var.node_name
  name      = var.network_interface_name
  address   = var.address
  comment   = var.comment
  autostart = var.autostart_network_interfaces
}
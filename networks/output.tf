output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_cidr" {
  value = azurerm_virtual_network.vnet.address_space
}

output "public_subnet_ids" {
  value = azurerm_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = azurerm_subnet.private_subnet[*].id
}
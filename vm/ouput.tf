output "vm_id"{
    value =  azurerm_virtual_machine.vm.id
}

output "publicip"{
    value = azurerm_public_ip.pubip[0].ip_address
}
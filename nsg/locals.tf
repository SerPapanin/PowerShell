locals { 
nsgrules = {
   
    rdp = {
      name                       = "Allow_RDP"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
 
    ssh = {
      name                       = "Allow_SSH"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
 
    monitor = {
      name                       = "Allow_Monitor"
      priority                   = 1100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6654"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
 
}
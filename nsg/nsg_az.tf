
#Create Network Security group
resource "azurerm_network_security_group" "nsg" {
  count               = length(var.public_subnet_ids)
  name                = "nsg-${var.env}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.rg_name


#Create netowrk rules
 security_rule {
  name                        = "Allow_SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "22"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  }
 security_rule {
  name                        = "Allow_RDP"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "3389"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  }
  /*security_rule {
  name                        = "Allow_Monitor"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6654"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  }*/
}
locals {
  local_nsg = (var.env == "PROD" ? azurerm_network_security_group.nsg : [])
}
#local.local_nsg = (var.env == "PROD") ? azurerm_network_security_group.nsg : []

resource "azurerm_network_security_rule" "ns_monitor"{
  for_each = local_nsg
  name                        = "Allow_Monitor"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6654"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = each.value
  }


resource "azurerm_subnet_network_security_group_association" "grassoc" {
  count                     = length(var.public_subnet_ids)
  subnet_id                 = var.public_subnet_ids[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[count.index].id
}

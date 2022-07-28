#Network module


# Create virtual network
resource "azurerm_virtual_network" "ExitVNet" {
    name                = "Vnet-${var.env}"
    address_space       = ["10.0.0.0/16"]
    location            = var.az_region
    resource_group_name = azurerm_resource_group.rg-panin.name

    tags = {
        environment = "Terraform Networking"
    }
}
# Create subnets
resource "azurerm_subnet" "publicsub" {
    name                 = "PublicSub"
    resource_group_name  = azurerm_resource_group.panin_exit_dev.name
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "privatesub" {
    name                 = "PrivateSub"
    resource_group_name  = azurerm_resource_group.panin_exit_dev.name
    virtual_network_name = azurerm_virtual_network.TFNet.name
    address_prefixes     = ["10.0.2.0/24"]
}

#Create Network Security group
resource "azurerm_network_security_group" "nsg" {
  name                = "LabNSG"
  location            = azurerm_resource_group.panin_exit_dev.location
  resource_group_name = azurerm_resource_group.panin_exit_dev.name


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

  security_rule {
  name                        = "Allow_Monitor"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6654"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "grassoc" {
  subnet_id                 = azurerm_subnet.publicsub.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
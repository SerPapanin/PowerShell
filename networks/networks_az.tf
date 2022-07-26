# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-${var.env}"
    address_space       = var.vnet_cidr
    location            = var.location
    resource_group_name = var.rg_name

    tags = {
        environment = "vnet-${var.env}"
    }
}

# Create subnets
#-------------Public Subnets ----------------------------------------
resource "azurerm_subnet" "public_subnet" {
  count                = length(var.public_subnet_cidrs)
  name                 = "public-${var.env}-${count.index + 1}"
  address_prefixes     = [element(var.public_subnet_cidrs, count.index)]
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}
#-------------Private Subnets ----------------------------------------
resource "azurerm_subnet" "private_subnet" {
  count                = length(var.private_subnet_cidrs)
  name                 = "private-${var.env}-${count.index + 1}"
  address_prefixes     = [element(var.private_subnet_cidrs, count.index)]
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

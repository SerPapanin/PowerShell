terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.25.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
  backend "azurerm" {
    resource_group_name  = "DefaultResourceGroup-EUS"
    storage_account_name = "paninstor123654"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
  #skip_provider_registration = true
}

#Create resource group
resource "azurerm_resource_group" "panin_exit_dev" {
  name     = "rg-dev"
  location = "eastus"
}

# Create virtual network
resource "azurerm_virtual_network" "TFNet" {
    name                = "LabVnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.panin_exit_dev.location
    resource_group_name = azurerm_resource_group.panin_exit_dev.name

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

#Deploy Public IP
resource "azurerm_public_ip" "pubip1" {
  name                = "pubip1"
  location            = azurerm_resource_group.panin_exit_dev.location
  resource_group_name = azurerm_resource_group.panin_exit_dev.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

#Create NIC
resource "azurerm_network_interface" "nicvm01" {
  name                = "nicvm01"  
  location            = azurerm_resource_group.panin_exit_dev.location
  resource_group_name = azurerm_resource_group.panin_exit_dev.name

    ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsub.id 
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip1.id
  }
}
#Create Boot Diagnostic Account
resource "azurerm_storage_account" "sa" {
  name                     = "diagnosticaccountvm01dev" 
  resource_group_name      = azurerm_resource_group.panin_exit_dev.name
  location                 = azurerm_resource_group.panin_exit_dev.location
   account_tier            = "Standard"
   account_replication_type = "LRS"

   tags = {
    environment = "Boot Diagnostic Storage"
    CreatedBy = "Admin"
   }
  }

#Create Virtual Machine
resource "azurerm_virtual_machine" "example" {
  name                  = "VM01"  
  location              = azurerm_resource_group.panin_exit_dev.location
  resource_group_name   = azurerm_resource_group.panin_exit_dev.name
  network_interface_ids = [azurerm_network_interface.nicvm01.id]
  vm_size               = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk1"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "PaninUbuntu"
    admin_username = "paninmadmin"
    admin_password = "Password12345!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
    }
}
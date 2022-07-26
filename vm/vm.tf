#Deploy Public IP
resource "azurerm_public_ip" "pubip" {
  count = var.ifpub ? 1 : 0
  name                = "pubipvm-${var.env}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

#Create NIC
resource "azurerm_network_interface" "nicvm" {
  name                = "nicvm-${var.env}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig-${var.env}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.ifpub ? azurerm_public_ip.pubip[0].id : ""
  }
}

#Create Virtual Machine
resource "azurerm_virtual_machine" "vm" {
  name                             = "vm-${var.env}"
  location                         = var.location
  resource_group_name              = var.rg_name
  network_interface_ids            = [azurerm_network_interface.nicvm.id]
  vm_size                          = "Standard_B1s"
  delete_os_disk_on_termination    = true
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
}
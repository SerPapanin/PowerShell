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
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
resource "azurerm_storage_account" "lab" {
  name                     = "terraformlab123"
  resource_group_name      = "156-8a5da661-deploy-an-azure-storage-account-with"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform Storage"
    CreatedBy   = "Admin"
  }
}
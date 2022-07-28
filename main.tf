#Root module
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
  backend "azurerm" {}
}
provider "azurerm" {
  features {}
  #skip_provider_registration = true
}

#Create resource group
resource "azurerm_resource_group" "rg-panin" {
  name     = "rg-${terraform.workspace}"
  location = var.az_region
}

module "vnet" {
  source               = "./networks/"
  env                  = terraform.workspace
  rg_name              = azurerm_resource_group.rg-panin.name
  location             = var.az_region
  vnet_cidr            = var.vnet_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
module "nsg" {
  source               = "./nsg/"
  env                  = terraform.workspace
  rg_name              = azurerm_resource_group.rg-panin.name
  location             = var.az_region
  public_subnet_ids    = module.vnet.public_subnet_ids
}
module "vm_private" {
    source = "./vm/"
    env                = terraform.workspace
    rg_name            = azurerm_resource_group.rg-panin.name
    location           = var.az_region
    subnet_id          = module.vnet.private_subnet_ids[0]
    ifpub              = false
}
module "vm_public" {
    source = "./vm/"
    env                = terraform.workspace
    rg_name            = azurerm_resource_group.rg-panin.name
    location           = var.az_region
    subnet_id          = module.vnet.private_subnet_ids[0]
    ifpub              = true
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "chris-ms-data"
    storage_account_name  = "vuggietfstate"
    container_name        = "tstate-tier2"
    key                   = "terraform.tfstate"
  }
}

locals {
  name-convention = "${var.environment}-${var.location}-${var.tier}"
}

# This is a shared Component
module "network" {
  source        = "./network"
  mgmt-rg       = "${local.name-convention}-mgmt-resources"
  location      = var.location
}

provider "azurerm" {
  features {}
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

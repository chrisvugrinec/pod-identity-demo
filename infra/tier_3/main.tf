provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "chris-ms-data"
    storage_account_name  = "vuggietfstate"
    container_name        = "tstate-tier3"
    key                   = "terraform.tfstate"
  }
}

locals {
  name-convention = "${var.environment}-${var.location}-${var.tier}"
}

# This is a shared Component
module "app1-team" {
  source        = "./app-team"
  aks-name      = "aks-demo-app1"
  id-name      = "uaid-demo-app1"
  keyvault-name = "keyvault-demo-app1"
  rg-name       = "${local.name-convention}-demo-resources"
  location      = var.location
  aks-vnet      = var.aks-vnet
  mgmt-rg       = "${var.environment}-${var.location}-${var.mgmt-tier}-mgmt-resources"
  aks-subnet-cidr = "15.1.1.0/24"
}

output "kube_id" {
  value = module.app1-team.kube_id
}

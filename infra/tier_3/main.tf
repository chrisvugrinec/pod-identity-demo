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
  name-convention = "podidentities"
}

# This is a shared Component
module "app1-team" {
  source        = "./app-team"
  aks-name      = "aks-demo-app1"
  id-name      = "uaid-demo-app1"
  keyvault-name = "akv-${local.name-convention}-demo"
  rg-name       = "${local.name-convention}-demo-resources"
  location      = var.location
  aks-vnet      = var.aks-vnet
  mgmt-rg       = "${local.name-convention}-mgmt-resources"
  aks-subnet-cidr = "15.1.1.0/24"
}

output "kube_id" {
  value = module.app1-team.kube_id
}

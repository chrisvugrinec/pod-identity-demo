resource "random_string" "random-namespace" {
  length  = 10
  special = false
}

variable "tags" {
  type = map
  default = {
    environment = "demo"
    source      = "microsoft"
  }
}

variable "environment" {
  default = "dev"
}

variable "tier" {
  default = "2"
}

variable "resourcetype" {
  default = "aks"
}

variable "location" {
  default = "australiaeast"
}

terraform {
  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

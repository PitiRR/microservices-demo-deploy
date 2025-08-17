# Assuming values from README.md
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatemicroservicesdemo"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

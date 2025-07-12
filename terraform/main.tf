# Resource group for all resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "core_infra" {
  source = "./modules/core-infra"

  resource_group_name = rg.name
  location            = rg.location

  depends_on = [ azurerm_resource_group.rg ]
}
  
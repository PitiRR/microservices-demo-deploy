module "core_infra" {
  source = "./modules/core-infra"

  resource_group_name = "rg-boutique-shop-prod"
  location            = "West Europe"
}
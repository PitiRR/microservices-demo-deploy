module "core_infra" {
  source = "./modules/core-infra"

  resource_group_name = var.infra_rg_name
  location            = var.infra_rg_location
}
  
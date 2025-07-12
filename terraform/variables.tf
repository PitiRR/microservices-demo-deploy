variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
  default     = "BoutiqueShopProd"
}
variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed."
  default     = "West Europe"
}

variable "backend_storage_account_name" {
  type        = string
  description = "The name of the storage account for Terraform state."
  default     = "tfstateboutiqueshopprod"
}

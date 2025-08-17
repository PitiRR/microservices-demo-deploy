variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
  default     = "BoutiqueShopProd"
}

variable "infra_rg_name" {
  type        = string
  description = "The name of the infrastructure resource group."
  default     = "boutiqueshopprod"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed."
  default     = "West Europe"
}

variable "infra_rg_location" {
  type        = string
  description = "The location for the infrastructure resource group."
  default     = "West Europe"
}

variable "backend_storage_account_name" {
  type        = string
  description = "The name of the storage account for Terraform state."
  default     = "tfstateboutiqueshopprod"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  sensitive   = true
}

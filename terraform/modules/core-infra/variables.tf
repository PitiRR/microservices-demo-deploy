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

variable "node_count" {
  description = "The number of worker nodes for the AKS cluster."
  type        = number
  default     = 1
}

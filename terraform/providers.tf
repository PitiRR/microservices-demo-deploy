terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.35.0"
    }
  }
}
# Prevent backend from storing secrets
ephemeral "azure_subscription" "subscription_id"{
  value = azure_subscription.subscription_id.value
}
locals { 
  subscription_id = jsondecode(ephemeral.azure_subscription.subscription_id.value).value
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

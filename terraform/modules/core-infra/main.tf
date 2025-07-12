
# Resoruce group for all resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Private Docker registry for docker images
resource "azurerm_container_registry" "acr" {
  name                = "acr${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true # Easy login - temporary
}

# AKS cluster to run the boutique app
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns-${var.resource_group_name}"

  # Worker nodes
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  # Allow AKS to securely manage other resources like LBs.
  identity {
    type = "SystemAssigned"
  }
}
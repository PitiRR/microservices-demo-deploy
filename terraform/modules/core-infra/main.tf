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
    node_count = 3
    vm_size    = "Standard_B2s"
  }

  # Allow AKS to securely manage other resources like LBs.
  identity {
    type = "SystemAssigned"
  }
}

# Caching
resource "azurerm_redis_cache" "redis" {
  name                 = "microservicesdemo-redis"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  capacity             = 1
  family               = "C"
  sku_name             = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"

  redis_configuration {
  }
}

# Event Hub for data ingestion
resource "azurerm_eventhub_namespace" "data_pipeline" {
  name                = "eh-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
}

# Storage Account for Data Lake
resource "azurerm_storage_account" "datalake" {
  name                     = "sadl${var.resource_group_name}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true # Enables Data Lake functionality
}

# Databricks for data analysis
resource "azurerm_databricks_workspace" "data_pipeline" {
  name                = "${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "standard"
}
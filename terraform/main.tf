# Define Azure Provider and Terraform Remote State
# NOTE: Replace 'tfstateuniqueid' with your actual, globally unique storage account name
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateadocapstone" 
    container_name       = "tfstate"
    key                  = "aks-microservices.tfstate"
  }
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false # Security best practice: use identity instead of admin user
}

# 3. Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.aks_cluster_name}-dns"

  default_node_pool {
    name       = "systempool"
    node_count = 2 # Start with 2 nodes for high availability
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned" # Use System Assigned Identity for the cluster control plane
  }

  # Enable Azure RBAC for Kubernetes authorization
  azure_active_directory_role_based_access_control {
   # managed = true
    azure_rbac_enabled = true
  }
}

# 4. Grant AKS Kubelet Identity access to ACR (IAM Role Assignment)
# This allows the AKS nodes to pull Docker images from the ACR securely.
resource "azurerm_role_assignment" "acr_pull_role" {
  # The principal is the Kubelet Managed Identity
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull" # Role to pull images
  scope                = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# 5. Azure Key Vault (AKV)
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "akv" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
}

resource "azurerm_key_vault_secret" "app_version_secret" {
  name         = "AppVersion"
  value        = "v1.0.0-initial" # Initial version used by the CI/CD pipeline
  key_vault_id = azurerm_key_vault.akv.id
}

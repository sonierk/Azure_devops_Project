# Outputs necessary for the CI/CD Pipeline

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  description = "The name of the resource group containing all resources."
  value       = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  description = "The login server URL for the Azure Container Registry (ACR)."
  value       = azurerm_container_registry.acr.login_server
}

output "key_vault_name" {
  description = "The name of the Azure Key Vault."
  value       = azurerm_key_vault.akv.name
}

# Variable Definitions for the Azure Microservice Infrastructure

variable "location" {
  description = "The Azure region for all resources (e.g., East US, West Europe)"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group that will contain all services."
  type        = string
  default     = "rg-microservices-capstone"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
  default     = "aks-microservices-prod"
}

variable "acr_name" {
  description = "The globally unique name of the Azure Container Registry."
  type        = string
  default     = "acrbluegreencapstone01" # MUST be unique and lowercase
}

variable "key_vault_name" {
  description = "The name of the Azure Key Vault for application secrets."
  type        = string
  default     = "akv-capstone-secrets"
}

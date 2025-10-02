terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use a version appropriate for your environment
    }
  }
}

# Configure the Azure Provider to use the environment variables
provider "azurerm" {
  features {} # The features block is required but can be empty for default settings
}
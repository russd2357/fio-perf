provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks-rg" {
  name     = "aks-rg"
  location = var.azure_location
}

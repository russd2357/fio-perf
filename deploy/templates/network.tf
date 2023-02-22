resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "akssubnet" {
  name                 = "akssubsubnet"
  resource_group_name  = azurerm_resource_group.aks-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/16"]
  service_endpoints    = ["Microsoft.Storage"]
}


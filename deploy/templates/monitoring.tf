resource "random_string" "random" {
  length = 13
  upper = false
  special = false

}

resource "azurerm_log_analytics_workspace" "law_c" {
  name                = "law${random_string.random.result}"
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
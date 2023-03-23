terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.31.0"
    }
  }

  
  backend "azurerm" {
      resource_group_name  = "var.tf_state_rg_name"
      storage_account_name = "var.tf_state_sa_name" 
      container_name       = "var.tf_state_container_name" 
      key                  = "var.tf_state_key" 
  }
}

provider "azurerm" {
  features {}
}



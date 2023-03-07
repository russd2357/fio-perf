output "storage_account_name" {
  value = var.nfs_share_enabled ? null : azurerm_storage_account.storage_account.name 
}

output "primary_access_key" {
  value = var.nfs_share_enabled ? null : nonsensitive(azurerm_storage_account.storage_account.primary_access_key) 
}

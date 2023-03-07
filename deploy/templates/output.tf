output "storage_account_name" {
  value = var.nfs_share_enabled ? null : azurerm_storage_account.storage_account.name 
}

output "primary_access_key" {
  # Note nonsensitive is not recommended for production use
  # This is used here only to simplify the deployment of this sample
  value = var.nfs_share_enabled ? null : nonsensitive(azurerm_storage_account.storage_account.primary_access_key) 
}

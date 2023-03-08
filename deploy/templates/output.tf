output "storage_account_name" {
  value = var.nfs_share_enabled ? null : azurerm_storage_account.storage_account.name 
}

output "primary_access_key" {
  # Note nonsensitive is not recommended for production use
  # This is used here only to simplify the deployment of this sample
  value = var.nfs_share_enabled ? null : nonsensitive(azurerm_storage_account.storage_account.primary_access_key) 
}

output "azure_files_share" {
  value = azurerm_storage_share.azurefileshare.name
}

output "azure_files_protocol" {
  value = var.nfs_share_enabled ? "nfs" : "smb"
}

output "helm_sample_command" {
    # Example helm command:
  value = "helm upgrade -i HELM_INSTALLATION_NAME fio-perf-job-1.0.0.tgz -f fio-perf-job/values.yaml --set-file=fioconfig=./fio-perf-job/config/fiorandreadiops.ini --set storageclass.parameters.storageAccountName=${azurerm_storage_account.storage_account.name} --set storageclass.parameters.protocol=${var.nfs_share_enabled ? "nfs" : "smb"}"
}

output "create_secret" {
    value = var.nfs_share_enabled ? null : "kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=${azurerm_storage_account.storage_account.name} --from-literal=azurestorageaccountkey=${nonsensitive(azurerm_storage_account.storage_account.primary_access_key)}"
}
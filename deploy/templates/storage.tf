data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_storage_account" "storage_account" {
  for_each = toset(var.list) 
  name = each.value
  //count = 5
 // name = "dapolina${count.index}"  
  resource_group_name = azurerm_resource_group.aks-rg.name
  location = azurerm_resource_group.aks-rg.location
  account_tier = var.account_tier
  account_kind = var.account_kind
  account_replication_type = "LRS"

  enable_https_traffic_only = false
  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Deny"
    ip_rules = [
      "${chomp(data.http.myip.body)}"
    ]
    virtual_network_subnet_ids = [azurerm_subnet.akssubnet.id]
  }
  share_properties {
    smb {
        multichannel_enabled = true
    }
  }
}

locals {
    flat_list = setproduct(var.list, var.containers)
}

resource "azurerm_storage_share" "azurefileshare" {
//  for_each             = {for idx, val in local.flat_list: idx => val}
for_each = azurerm_storage_account.storage_account
  name                 = var.nfs_share_enabled ? "nfsshare" : "smbshare"  
  quota                = 51200  
  storage_account_name = each.value.name
  enabled_protocol     = var.nfs_share_enabled ? "NFS" : "SMB"  
}

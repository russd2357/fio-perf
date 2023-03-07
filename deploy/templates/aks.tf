provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "aks-rg" {
  name     = "aks-rg"
  location = var.azure_location
}

resource "azurerm_user_assigned_identity" "aks_master_identity" {
  name                = "aks-master-identity"
  resource_group_name = azurerm_resource_group.aks-rg.name
  location            = azurerm_resource_group.aks-rg.location
}

resource "azurerm_kubernetes_cluster" "aks_c" {
  name                      = var.aksname
  location                  = azurerm_resource_group.aks-rg.location
  resource_group_name       = azurerm_resource_group.aks-rg.name
  dns_prefix                = var.aksname
  workload_identity_enabled = true
  oidc_issuer_enabled       = true
  sku_tier                  = "Paid"

  auto_scaler_profile {
    expander                   = "most-pods"
    scan_interval              = "60s"
    empty_bulk_delete_max      = "100"
    scale_down_delay_after_add = "4m"
    scale_down_unready         = "4m"
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
  }

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.system_vm_sku
    vnet_subnet_id      = azurerm_subnet.akssubnet.id
    enable_auto_scaling = false
    kubelet_disk_type   = "Temporary"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_master_identity.id]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "spotpool" {
  name                  = "spotpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_c.id
  node_count            = var.node_count
  vm_size               = var.nodepool_vm_sku
  vnet_subnet_id        = azurerm_subnet.akssubnet.id
  priority              = "Spot"
  enable_auto_scaling   = true
  max_count             = 100
  min_count             = 1
  kubelet_disk_type     = "Temporary"

}

data "azurerm_subscription" "current_sub" {
}
# kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=${azurerm_storage_account.storage_account.name} --from-literal=azurestorageaccountkey=${azurerm_storage_account.storage_account.primary_access_key}
resource "null_resource" "azure_files_secret_smb" {
  provisioner "local-exec" {
    when    = create
    command = <<EOF
    az aks get-credentials --resource-group ${azurerm_resource_group.aks-rg.name} --name ${azurerm_kubernetes_cluster.aks_c.name} --overwrite-existing
    
  EOF
  }
  depends_on = [
    azurerm_kubernetes_cluster_node_pool.spotpool
  ]
}

resource "azurerm_role_assignment" "rbac_assignment_sub_network_c" {
  scope                = data.azurerm_subscription.current_sub.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_c.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "rbac_assignment_sub_managed_mi_c" {
  scope                = data.azurerm_subscription.current_sub.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_c.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "rbac_assignment_sub_managed_mi_o" {
  scope                = data.azurerm_subscription.current_sub.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.aks_c.kubelet_identity[0].object_id
}


resource "azurerm_role_assignment" "rbac_assignment_sub_managed_mi_reader" {
  scope                = data.azurerm_subscription.current_sub.id
  role_definition_name = "Reader"
  principal_id         = azurerm_kubernetes_cluster.aks_c.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "rbac_assignment_sub_managed_vm_c" {
  scope                = data.azurerm_subscription.current_sub.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_c.kubelet_identity[0].object_id
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_c.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks_c.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks_c.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_c.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_c.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_c.kube_config.0.cluster_ca_certificate)
}
resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.azure_files_secret_smb]

  create_duration = "120s"
}


resource "kubernetes_secret" "sa_key" {
  metadata {
    name = "azure-secret"
  }

  data = {
    azurestorageaccountname = azurerm_storage_account.storage_account.name
    azurestorageaccountkey = azurerm_storage_account.storage_account.primary_access_key
  }
  depends_on = [time_sleep.wait_30_seconds]
}
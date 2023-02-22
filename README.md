# Benchmarking Azure Files with FIO on AKS

## Overview

Azure Files is Microsoft Azure's managed  cloud file system that offers customers the ability to mount file shares from the cloud or on-premises while leveraging SMB and NFS protocols. This repo contains several deployments scripts using a packaged helm chart that enable an end-user to conduct file throughput and IOPS performance tests on a single Azure Files share.

## Artifacts

This repo contains several artifacts to enable a the deployment of full test environment with several clients running on AKS to run a stress test on Azure Files.

* A Terraform script that deploys an AKS Cluster and Azure Files (An NFS or SMB share can be selected using a terraform variable setting)
* A prepacked Helm Chart that deploys fio with several clients
* A DockerFile containing the shell script to build and/or customize the Docker image to push to a local container repo of your choice

## Deployment

### Terraform Infrastructure Deployment

## Prerequisites

This deployment assumes that you have an Azure subscription with owner privileges. This setup deploys several Azure Resources and grants RBAC roles to the AKS user managed identity to successfully enable an end-to-end test.

#### Resources

| Terraform Resource Type | Description |
| - | - |
| `azurerm_resource_group` | The resource group all resources get deployed into. |
| `azurerm_virtual_network` | The VNET used for all resources. |
| `azurerm_subnet` | The subnet used for AKS. |
| `azurerm_user_assigned_identity` | The user managed identity used for the AKS API server. |
| `azurerm_kubernetes_cluster` | An AKS cluster used to run the fio pod clients. |
| `azurerm_kubernetes_cluster_node_pool` | An optional spot instance pool. |
| `azurerm_storage_account` | An azure storage account used to host the Azure Files share |
| `azurerm_storage_share` | An NFS or SMB Azure Files share |
| `null_resource` | A null resource to retrieve the storage account key and create a kubernetes secret. |
| `azurerm_role_assignment` | Several RBAC role assignments to grant the proper permissions to AKS. |
| `azurerm_log_analytics_workspace` | A log analytics workspace to store the storage account performance metrics. |
| `azurerm_monitor_diagnostic_setting` | An Azure monitor storage diagnostics setting to enable the file share to save performance metrics to the log analytics workspace. |

## Variables

| Name | Description | Default |
|-|-|-|
| aksname | The name of the AKS cluster | - |
| storageaccountname | Storage tier for the storage account | dapolinasafileperf |
| account_tier | The Azure region used for deployments | Premium |
| nfs_share_enabled | The value to enable NFS or SMB | false |
| node_count | Number of nodes in the system node pool | 1 |
| account_kind | Storage account kind | FileStorage |
| azure_location | The Azure region used for deployments | centralus |
| system_vm_sku | VM SKU for the system node pool | standard_d2_v2 |
| nodepool_vm_sku | VM SKU for the node pool | Standard_D8d_v4 |
| node_count | Number of nodes in the system node pool | 1 |
| service_cidr | Service CIDR | 10.211.0.0/16 |
| dns_service_ip | dns_service_ip | 10.211.0.10 |
| docker_bridge_cidr | Docker bridge CIDR | 172.17.0.1/16 |

## Usage

```bash
terraform init

terraform plan -var-file="testing.tfvars" -out demo.tfplan

terraform apply "demo.tfplan"
```




variable "aksprefix" {
  type        = string
  default     = "daaks"
  description = "The AKS prefix"
}

variable "storageaccountnameprefix" {
  type        = string
  default     = "dapol"
  description = "The storage account name prefix"
}

variable "account_tier" {
  type        = string
  default     = "Premium"
  description = "Storage tier for the storage account"
}

variable "nfs_share_enabled" {
  type        = bool
  default     = false
  description = "value to enable NFS or SMB"
}

variable "num_storage_accounts" {
  default = 1
}

variable "account_kind" {
  type        = string
  default     = "FileStorage"
  description = "Storage account kind"
}

variable "azure_location" {
  type        = string
  default     = "centralus"
  description = "The location of Azure resources"
}

variable "system_vm_sku" {
  type        = string
  default     = "standard_d2_v2"
  description = "VM SKU for the system node pool"
}

variable "node_count" {
  default     = 1
  description = "Number of nodes in the system node pool"
}

variable "nodepool_vm_sku" {
  type        = string
  default     = "Standard_D8d_v4"
  description = "VM SKU for the node pool"
}

variable "service_cidr" {
  description = "Service CIDR"
  default     = "10.211.0.0/16"
}

variable "dns_service_ip" {
  description = "dns_service_ip"
  default     = "10.211.0.10"
}

variable "docker_bridge_cidr" {
  description = "Docker bridge CIDR"
  default     = "172.17.0.1/16"
}

variable "aksname" {
  type    = string
  default = "dapolinafilesperf"
}

variable "list" {
  type        = list(string)
  description = "storage accounts"
  default = [ "dapolinafilesperf01"]
}

variable "containers" {
  type        = list(string)
  description = "list of shares"
  default = [ "fileshare01"]
}
variable "storageaccountname" {
  type    = string
  default = "dapolinasafileperf"
}

variable "account_tier" {
  type = string
  default = "Premium"
  
}

variable "nfs_share_enabled" {
  type = bool
  default = false
}

variable "num_storage_accounts" {
  default = 1 
}


variable "account_kind" {
  type = string
  default = "FileStorage"
}

variable "azure_location" {
  type    = string
  default = "centralus"
}



variable "vm_sku" {
  type    = string
  default = "Standard_D2_v2"
}

variable "node_count" {
  default = 1
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
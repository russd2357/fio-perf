variable "aksname" {
  type    = string
  default = "dapolinafilesperf"
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
variable "seed" {
  type = string
}

variable "enable_external_workers" {
  type = bool
}

variable "region" {
  type        = string
  description = "The region to create the GKE cluster in"
}

variable "ip_cidr_range" {
  type        = string
  description = "The IP CIDR range for the GKE cluster"
}

variable "secondary_ip_range_for_services" {
  type        = string
  description = "The secondary IP range for services"
}

variable "secondary_ip_range_for_pods" {
  type        = string
  description = "The secondary IP range for pods"
}

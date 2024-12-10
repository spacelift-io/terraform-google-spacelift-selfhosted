variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the GKE cluster in"
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

variable "gke_service_account_email" {
  type        = string
  description = "The email of the service account to use for GKE nodes"
}

variable "compute_network_id" {
  type        = string
  description = "The ID of the network to create the GKE cluster in"
}

variable "compute_network_name" {
  type        = string
  description = "The name of the network to create the GKE cluster in"
}



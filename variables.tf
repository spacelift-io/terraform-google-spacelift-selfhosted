variable "region" {
  description = "Identifier of the GCP region to deploy the infrasturcure into."
}

variable "project" {
  description = "Identifier of the GCP project to deploy the infrastructure into."
}

variable "license_token" {
  description = "License token for the Self-Hosted instance."
  sensitive   = true
}

variable "website_domain" {
  description = "Domain name for the Spacelift frontend with protocol (e.g. https://mycompany.spacelift.com). This is used as a CORS origin for the state uploads bucket."
}

variable "database_edition" {
  description = "Edition of the Cloud SQL instance. Can be either ENTERPRISE or ENTERPRISE_PLUS."
  default     = "ENTERPRISE"

  validation {
    condition     = var.database_edition == "ENTERPRISE" || var.database_edition == "ENTERPRISE_PLUS"
    error_message = "Database edition must be either ENTERPRISE or ENTERPRISE_PLUS."
  }
}

variable "database_tier" {
  description = "Tier of the Cloud SQL instance."
  default     = "db-perf-optimized-N-4"
}

variable "create_compute_address_for_mqtt" {
  type        = bool
  description = "Whether to create a compute address for MQTT. It is meant to be used by Service of type LoadBalancer from the GKE cluster to expose the embedded MQTT server to the world. This is only required if you want to run worker outside of the GKE cluster."
  default     = false
}

variable "ip_cidr_range" {
  type        = string
  description = "The IP CIDR range for the subnetwork used by the GKE cluster"
  default     = "10.0.0.0/16"
}

variable "secondary_ip_range_for_services" {
  type        = string
  description = "The secondary IP range for the subnetwork used by the GKE cluster. This range is used for services"
  default     = "192.168.16.0/22"
}

variable "secondary_ip_range_for_pods" {
  type        = string
  description = "The secondary IP range for the subnetwork used by the GKE cluster. This range is used for pods"
  default     = "192.168.0.0/20"
}

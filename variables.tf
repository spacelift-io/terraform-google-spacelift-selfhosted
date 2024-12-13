variable "region" {
  description = "Identifier of the GCP region to deploy the infrasturcure into."
}

variable "project" {
  description = "Identifier of the GCP project to deploy the infrastructure into."
}

variable "website_domain" {
  description = "Domain name for the Spacelift frontend without protocol (e.g. spacelift.mycompany.com). This is used as a CORS origin for the state uploads bucket."
}

variable "labels" {
  type        = map(string)
  description = "Map of labels to apply to the resources"
  default     = {}
}

variable "k8s_namespace" {
  type        = string
  description = "The namespace in which the Spacelift backend is deployed to"
  default     = "spacelift"
}

variable "app_service_account_name" {
  type        = string
  description = "The name of the service account used by the Spacelift app in the GKE cluster"
  default     = "spacelift-backend"
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
  default     = "db-n1-standard-8"
}

variable "database_deletion_protection" {
  type        = bool
  description = "Whether the database should have deletion protection enabled"
  default     = true
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

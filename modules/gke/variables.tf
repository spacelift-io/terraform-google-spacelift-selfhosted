variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the GKE cluster in"
}

variable "region" {
  type        = string
  description = "The region to create the GKE cluster in"
}

variable "backend_service_account_id" {
  type        = string
  description = "ID of the service account of the application"
}

variable "app_service_account_name" {
  type        = string
  description = "The name of the service account used by the Spacelift app in the GKE cluster"
}

variable "compute_network_id" {
  type        = string
  description = "The ID of the network to create the GKE cluster in"
}

variable "subnetwork" {
  type = object({
    id = string
    self_link = string
  })
}

variable "services_ip_range_name" {
  type = string
}

variable "pods_ip_range_name" {
  type = string
}

variable "compute_network_name" {
  type        = string
  description = "The name of the network to create the GKE cluster in"
}

variable "gke_service_account_email" {
  type        = string
  description = "The email of the service account to use for GKE nodes"
}

variable "k8s_namespace" {
  type        = string
  description = "The namespace in which the Spacelift backend is deployed to"
}

variable "seed" {
  type = string
}

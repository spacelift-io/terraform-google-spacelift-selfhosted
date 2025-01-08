variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the GKE cluster in"
}

variable "region" {
  type        = string
  description = "The region to create the GKE cluster in"
}

variable "enabled" {
  type        = bool
  description = "Switch this to false to disable deployment of a GKE cluster."
}

variable "backend_service_account_id" {
  type        = string
  description = "ID of the service account of the application"
}

variable "app_service_account_name" {
  type        = string
  description = "The name of the service account used by the Spacelift app in the GKE cluster"
}

variable "subnetwork" {
  type = object({
    id        = string
    self_link = string
    secondary_ip_range = list(object({
      range_name : string,
    }))
  })
}

variable "network" {
  type = object({
    id : string,
    name : string,
  })
  description = "The network to create the GKE cluster in"
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

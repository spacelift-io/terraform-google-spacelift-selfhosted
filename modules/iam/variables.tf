variable "seed" {
  type = string
}

variable "enable_gke" {
  type = bool
}

variable "node_service_account" {
  type = object({
    email : string
  })
}

variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the Spacelift infrastucture in"
}

variable "app_service_account_name" {
  type        = string
  description = "The name of the service account used by the Spacelift app in the GKE cluster"
}

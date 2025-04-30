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

variable "enable_database" {
  type        = bool
  default     = true
  description = "Switch this to false if you don't want to deploy a new Cloud SQL instance for Spacelift."
}

variable "enable_gke" {
  type        = bool
  default     = true
  description = "Switch this to false to disable deployment of a GKE cluster."
}

variable "enable_network" {
  type        = bool
  default     = true
  description = "Switch this to false to disable creating a new VPC. In that case you need to reference network and subnetwork variables."
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

variable "enable_external_workers" {
  type        = bool
  description = "Switch this to true if you want to run workers from outside of the GCP infrastructure."
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

variable "node_service_account" {
  type = object({
    email : string,
  })
  default     = null
  description = "If GKE is disabled, provide your existing cluster default node service account here. This is used to grant privileges of your cluster to pull docker images."
}

variable "network" {
  type = object({
    id : string,
    name : string,
    self_link : string,
  })
  default     = null
  description = "If enable_network is set to false, pass a reference to an existing google_compute_network"
}

variable "subnetwork" {
  type = object({
    id = string
    name : string,
    self_link = string
    secondary_ip_range = list(object({
      range_name : string,
    }))
  })
  description = "If enable_network is set to false, pass a reference to an existing google_compute_subnetwork"
  default     = null
}

variable "license_token" {
  type        = string
  description = "The JWT token for using Spacelift. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
  sensitive   = true
}

variable "encryption_rsa_private_key" {
  type        = string
  description = "The RSA private key of the Spacelift instance. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
  sensitive   = true
}

variable "spacelift_public_api" {
  type        = string
  description = "The public API to use when sending usage data. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
}

variable "spacelift_version" {
  type        = string
  description = "The version of Spacelift being installed. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
}

variable "admin_username" {
  type        = string
  description = "The username for the Spacelift admin account. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
}

variable "admin_password" {
  type        = string
  description = "The password for the Spacelift admin account. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
  sensitive   = true
}

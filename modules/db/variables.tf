variable "database_tier" {
  type = string
}

variable "database_edition" {
  description = "Edition of the Cloud SQL instance. Can be either ENTERPRISE or ENTERPRISE_PLUS."

  validation {
    condition     = var.database_edition == "ENTERPRISE" || var.database_edition == "ENTERPRISE_PLUS"
    error_message = "Database edition must be either ENTERPRISE or ENTERPRISE_PLUS."
  }
}

variable "database_deletion_protection" {
  type        = bool
  description = "Whether the database should have deletion protection enabled"
}

variable "backend_service_account_email" {
  type        = string
  description = "The email of the service account to use for backend services"
}

variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the DB in"
}

variable "network_link" {
  type        = string
  description = "The URI of the network to which the database instance is connected"
}

variable "compute_network_id" {
  type        = string
  description = "The ID of the network to which the database instance is connected"
}

variable "database_private_ip_name" {
  type        = string
  description = "The name of the private IP for the database instance"
}

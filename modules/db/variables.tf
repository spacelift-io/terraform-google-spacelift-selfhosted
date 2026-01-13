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

variable "database_version" {
  type        = string
  description = "Database version for Cloud SQL instance (e.g., POSTGRES_14, POSTGRES_15, POSTGRES_16)"
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

variable "network" {
  type = object({
    id : string,
    self_link : string,
  })
  description = "The network to which the database instance is connected"
}

variable "seed" {
  type = string
}

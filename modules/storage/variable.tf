variable "region" {
  type        = string
  description = "Region where the buckets should be created"
}

variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the storage in"
}

variable "backend_service_account_email" {
  type        = string
  description = "Email of the service account of the application"
}

variable "cors_origins" {
  type        = list(string)
  description = "List of allowed origins for CORS. This is being used for state uploads during Stack creations. Example: [\"https://spacelift.mycorp.com\"]"
}

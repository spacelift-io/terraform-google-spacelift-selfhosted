variable "license_token" {
  description = "License token for the Self-Hosted instance"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The region to create the secret in"
}

variable "labels" {
  type        = map(string)
  description = "Map of labels to apply to the Artifact Registry repository"
}

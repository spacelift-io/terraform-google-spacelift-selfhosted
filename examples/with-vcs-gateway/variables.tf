variable "region" {
  type        = string
  description = "Identifier of the GCP region to deploy the infrastructure into."
}

variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the infrastructure into."
}

variable "server_domain" {
  type        = string
  description = "The domain that Spacelift is being hosted on without protocol and port. Eg.: 'spacelift.mycorp.io'."
}

variable "vcs_gateway_domain" {
  type        = string
  description = "The domain for the VCS Gateway external endpoint without protocol and port. Eg.: 'vcs-gateway.mycorp.io'."
}

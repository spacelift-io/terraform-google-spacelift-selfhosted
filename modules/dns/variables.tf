variable "seed" {
  type = string
}

variable "enable_external_workers" {
  type = bool
}

variable "website_domain" {
  type = string
  description = "Domain name for the Spacelift frontend without protocol (e.g. spacelift.mycompany.com)."
}

variable "compute_network_id" {
  type        = string
  description = "The ID of the network to create the GKE cluster in"
}

variable "gke_public_v4_address" {
  type = string
}

variable "gke_public_v6_address" {
  type = string
}

variable "mqtt_subdomain" {
  type = string
  default = "mqtt"
}

variable "mqtt_service_alias" {
  type = string
  default = "spacelift-mqtt.spacelift.svc.cluster.local."
}

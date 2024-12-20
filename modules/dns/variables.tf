locals {
  mqtt_service_alias = "spacelift-mqtt.${var.k8s_namespace}.svc.cluster.local."
}

variable "seed" {
  type = string
}

variable "enable_external_workers" {
  type = bool
}

variable "website_domain" {
  type        = string
  description = "Domain name for the Spacelift frontend without protocol (e.g. spacelift.mycompany.com)."
}

variable "network" {
  type = object({
    id : string,
  })
  description = "The network to create the GKE cluster in."
}

variable "gke_public_v4_address" {
  type = string
}

variable "gke_public_v6_address" {
  type = string
}

variable "mqtt_subdomain" {
  type    = string
  default = "mqtt"
}

variable "k8s_namespace" {
  type        = string
  description = "The namespace in which the Spacelift backend is deployed to"
}

variable "project" {
  type        = string
  description = "Identifier of the GCP project to deploy the GKE cluster in"
}

variable "region" {
  type        = string
  description = "The region to create the GKE cluster in"
}

variable "backend_service_account_id" {
  type        = string
  description = "ID of the service account of the application"
}

variable "app_service_account_name" {
  type        = string
  description = "The name of the service account used by the Spacelift app in the GKE cluster"
}

variable "compute_network_id" {
  type        = string
  description = "The ID of the network to create the GKE cluster in"
}

variable "compute_network_name" {
  type        = string
  description = "The name of the network to create the GKE cluster in"
}

variable "create_compute_address_for_mqtt" {
  type        = bool
  description = "Whether to create a compute address for MQTT. It is meant to be used by Service of type LoadBalancer from the GKE cluster to expose the embedded MQTT server to the world. This is only required if you want to run worker outside of the GKE cluster."
}

variable "ip_cidr_range" {
  type        = string
  description = "The IP CIDR range for the GKE cluster"
}

variable "secondary_ip_range_for_services" {
  type        = string
  description = "The secondary IP range for services"
}

variable "secondary_ip_range_for_pods" {
  type        = string
  description = "The secondary IP range for pods"
}

variable "gke_service_account_email" {
  type        = string
  description = "The email of the service account to use for GKE nodes"
}

variable "k8s_namespace" {
  type        = string
  description = "The namespace in which the Spacelift backend is deployed to"
}

output "subnetwork" {
  value = length(google_compute_subnetwork.default) == 1 ? google_compute_subnetwork.default[0] : null
}

output "network" {
  value = length(google_compute_network.default) == 1 ? google_compute_network.default[0] : null
}

output "gke_public_v4_address" {
  value       = google_compute_global_address.gke-public-v4.address
  description = "Public IPv4 address for GKE Ingresses"
}

output "gke_public_v4_name" {
  value       = google_compute_global_address.gke-public-v4.name
  description = "Public IPv4 address for GKE Ingresses"
}

output "gke_public_v6_address" {
  value       = google_compute_global_address.gke-public-v6.address
  description = "Public IPv6 address for GKE Ingresses"
}

output "gke_public_v6_name" {
  value       = google_compute_global_address.gke-public-v6.name
  description = "Public IPv4 address for GKE Ingresses"
}

output "mqtt_v4_address" {
  value       = length(google_compute_address.mqtt-v4) == 1 ? google_compute_address.mqtt-v4[0].address : ""
  description = "Public IPv4 address for MQTT traffic."
}

output "mqtt_v4_name" {
  value       = length(google_compute_address.mqtt-v4) == 1 ? google_compute_address.mqtt-v4[0].name : ""
  description = "Public IPv4 address for MQTT traffic."
}

output "mqtt_v6_address" {
  value       = length(google_compute_address.mqtt-v6) == 1 ? google_compute_address.mqtt-v6[0].address : ""
  description = "Public IPv6 address for MQTT traffic."
}

output "mqtt_v6_name" {
  value       = length(google_compute_address.mqtt-v6) == 1 ? google_compute_address.mqtt-v6[0].name : ""
  description = "Public IPv6 address for MQTT traffic."
}

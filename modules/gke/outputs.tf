output "gke_subnetwork_id" {
  value       = google_compute_subnetwork.default.id
  description = "The ID of the subnetwork that the GKE cluster was created in"
}

output "gke_subnetwork_name" {
  value       = google_compute_subnetwork.default.name
  description = "The name of the subnetwork that the GKE cluster was created in"
}

output "gke_cluster_name" {
  value       = google_container_cluster.spacelift.name
  description = "The name of the GKE cluster"
}

output "mqtt_ipv4_address" {
  value       = var.create_compute_address_for_mqtt ? google_compute_address.gke-mqtt-v4[0].address : null
  description = "The IPv4 address of the MQTT service"
}

output "mqtt_ipv6_address" {
  value       = var.create_compute_address_for_mqtt ? google_compute_address.gke-mqtt-v6[0].address : null
  description = "The IPv6 address of the MQTT service"
}
